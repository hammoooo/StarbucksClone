import SwiftUI
import CoreLocation
import MapKit
import Moya
import Foundation

struct PlaceSearchResponse: Codable {
    let results: [PlaceResult]
}

struct PlaceResult: Codable {
    let photos: [PlacePhoto]?
}

struct PlacePhoto: Codable {
    let photo_reference: String
}


final class OrderSheetViewModel: ObservableObject {
    @Published var isMapMode: Bool = false
    @Published var selectedSegment: StoreListType = .nearby
    @Published var stores: [Store] = []
    @Published var filteredStores: [Store] = []
    @Published var userLocation: CLLocationCoordinate2D? = nil
    @Published var showRefreshButton = false
    @Published var cameraCenter: CLLocationCoordinate2D? = nil
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    let provider: MoyaProvider<GooglePlaceAPI>
      
      init(provider: MoyaProvider<GooglePlaceAPI> = APIManager.shared.createProvider(for: GooglePlaceAPI.self)) {
          self.provider = provider
      }
    

    private let locationManager = CLLocationManager()
    
    
    func configure() async {
        let fixedLocation = CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780)
        self.userLocation = fixedLocation
        self.region.center = fixedLocation
        await loadGeoJSON()
    }

    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        if let location = locationManager.location?.coordinate {
            userLocation = location
            region.center = location
            filterStores()
        }
    }
    
    func loadGeoJSON() async {
        guard let url = Bundle.main.url(forResource: "starbucks_2025", withExtension: "geojson") else {
            print("❌ GeoJSON 파일을 찾을 수 없습니다.")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(GeoJSONFeatureCollection.self, from: data)

            // 1. 모든 매장 파싱
            var allStores = decoded.features.compactMap { parseStore(from: $0) }

            // 2.서울시청 기준
//            let referenceLocation = userLocation ?? CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780)
            let referenceLocation = CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780)
            
            allStores.sort {
                let dist1 = CLLocation(latitude: $0.latitude, longitude: $0.longitude)
                    .distance(from: CLLocation(latitude: referenceLocation.latitude, longitude: referenceLocation.longitude))
                let dist2 = CLLocation(latitude: $1.latitude, longitude: $1.longitude)
                    .distance(from: CLLocation(latitude: referenceLocation.latitude, longitude: referenceLocation.longitude))
                return dist1 < dist2
            }

            // 3. 가까운 5개만 추출
            let nearestStores = Array(allStores.prefix(5))

            // 4. photoReference 비동기 요청
            var loadedStores: [Store] = []

            for var store in nearestStores {
                
                
                print("🟦 [fetch 시작] 매장명: \(store.name)")
                
                store.photoReference = await fetchPhotoReference(for: store.name)
                print("📍 \(store.name) → photoReference: \(store.photoReference ?? "없음")")
                loadedStores.append(store)
            }

            DispatchQueue.main.async {
                self.stores = loadedStores
                print("✅ 파싱된 가까운 매장 수: \(self.stores.count)")
                self.filterStores()
            }

        } catch {
            print("❌ GeoJSON 파싱 실패: \(error)")
        }
    }



    func parseStore(from feature: GeoJSONFeature) -> Store? {
        let props = feature.properties
        let coords = feature.geometry.coordinates
        guard coords.count == 2 else { return nil }

        let category: StoreCategory
        switch props.Category {
        case "R": category = .reserve
        case "D": category = .dt
        default:  category = .normal
        }

        let imageName: String
        switch props.Sotre_nm {
        case "서울역": imageName = "seoul_station"
        case "중앙대": imageName = "chungang_univ"
        case "포항대이": imageName = "pohang_daei"
        default: imageName = "default_image"
        }

        return Store(
            name: props.Sotre_nm,
            latitude: coords[1],
            longitude: coords[0],
            category: category,
            imageName: imageName,
            address: props.Address ?? "주소 없음"
        )
    }

    func filterStores() {
        guard let location = userLocation else {
            print("❗ userLocation이 nil입니다. 거리 계산 불가.")
            return
        }

        filteredStores = stores.filter {
            CLLocation(latitude: $0.latitude, longitude: $0.longitude)
                .distance(from: CLLocation(latitude: location.latitude, longitude: location.longitude)) < 10000
        }.sorted {
            CLLocation(latitude: $0.latitude, longitude: $0.longitude)
                .distance(from: CLLocation(latitude: location.latitude, longitude: location.longitude)) <
            CLLocation(latitude: $1.latitude, longitude: $1.longitude)
                .distance(from: CLLocation(latitude: location.latitude, longitude: location.longitude))
        }
    }

    func toggleMapListMode() {
        isMapMode.toggle()
    }

    func refreshMarkers(for center: CLLocationCoordinate2D) {
        cameraCenter = center
        showRefreshButton = false
        userLocation = center
        filterStores()
    }

//    func fetchPhotoReference(for query: String) async -> String? {
//        let provider = APIManager.shared.createProvider(for: GooglePlaceAPI.self)
//
//        return await withCheckedContinuation { continuation in
//            print("🌐 Moya 요청: query = \(query)")
//            provider.request(.textSearch(query: query)) { result in
//                switch result {
//                case .success(let response):
//                    do {
//                        // 📦 1. JSON을 문자열로 로깅 (디버깅용)
//                        if let raw = String(data: response.data, encoding: .utf8) {
//                            print("📦 Raw Response:\n\(raw)")
//                        }
//
//                        // ✅ 2. JSON 파싱
//                        guard
//                            let json = try JSONSerialization.jsonObject(with: response.data) as? [String: Any],
//                            let results = json["results"] as? [[String: Any]],
//                            let first = results.first,
//                            let photos = first["photos"] as? [[String: Any]],
//                            let photoRef = photos.first?["photo_reference"] as? String
//                        else {
//                            print("❌ photo_reference 추출 실패")
//                            continuation.resume(returning: nil)
//                            return
//                        }
//
//                        print("📸 추출된 photo_reference: \(photoRef)")
//                        continuation.resume(returning: photoRef)
//
//                    } catch {
//                        print("❌ JSON 파싱 실패: \(error.localizedDescription)")
//                        continuation.resume(returning: nil)
//                    }
//
//                case .failure(let error):
//                    print("❌ Moya 네트워크 실패: \(error.localizedDescription)")
//                    continuation.resume(returning: nil)
//                }
//            }
//        }
//    }
//
//
    
    
    

    
    
    
    func fetchPhotoReference(for query: String) async -> String? {
        
        do{
           // let provider = APIManager.shared.createProvider(for: GooglePlaceAPI.self)
            
            let starbucksQuery = "\(query)점 스타벅스"
            
            
            print("🌐 Moya 요청: query = \(starbucksQuery)")
            
            let response = try await provider.requestAsync(.textSearch(query: starbucksQuery))
            
            let decoded = try JSONDecoder().decode(PlaceSearchResponse.self, from: response.data)
            
            if let photoRef = decoded.results.first?.photos?.first?.photo_reference {
                print("📸 추출된 photo_reference: \(photoRef)")
                return photoRef;
                
            } else {
                print("⚠️ photo_reference 없음")
                return nil;
            }
            
            
        } catch{
            print("⚠️ photo_reference 없음")
           
        }
        return nil;
    }

    
    
    
    
    
    
}


extension MoyaProvider {
    func requestAsync(_ target: Target) async throws -> Response {
        try await withCheckedThrowingContinuation { continuation in
            self.request(target) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

