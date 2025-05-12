import Foundation
import Combine

@MainActor
final class AuthViewModel: ObservableObject {
    // Input
    @Published var email: String = ""
    @Published var password: String = ""
    
    // Output
    @Published private(set) var isSignedIn = false
    @Published var nickname = ""
    @Published var errorMessage: String?

    private let kakaoService: KakaoAPIType
    init(kakaoService: KakaoAPIType = KakaoAPIService()) {
        self.kakaoService = kakaoService
        tryAutoLogin()
    }

    // MARK: - 이메일 로그인
    func loginWithEmail() {
        Task {
            do {
                // ① 서버 인증 성공했다고 가정
                try KeychainService.save(Data(email.utf8),    for: .account)
                try KeychainService.save(Data(password.utf8), for: .password)
                nickname = email.components(separatedBy: "@").first ?? email
                isSignedIn = true
            } catch {
                errorMessage = "Keychain 저장 실패: \(error.localizedDescription)"
            }
        }
    }
    
    private func tryAutoLogin() {
        if let e = KeychainService.read(for: .account),
           let _ = KeychainService.read(for: .password) {
            nickname = String(decoding: e, as: UTF8.self)
            isSignedIn = true
        }
    }

    // MARK: - 카카오 로그인
    func loginWithKakao() {
        Task {
            do {
                let code   = try await kakaoService.requestAuthCode()
                let token  = try await kakaoService.exchangeCode(for: code)
                let user   = try await kakaoService.fetchUser(token: token.access_token)
                
                try KeychainService.save(Data(token.access_token.utf8),  for: .accessToken)
                try KeychainService.save(Data(token.refresh_token.utf8), for: .refreshToken)
                
                nickname = user.properties?.nickname ?? "카카오유저"
                isSignedIn = true
            } catch {
                errorMessage = "카카오 로그인 실패: \(error.localizedDescription)"
            }
        }
    }
    
    // MARK: - 로그아웃
    func signOut() {
        [KCKey.account, .password, .accessToken, .refreshToken].forEach(KeychainService.delete)
        isSignedIn = false
        email = ""; password = ""; nickname = ""
    }
}
