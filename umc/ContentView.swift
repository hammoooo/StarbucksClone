

import SwiftUI

struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack(spacing: 90) {
            Spacer()
            VStack(alignment: .leading, spacing: 20){
                // Starbucks Logo
                Image("starbucsLogo")
                    .frame(width: 100, height: 100)
                
                
                Text("안녕하세요.\n스타벅스입니다.")
                    .padding(.horizontal, 5)
                    .padding(.bottom, 20)
                    .fixedSize(horizontal: true, vertical: true)
                
                Text("회원 서비스 이용을 위해 로그인 해주세요")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                
                
            }  .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading,10)
            
            
            // Text Fields
            VStack(alignment: .leading, spacing: 10) {
                
                TextField("아이디", text: $username)
                    .textFieldStyle(DefaultTextFieldStyle())
                
                Divider().padding(.bottom, 20)
                
                SecureField("비밀번호", text: $password)
                    .textFieldStyle(DefaultTextFieldStyle())
                
                Divider()
            }
            .padding(.horizontal, 30)
            
            
            // Buttons
            VStack(spacing: 20) {
                
                //                NavigationLink(destination: SignUpView()) {
                //                    Text("이메일로 회원가입하기")
                //                        .foregroundColor(.gray)
                //                        .underline()
                //                }
                
                Text("이메일로 회원가입하기") // Clickable text
                    .font(.system(size: 12))
                    .foregroundColor(.gray) // Set text color to gray
                    .underline() // Add underline
                    .onTapGesture {
                        print("Text clicked!") // Action when clicked
                    }
                
                
                Image("kakaologin")
                Image("applelogin")
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
    }
}


#Preview {
    ContentView()
}
