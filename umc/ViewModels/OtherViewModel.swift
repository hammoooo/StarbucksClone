import Foundation

class OtherViewModel: ObservableObject {
    @Published var nickname: String

    init() {
        let stored = UserDefaults.standard.string(forKey: "nickname")
        self.nickname = stored?.isEmpty == false ? stored! : "(작성한 닉네임)"
    }
}
