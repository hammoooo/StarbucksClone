//import Foundation
import SwiftUI
//class LoginViewModel: ObservableObject {
//    @State private var id: String = ""
//    @State private var pwd: String = ""
//}
struct LoginViewModel: View {
    @State private var id: String = ""
    @State private var pwd: String = ""
    
    
    var body: some View {
            NavigationStack {
                LoginView(id: $id, pwd: $pwd)
            }
        }
    
    
    
}
