
import SwiftUI

struct SplashView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        
        ZStack {
            Image("splash")
                .resizable()
            //                .aspectRatio(contentMode: .infinity)
                .edgesIgnoringSafeArea(.all)
            
            
        }
        
    }
}


#Preview {
    SplashView()
}
