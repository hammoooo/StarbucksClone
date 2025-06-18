//
//import Foundation
//
//struct TokenInfo: Codable {
//    let accessToken: String
//    let refreshToken: String
//}


import Foundation

protocol TokenProviding {
    var accessToken: String? { get set }
    func refreshToken(completion: @escaping (String?, Error?) -> Void)
}

struct TokenResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: UserInfo
}

struct TokenInfo: Codable {
    let accessToken: String
    let refreshToken: String
}
