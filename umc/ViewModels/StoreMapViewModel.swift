import Foundation
import MapKit
import SwiftUI

class StoreMapViewModel: ObservableObject {
    @Published var selectedSegment: StoreMapSegment = .store
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @Published var stores: [Store] = []

    init() {
        loadGeoJSON()
    }

    func moveToCurrentLocation() {
        LocationManager.shared.requestLocation { location in
            guard let location = location else { return }
            DispatchQueue.main.async {
                self.region.center = location.coordinate
            }
        }
    }

    func loadGeoJSON() {
        guard let url = Bundle.main.url(forResource: "starbucks_2025", withExtension: "geojson"),
              let data = try? Data(contentsOf: url) else {
            print("GeoJSON 파일을 불러올 수 없습니다.")
            return
        }

        do {
            let features = try MKGeoJSONDecoder().decode(data).compactMap { $0 as? MKGeoJSONFeature }
            var loadedStores: [Store] = []

            for feature in features {
                guard let point = feature.geometry.first as? MKShape & MKGeoJSONObject else { continue }
                let coordinate = point.coordinate

                if let propertiesData = feature.properties,
                   let json = try? JSONSerialization.jsonObject(with: propertiesData) as? [String: Any],
                   let name = json["Sotre_nm"] as? String,
                   let address = json["Address"] as? String {

                    // ✅ 대소문자 주의: Category
                    let rawCategory = json["Category"] as? String ?? ""
                    let category: StoreCategory
                    switch rawCategory {
                    case "리저브 매장":
                        category = .reserve
                    case "드라이브 스루":
                        category = .dt
                    default:
                        category = .normal
                    }

                    // ✅ 핀 이미지는 고정값 사용
                    let imageName = "starbucks_pin"

                    let store = Store(
                        name: name,
                        latitude: coordinate.latitude,
                        longitude: coordinate.longitude,
                        category: category,
                        imageName: imageName,
                        address: address
                    )

                    loadedStores.append(store)
                }
            }

            DispatchQueue.main.async {
                print("불러온 매장 수: \(loadedStores.count)")
                self.stores = loadedStores
            }
        } catch {
            print("GeoJSON 파싱 실패: \(error.localizedDescription)")
        }
    }
}

enum StoreMapSegment: String, CaseIterable {
    case store = "매장 찾기"
    case direction = "길찾기"
}
