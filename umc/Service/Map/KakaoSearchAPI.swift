import Foundation
import CoreLocation
import Alamofire

final class KakaoSearchAPI {
    static let shared = KakaoSearchAPI()
    private let apiKey = Config.kakaoRESTKey

    func searchKeyword(_ keyword: String, at location: CLLocation) async -> [KakaoPlace] {

        let x = location.coordinate.longitude
        let y = location.coordinate.latitude
        let urlString = "https://dapi.kakao.com/v2/local/search/keyword.json"
        let headers: HTTPHeaders = ["Authorization": "KakaoAK \(apiKey)"]
        let parameters: [String: Any] = [
            "query": keyword,
            "radius": 5,
            "page": 1,
            "size": 15
        ]
        
        
  

        do {
            let response = try await AF.request(
                urlString,
                method: .get,
                parameters: parameters,
                headers: headers
            )
            .validate()
            .serializingDecodable(KakaoSearchResponse.self)
            .value
            print("response: \(response)")
            return response.documents
        } catch {
            print("Kakao search error:", error.localizedDescription)
            return []
        }
    }
}








