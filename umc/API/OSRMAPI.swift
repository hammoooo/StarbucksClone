import Foundation
import Moya
import MapKit



enum OSRMAPI: TargetType {
    case route(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D)

    var baseURL: URL {
      
        return URL(string: Config.baseURL)!
    }

    var path: String {
            switch self {
            case .route(let start, let end):
                return "/route/v1/walking/\(start.longitude),\(start.latitude);\(end.longitude),\(end.latitude)"
            }
        }

    var method: Moya.Method { .get }

    var task: Task {
        .requestParameters(parameters: [
            "overview": "full",
            "geometries": "geojson"
        ], encoding: URLEncoding.queryString)
    }

    var headers: [String : String]? { nil }

    var sampleData: Data {
        // 아래 2번 항목 참고!
        try! JSONEncoder().encode(GeoJSONRoute.sample)
    }
    
    
    
    
//    var sampleData: Data {
//           // 샘플 GeoJSON Polyline 응답
//           return """
//           {
//             "routes": [{
//               "geometry": {
//                 "coordinates": [
//                   [127.01, 37.55],
//                   [127.02, 37.56],
//                   [127.03, 37.57]
//                 ],
//                 "type": "LineString"
//               }
//             }]
//           }
//           """.data(using: .utf8)!
//       }
}




struct GeoJSONRoute: Codable {
    let routes: [Route]

    struct Route: Codable {
        let geometry: Geometry
    }

    struct Geometry: Codable {
        let coordinates: [[Double]]  // [longitude, latitude]
    }

    static let sample: GeoJSONRoute = .init(routes: [
        .init(geometry: .init(coordinates: [
            [127.0321, 37.5631],
            [127.0331, 37.5641],
            [127.0341, 37.5651]
        ]))
    ])
}


