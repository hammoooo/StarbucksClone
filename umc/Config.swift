import Foundation

enum Config {
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist 없음")
        }
        return dict
    }()
    
    static let baseURL: String = {
        guard let baseURL = Config.infoDictionary["API_URL"] as? String else {
            fatalError("API_URL is missing in plist")
        }
        return baseURL
    }()
    static let kakaoRESTKey: String = {
           guard let key = Bundle.main.infoDictionary?["KAKAO_REST_API_KEY"] as? String else {
               fatalError("KAKAO_REST_API_KEY is missing in plist")
           }
           return key
       }()
    static let googleMapsKey: String = {
            guard let key = Config.infoDictionary["GOOGLE_MAP_API_KEY"] as? String else {
                fatalError("GOOGLE_MAP_API_KEY is missing in plist")
            }
            return key
        }()
}
