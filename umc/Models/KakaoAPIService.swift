import Foundation
import Alamofire
import AuthenticationServices

struct KakaoToken: Decodable {
    let access_token:  String
    let refresh_token: String
}

struct KakaoUser: Decodable {
    struct Props: Decodable { let nickname: String? }
    let id: Int64
    let properties: Props?
}

protocol KakaoAPIType {
    func requestAuthCode() async throws -> String
    func exchangeCode(for code: String) async throws -> KakaoToken
    func fetchUser(token: String) async throws -> KakaoUser
}

final class KakaoAPIService: NSObject, KakaoAPIType {
    private let restApiKey = "<REST_API_KEY>"
    private let redirectURI = "myapp://oauth"
    
    func requestAuthCode() async throws -> String {
        try await withCheckedThrowingContinuation { cont in
            let urlString = "https://kauth.kakao.com/oauth/authorize"
                + "?response_type=code&client_id=\(restApiKey)&redirect_uri=\(redirectURI)"
            let url = URL(string: urlString)!
            
            // 👉 세션을 변수로 만든 다음 provider 프로퍼티를 대입
            let session = ASWebAuthenticationSession(url: url,
                                                     callbackURLScheme: "myapp") { cbURL, err in
                if let err = err { cont.resume(throwing: err); return }
                guard
                    let code = URLComponents(url: cbURL!, resolvingAgainstBaseURL: false)?
                        .queryItems?.first(where: { $0.name == "code" })?.value
                else { cont.resume(throwing: URLError(.badServerResponse)); return }
                cont.resume(returning: code)
            }
            session.presentationContextProvider = self
            session.start()
        }
    }

    
    func exchangeCode(for code: String) async throws -> KakaoToken {
        let params: [String: String] = [
            "grant_type":   "authorization_code",
            "client_id":    restApiKey,
            "redirect_uri": redirectURI,
            "code":         code
        ]

        return try await AF.request(
            "https://kauth.kakao.com/oauth/token",
            method: .post,
            parameters: params,
            encoding: URLEncoding.default        
        )
        .validate()
        .serializingDecodable(KakaoToken.self)
        .value
    }

    
    func fetchUser(token: String) async throws -> KakaoUser {
        let headers: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        return try await AF.request(
            "https://kapi.kakao.com/v2/user/me",
            headers: headers
        ).serializingDecodable(KakaoUser.self).value
    }
}

extension KakaoAPIService: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        UIApplication.shared.windows.first!
    }
}
