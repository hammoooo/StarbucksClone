
import Foundation
import MapKit
import SwiftUI

enum StoreMapSegment: String, CaseIterable {
    case store = "매장 찾기"
    case direction = "길찾기"
}

class StoreMapViewModel: ObservableObject {
    @Published var selectedSegment: StoreMapSegment = .store

    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )

    @Published var stores: [Store] = []

    @Published var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)

    init() {
        loadGeoJSON()
    }

    func moveToCurrentLocation() {
        LocationManager.shared.startUpdatingLocation()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            guard let location = LocationManager.shared.currentLocation else { return }
            self.region.center = location.coordinate
            LocationManager.shared.stopUpdatingLocation()
        }
    }

    func loadGeoJSON() {
        guard let data = loadGeoJSONFile(named: "starbucks_2025") else { return }

        do {
            let features = try decodeGeoJSONFeatures(from: data)
            var loadedStores = features.compactMap { parseStore(from: $0) }

            DispatchQueue.main.async {
                print("불러온 매장 수: \(loadedStores.count)")
                self.stores = loadedStores
                
                for index in self.stores.indices {
                    self.fetchPhotoReference(for: self.stores[index]) { photoRef in
                        DispatchQueue.main.async {
                            self.stores[index].photoReference = photoRef
                        }
                    }
                }
            }
        } catch {
            print("GeoJSON 파싱 실패: \(error.localizedDescription)")
        }
    }

    func fetchPhotoReference(for store: Store, completion: @escaping (String?) -> Void) {
        let gmsApiKey = Config.googleMapsKey
        let query = store.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(query)&key=\(gmsApiKey)"

        guard let url = URL(string: urlString) else {
            completion(nil); return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil); return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let results = json["results"] as? [[String: Any]],
                   let first = results.first,
                   let photos = first["photos"] as? [[String: Any]],
                   let photoRef = photos.first?["photo_reference"] as? String {
                    completion(photoRef)
                } else {
                    completion(nil)
                }
            } catch {
                completion(nil)
            }
        }.resume()
    }

    // MARK: - 헬퍼 함수

    private func loadGeoJSONFile(named name: String) -> Data? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "geojson"),
              let data = try? Data(contentsOf: url) else {
            print("GeoJSON 파일을 불러올 수 없습니다.")
            return nil
        }
        return data
    }

    private func decodeGeoJSONFeatures(from data: Data) throws -> [MKGeoJSONFeature] {
        let objects = try MKGeoJSONDecoder().decode(data)
        return objects.compactMap { $0 as? MKGeoJSONFeature }
    }

    private func parseStore(from feature: MKGeoJSONFeature) -> Store? {
        guard let point = feature.geometry.first as? MKShape & MKGeoJSONObject else { return nil }
        guard let propertiesData = feature.properties,
              let json = try? JSONSerialization.jsonObject(with: propertiesData) as? [String: Any],
              let name = json["Sotre_nm"] as? String,
              let address = json["Address"] as? String else {
            return nil
        }

        let coordinate = point.coordinate
        let category = parseCategory(from: json["Category"] as? String ?? "")
        let imageName = "starbucks_pin"

        return Store(
            name: name,
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            category: category,
            imageName: imageName,
            address: address
           
        )
    }

    private func parseCategory(from raw: String) -> StoreCategory {
        switch raw {
        case "리저브 매장":
            return .reserve
        case "드라이브 스루":
            return .dt
        default:
            return .normal
        }
    }
}




























