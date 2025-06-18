
import SwiftUI



struct SignupView: View {
    @Environment(NavigationRouter.self) private var router
    
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
            
            
            Button (action: {
                if !viewModel.signupModel.nickname.isEmpty &&
                   !viewModel.signupModel.email.isEmpty &&
                   !viewModel.signupModel.password.isEmpty {
                    viewModel.saveUserData()
                    dismiss()
                }
            }, label: {
                Text("생성하기")
                    .font(.PretendardMedium(18))
                    .foregroundColor(.white01)
                    .frame(maxWidth: 397, maxHeight: 46)
                    .background(RoundedRectangle(cornerRadius: 20) .fill(.green01))
            }).padding(.top, 300)
            
         
        }
        .padding(.horizontal, 15)
        .navigationTitle("회원가입")
        .navigationBarBackButtonHidden(false)
    }
}


#Preview {
    SignupView().environment(NavigationRouter())
}
