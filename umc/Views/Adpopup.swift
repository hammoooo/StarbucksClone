import SwiftUI

struct BannerView: View {
    @Binding var showAdPopup: Bool
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            Image("ad") // Assets에 있는 이미지 이름
                .resizable()
                .scaledToFit()
                .ignoresSafeArea(edges:.top)

            VStack(spacing: 12) {
                Button(action: {
                    print("자세히 보기")
                    showAdPopup = false
                }) {
                    Text("자세히 보기")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(12)
                }
              
                Button(action: {
                    showAdPopup = false
                    dismiss()
                }) {
                    
                }
                HStack{
                    Spacer()
                        Text("X 닫기")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    
                    
                }
               
            }
            .padding(.top, 90)
            .background(Color.white)
        }
        .ignoresSafeArea()
    }
}


#Preview {
    //BannerView(showAdPopup: true)
}

