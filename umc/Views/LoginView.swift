//import SwiftUI
//
//struct LoginView: View {
//    @Binding var id: String
//    @Binding var pwd: String
//
//    @State private var showSignUp = false
//    @FocusState private var focusedField: Field?
//    
//    enum Field {
//        case userId, password
//    }
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            Spacer()
//            
//            VStack(alignment: .leading, spacing: 20){
//                Image("starbucks")
//                    .resizable()
//                    .frame(width: 100, height: 100)
//                
//                Text("안녕하세요.\n스타벅스입니다.")
//                    .padding(.horizontal, 5)
//                    .padding(.bottom, 20)
//                    .fixedSize(horizontal: true, vertical: true)
//                
//                Text("회원 서비스 이용을 위해 로그인 해주세요")
//                    .font(.system(size: 15))
//                    .foregroundColor(.gray)
//            }
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .padding(.leading, 10)
//            .padding(.bottom, 130)
//            
//            VStack(alignment: .leading, spacing: 10) {
//                Text("아이디")
//                    .font(.caption)
//                    .foregroundColor(.gray)
//                
//                TextField("", text: $id)
//                    .focused($focusedField, equals: .userId)
//                    .padding(.bottom, 4)
//                    .overlay(
//                        Rectangle()
//                            .frame(height: 1)
//                            .foregroundColor(focusedField == .userId ? .green : .gray),
//                        alignment: .bottom
//                    )
//            }
//
//            VStack(alignment: .leading, spacing: 8) {
//                Text("비밀번호")
//                    .font(.caption)
//                    .foregroundColor(.gray)
//                
//                SecureField("", text: $pwd)
//                    .focused($focusedField, equals: .password)
//                    .padding(.bottom, 4)
//                    .overlay(
//                        Rectangle()
//                            .frame(height: 1)
//                            .foregroundColor(focusedField == .password ? .green : .gray),
//                        alignment: .bottom
//                    )
//            }
//        }
//        .padding(.horizontal, 30)
//
//        VStack(spacing: 20) {
//            NavigationLink(destination: SignupView(), isActive: $showSignUp) {
//                EmptyView()
//            }
//
//            Button {
//                showSignUp = true
//            } label: {
//                Text("이메일로 회원가입하기")
//                    .font(.system(size: 12))
//                    .foregroundColor(.gray)
//                    .underline()
//            }
//            .padding(.vertical, 30)
//            .padding(.top, 30)
//            
//     
//            NavigationStack {
//                NavigationLink(destination: SignupView()){
//                    Button {
//                     
//                    } label: {
//                        Text("이메일로 회원가입하기")
//                            .font(.system(size: 12))
//                            .foregroundColor(.gray)
//                            .underline()
//                    }
//                    .padding(.vertical, 30)
//                    .padding(.top, 30)
//                }
//            }
//            
//
//         
//            
//     
//
//            Image("kakaologin")
//            Image("applelogin")
//        }
//        .padding(.horizontal, 30)
//
//        Spacer()
//    }
//}
//
//
//#Preview {
//    LoginView(id: .constant(""), pwd: .constant(""))
//}




import SwiftUI

/// LoginView – MVVM + Keychain + Kakao REST
/// 1. `AuthViewModel` 환경 객체를 사용해 상태/액션 전달
/// 2. 회원가입 화면은 NavigationLink(isActive:) 로 이동
/// 3. TextField·SecureField 는 iOS17 `SubmitScope` 이용해 키보드 Return 으로 로그인 가능하도록 구성
struct LoginView: View {
    // MARK: - Dependencies
    @EnvironmentObject private var vm: AuthViewModel
    @FocusState private var focus: Field?
    @State private var showSignUp = false // 네비게이션 상태

    private enum Field { case email, pwd }

    var body: some View {
        NavigationStack {
            ScrollView {       // 키보드가 올라올 때 대비해 스크롤 허용
                VStack(spacing: 40) {
                    header
                    formSection
                    errorSection
                    signUpButton
                }
                .padding(.horizontal, 30)
                .padding(.top, 24)
                .padding(.bottom, 40)
            }
            .navigationTitle("로그인")
            .navigationBarTitleDisplayMode(.inline)
            // 숨겨진 회원가입 네비게이션
            .background {
                NavigationLink(isActive: $showSignUp) {
                    SignupView()
                } label: { EmptyView() }
            }
        }
    }

    // MARK: - Header
    private var header: some View {
        VStack(alignment: .leading, spacing: 16) {
            Image("starbucks")
                .resizable()
                .frame(width: 100, height: 100)
                .accessibilityHidden(true)

            Text("안녕하세요.\n스타벅스입니다.")
                .font(.title2.bold())
                .fixedSize(horizontal: false, vertical: true)

            Text("회원 서비스 이용을 위해 로그인 해주세요")
                .font(.footnote)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Form Section
    private var formSection: some View {
        VStack(spacing: 28) {
            inputField(title: "아이디", text: $vm.email, focusCase: .email)
                .textContentType(.username)
                .keyboardType(.emailAddress)
                .submitLabel(.next)
                .onSubmit { focus = .pwd }

            inputSecureField(title: "비밀번호", text: $vm.password, focusCase: .pwd)
                .textContentType(.password)
                .submitLabel(.done)
                .onSubmit { loginAction() }

            Button(action: loginAction) {
                Text("로그인")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(vm.email.isEmpty || vm.password.isEmpty)

            // 소셜 로그인
            HStack(spacing: 24) {
                Image("kakaologin")
                    .onTapGesture { vm.loginWithKakao() }
                Image("applelogin")
                    // .onTapGesture { /* Apple 로그인 */ }
            }
        }
    }

    // MARK: - Error Section
    private var errorSection: some View {
        Group {
            if let err = vm.errorMessage {
                Text(err)
                    .foregroundStyle(.red)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    // MARK: - SignUp Button
    private var signUpButton: some View {
        Button {
            showSignUp = true
        } label: {
            Text("이메일로 회원가입하기")
                .font(.footnote)
                .foregroundColor(.gray)
                .underline()
        }
        .padding(.top, 12)
    }

    // MARK: - Helpers
    private func inputField(title: String, text: Binding<String>, focusCase: Field) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            TextField("", text: text)
                .focused($focus, equals: focusCase)
                .padding(.bottom, 4)
                .overlay(Rectangle().frame(height: 1).foregroundColor(focus == focusCase ? .green : .gray), alignment: .bottom)
        }
    }

    private func inputSecureField(title: String, text: Binding<String>, focusCase: Field) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            SecureField("", text: text)
                .focused($focus, equals: focusCase)
                .padding(.bottom, 4)
                .overlay(Rectangle().frame(height: 1).foregroundColor(focus == focusCase ? .green : .gray), alignment: .bottom)
        }
    }

    private func loginAction() {
        focus = nil   // 키보드 내리기
        vm.loginWithEmail()
    }
}

// MARK: - Preview
#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
        .previewDisplayName("LoginView")
}
