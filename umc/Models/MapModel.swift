//import Foundation
//import MapKit
//
//struct Marker: Identifiable {
//    let id = UUID()
//    let coordinate: CLLocationCoordinate2D
//    let title: String
//}
import SwiftUI
import MapKit
import Observation
import Foundation

@Observable
final class MapViewModel {
    
    var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    var currentMapCenter: CLLocationCoordinate2D?
    
//    // 마커
//    var makers: [Marker] = [
//        .init(coordinate: .init(latitude: 37.504675, longitude: 126.957034), title: "중앙대학교"),
//        .init(coordinate: .init(latitude: 37.529598, longitude: 126.963946), title: "용산 CGV")
//    ]
}

struct Marker: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let title: String
}

//struct KakaoPlace: Decodable, Identifiable {
//    let id = UUID()
//    let place_name: String
//    let address_name: String
//    let x: String
//    let y: String
//}

struct KakaoPlace: Decodable, Identifiable {
    let id = UUID()
    let place_name: String
    let address_name: String
    let x: Double
    let y: Double

    enum CodingKeys: String, CodingKey {
        case place_name, address_name, x, y
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        place_name = try container.decode(String.self, forKey: .place_name)
        address_name = try container.decode(String.self, forKey: .address_name)
        x = Double(try container.decode(String.self, forKey: .x)) ?? 0.0
        y = Double(try container.decode(String.self, forKey: .y)) ?? 0.0
    }
}


struct KakaoSearchResponse: Decodable {
    let documents: [KakaoPlace]
}
