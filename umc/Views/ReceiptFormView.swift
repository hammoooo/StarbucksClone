import SwiftUI
import SwiftData

struct ReceiptFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    // 사용자가 폼에 직접 입력
    @State private var storeName: String = ""
    @State private var date: Date = Date()
    @State private var totalPrice: String = ""
    
    // 영수증 이미지 (Data 형태)
    @State private var selectedImageData: Data? = nil
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("지점명")) {
                    TextField("예) 스타벅스 OO점", text: $storeName)
                }
                Section(header: Text("날짜")) {
                    DatePicker("영수증 날짜", selection: $date, displayedComponents: .date)
                }
                Section(header: Text("총 가격")) {
                    TextField("예) 6200", text: $totalPrice)
                        .keyboardType(.numberPad)
                }
                Section(header: Text("영수증 이미지")) {
                    // 간단히 이미지를 표시
                    if let data = selectedImageData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                        Button("이미지 제거") {
                            selectedImageData = nil
                        }
                    } else {
                        Text("이미지 없음")
                            .foregroundColor(.secondary)
                    }
                    
                    // 샘플 파일로부터 가져오는 예시 or PhotosPicker 등 사용
                    Button("샘플 이미지 불러오기") {
                        if let sampleURL = Bundle.main.url(forResource: "sample_receipt", withExtension: "jpg"),
                           let data = try? Data(contentsOf: sampleURL) {
                            selectedImageData = data
                        }
                    }
                }
            }
            .navigationTitle("영수증 등록")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("저장") {
                        saveReceipt()
                    }
                }
            }
        }
    }
    
    private func saveReceipt() {
        guard let price = Double(totalPrice) else {
            return // 숫자가 아닐 경우 처리
        }
        
        // SwiftData에 새 Receipt + ReceiptImage 저장
        let newReceipt = Receipt(
            storeName: storeName,
            date: date,
            totalPrice: price
        )
        
        if let imageData = selectedImageData {
            let newImage = ReceiptImage(data: imageData, receipt: newReceipt)
            newReceipt.receiptImage = newImage
        }
        
        context.insert(newReceipt)
        
        do {
            try context.save()
            dismiss()
        } catch {
            print("Error while saving new Receipt: \(error)")
        }
    }
}
