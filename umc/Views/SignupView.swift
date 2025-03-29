//import SwiftUI
//
//struct SignupView: View {
//    @StateObject private var viewModel = SignupViewModel()
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            TextField("닉네임", text: $viewModel.signupModel.nickname)
//                .textFieldStyle(DefaultTextFieldStyle())
//                .padding()
//            
//            Divider().padding(.bottom, 10)
//            
//            TextField("이메일", text: $viewModel.signupModel.email)
//                .textFieldStyle(DefaultTextFieldStyle())
//                .padding()
//              //  .keyboardType(.emailAddress)
//           
//            Divider().padding(.bottom, 10)
//           
//            SecureField("비밀번호", text: $viewModel.signupModel.password)
//                .textFieldStyle(DefaultTextFieldStyle())
//                .padding()
//          
//            Divider().padding(.bottom, 10)
//          
//            Button(action: {
//                viewModel.saveUserData()
//            }) {
//                Text("생성하기")
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.green)
//                    .cornerRadius(10)
//            }
//            .padding(.top, 300)
//        }
//        .padding(.horizontal, 15)
//    }
//}
//
//#Preview {
//    SignupView()
//}



import SwiftUI



struct SignupView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = SignupViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            TextField("닉네임", text: $viewModel.signupModel.nickname)
                .textFieldStyle(DefaultTextFieldStyle())
                .padding()
            
            Divider().padding(.bottom, 10)
            
            TextField("이메일", text: $viewModel.signupModel.email)
                .textFieldStyle(DefaultTextFieldStyle())
                .padding()
               // .keyboardType(.emailAddress)
            
            Divider().padding(.bottom, 10)
            
            SecureField("비밀번호", text: $viewModel.signupModel.password)
                .textFieldStyle(DefaultTextFieldStyle())
                .padding()
            
            Divider().padding(.bottom, 10)
            
            Button(action: {
                if !viewModel.signupModel.nickname.isEmpty &&
                   !viewModel.signupModel.email.isEmpty &&
                   !viewModel.signupModel.password.isEmpty {
                    viewModel.saveUserData()
                    dismiss()
                }
            }) {
                Text("생성하기")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding(.top, 300)
        }
        .padding(.horizontal, 15)
        .navigationTitle("회원가입")
        .navigationBarBackButtonHidden(false)
    }
}


#Preview {
    SignupView()
}
