import SwiftUI

struct LoginView: View {
    @Binding var id: String
    @Binding var pwd: String

    @Environment(NavigationRouter.self) private var router
    
    @State private var showSignUp = false
    @FocusState private var focusedField: Field?
    
    enum Field {
        case userId, password
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            VStack(alignment: .leading, spacing: 20){
                Image("starbucks")
                    .resizable()
                    .frame(width: 100, height: 100)
                
                Text("안녕하세요.\n스타벅스입니다.")
                    .padding(.horizontal, 5)
                    .padding(.bottom, 20)
                    .fixedSize(horizontal: true, vertical: true)
                
                Text("회원 서비스 이용을 위해 로그인 해주세요")
                    .font(.PretendardMedium(16))
                    .foregroundColor(.gray01)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 10)
            .padding(.bottom, 130)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("아이디")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                TextField("", text: $id)
                    .focused($focusedField, equals: .userId)
                    .padding(.bottom, 4)
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(focusedField == .userId ? .green : .gray),
                        alignment: .bottom
                    )
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("비밀번호")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                SecureField("", text: $pwd)
                    .focused($focusedField, equals: .password)
                    .padding(.bottom, 4)
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(focusedField == .password ? .green : .gray),
                        alignment: .bottom
                    )
            }
        }
        .padding(.horizontal, 30)
        
        
        Button (action: {
            
            print("로그인하기")

        }, label: {
            Text("로그인 하기")
                .font(.PretendardMedium(16))
                .foregroundColor(.white01)
                .frame(maxWidth: 397, maxHeight: 46)
                .background(RoundedRectangle(cornerRadius: 20) .fill(.green01))
        }).padding(.top, 30)

        VStack(spacing: 20) {
            
            Button {
                showSignUp = true
                router.push(.signup)
            } label: {
                Text("이메일로 회원가입하기")
                    .font(.PretendardMedium(12))
                    .foregroundColor(.gray02)
                    .underline()
            }
            .padding(.vertical, 25)
            .padding(.top, 30)
            
    

         
            
            Button (action: {
                kakaoLogin()
                print("kakaoLogin")

            }, label: {
                Image(.kakaologin)
                    //.resizable()
                    //.frame(width: 100, height: 100)
            })

           // Image("kakaologin")
            Image("applelogin")
        }
        .padding(.horizontal, 30)

        Spacer()
    }
}


#Preview {
    LoginView(id: .constant(""), pwd: .constant("")).environment(NavigationRouter())
}

