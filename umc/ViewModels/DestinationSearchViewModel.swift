

import Foundation
import MapKit
import Observation
import Moya

final class DestinationSearchViewModel: ObservableObject {
    @Published var keyword: String = ""
    @Published var results: [Store] = []
    
    private let provider = MoyaProvider<OSRMAPI>()
    @Published var routeCoordinates: [CLLocationCoordinate2D] = []
    @Published var isLoadingRoute: Bool = false
    
    private var allStores: [Store] = []
    
    init() {
        loadStoresFromGeoJSON()
    }
    
    func loadStoresFromGeoJSON() {
        guard let url = Bundle.main.url(forResource: "starbucks_2025", withExtension: "geojson"),
              let data = try? Data(contentsOf: url) else {
            
            return
        }
        
        do {
            let features = try MKGeoJSONDecoder().decode(data)
                .compactMap { $0 as? MKGeoJSONFeature }
            
            self.allStores = features.compactMap { feature in
                guard let point = feature.geometry.first as? MKShape & MKGeoJSONObject else {
                    
                    return nil
                }
                
                guard let propsData = feature.properties,
                      let json = try? JSONSerialization.jsonObject(with: propsData) as? [String: Any],
                      let name = json["Sotre_nm"] as? String,
                      let address = json["Address"] as? String,
                      let rawCategory = json["Category"] as? String else {
                    
                    return nil
                }
                
                let category = parseCategory(from: rawCategory)
                
                return Store(
                    name: name,
                    latitude: point.coordinate.latitude,
                    longitude: point.coordinate.longitude,
                    category: category,
                    imageName: "",
                    address: address
                )
            }
            
            
        } catch {
            print("GeoJSON 디코딩 실패: \(error.localizedDescription)")
        }
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
    
    
    
    func search() {
        let trimmed = keyword.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        print("검색어: \(trimmed)")
        
        guard !trimmed.isEmpty else {
            results = []
            return
        }
        
        print("전체 매장 수: \(allStores.count)")
        
        let filtered = allStores.filter {
            $0.name.lowercased().contains(trimmed) || $0.address.lowercased().contains(trimmed)
        }
        
        let scored = filtered.map { store -> (Store, Int) in
            if store.name.lowercased() == trimmed {
                return (store, 0) // 정확히 일치
            } else if store.name.lowercased().contains(trimmed) {
                return (store, 1) // 일부 포함
            } else {
                return (store, 2) // 주소에 포함
            }
        }
        
        self.results = scored.sorted { $0.1 < $1.1 }.map { $0.0 }
        print("검색 결과 수: \(results.count)")
    }
    
    
    
    
    
    
    
    
    
    func fetchWalkingRoute(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) {
        isLoadingRoute = true
        
        provider.request(OSRMAPI.route(from: from, to: to)) { result in
            DispatchQueue.main.async {
                self.isLoadingRoute = false
            }
            
            switch result {
            case .success(let response):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data) as? [String: Any]
                    guard
                        let routes = json?["routes"] as? [[String: Any]],
                        let geometry = routes.first?["geometry"] as? [String: Any],
                        let coords = geometry["coordinates"] as? [[Double]]
                    else {
                        print("❌ 경로 파싱 실패")
                        return
                    }
                    
                    let path = coords.map { CLLocationCoordinate2D(latitude: $0[1], longitude: $0[0]) }
                    
                    DispatchQueue.main.async {
                        self.routeCoordinates = path
                    }
                    
                } catch {
                    print("❌ JSON 파싱 에러: \(error)")
                }
                
            case .failure(let error):
                print("❌ OSRM 요청 실패: \(error)")
            }
        }
    }
    
}
