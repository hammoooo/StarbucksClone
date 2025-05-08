import SwiftUI
import CoreLocation
import MapKit

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

    private let locationManager = CLLocationManager()

    init() {
        //requestLocation()
        //loadGeoJSON() 실사용

//        self.userLocation = CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780) // 서울시청임
//            self.region.center = self.userLocation!
//            loadGeoJSON()
        
        let fixedLocation = CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780)
           self.userLocation = fixedLocation
           self.region.center = fixedLocation
           self.loadGeoJSON()
    }
    
    

    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        if let location = locationManager.location?.coordinate {
            userLocation = location
            region.center = location
            filterStores()
        }
    }

    func loadGeoJSON() {
        guard let url = Bundle.main.url(forResource: "starbucks_2025", withExtension: "geojson") else {
            print("❌ GeoJSON 파일을 찾을 수 없습니다.")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(GeoJSONFeatureCollection.self, from: data)

            self.stores = decoded.features.compactMap { (feature: GeoJSONFeature) -> Store? in
                let props = feature.properties
                let coords = feature.geometry.coordinates
                guard coords.count == 2 else { return nil }

                let category: StoreCategory
                switch props.Category {
                case "R": category = .reserve
                case "D": category = .dt
                default:  category = .normal
                }

                // ✅ 매장 이름에 따른 이미지 자동 매핑
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

            print("✅ 파싱된 매장 수: \(stores.count)")
            filterStores()

        } catch {
            print("❌ GeoJSON 파싱 실패: \(error)")
        }
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
}
