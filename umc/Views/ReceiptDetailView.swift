import SwiftUI
import SwiftData

struct ReceiptDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    let receiptImage: ReceiptImage
    
    var body: some View {
        VStack {
            // 닫기 버튼
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .padding()
                }
            }
            
            Spacer()
            
            // 실제 영수증 이미지
            if let uiImage = UIImage(data: receiptImage.data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .padding()
            } else {
                Text("이미지를 표시할 수 없습니다.")
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .background(Color.black.opacity(0.8))
        .ignoresSafeArea()
    }
}
