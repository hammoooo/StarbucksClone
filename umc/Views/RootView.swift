import SwiftUI

//struct RootView: View {
//    @State private var router = NavigationRouter()
//        // @State private var viewModel = HomeViewModel()
//
//    var body: some View {
//        NavigationStack(path: $router.path) {
////            Group {
////                if let user = KeychainService.shared.load() {
////                    TabView()
////                        .environment(router)
////                        .environment(viewModel)
////                } else {
////                    LoginView()
////                        .environment(router)
////                }
////            }
//            LoginView(id: .constant(""), pwd: .constant("")).environment(router)
//                .navigationDestination(for: Route.self) { route in
//                    switch route {
//                    case .login:
//                        LoginView(id: .constant(""), pwd: .constant(""))
//                            .environment(router)
//                    case .signup:
//                        SignupView()
//                            .environment(router)
//                    case .baseTab:
//                        TabView()
//                            .environment(router)
////                         .environment(viewModel)
////                    case .coffeeDetail:
////                         CoffeeDetailView()
////                            .environment(router)
////                           .environment(viewModel)
////                    case .recepit:
////                        ReceiptView()
////                            .environment(router)
////                    case .findStore:
////                        FindStoreView()
////                            .environment(router)
//                    }
//                }
//        }
//    }
//}
//




struct RootView: View {
    @State private var router = NavigationRouter()

    var body: some View {
        NavigationStack(path: $router.path) {
            LoginView(id: .constant(""), pwd: .constant(""))
                .environment(router)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .login:
                        LoginView(id: .constant(""), pwd: .constant(""))
                            .environment(router)
                    case .signup:
                        SignupView()
                            .environment(router)
                    case .baseTab:
                        TabView()
                            .environment(router)
                    }
                }
        }
    }
}
