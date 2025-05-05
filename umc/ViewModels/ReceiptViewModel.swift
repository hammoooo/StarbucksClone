import SwiftUI
import SwiftData

@MainActor
class ReceiptViewModel: ObservableObject {
    
    @Environment(\.modelContext) var context
    
    // 새 영수증 생성 함수
    func addReceipt(storeName: String, date: Date, totalPrice: Double, imageData: Data?) {
        // 새로운 Receipt 생성
        let newReceipt = Receipt(
            storeName: storeName,
            date: date,
            totalPrice: totalPrice
        )
        
        // 이미지 Data가 있으면 ReceiptImage도 생성해서 연결
        if let imageData = imageData {
            let newReceiptImage = ReceiptImage(data: imageData, receipt: newReceipt)
            newReceipt.receiptImage = newReceiptImage
        }
        
        // SwiftData 컨텍스트에 삽입 후 저장
        context.insert(newReceipt)
        
        do {
            try context.save()
        } catch {
            print("Error saving new Receipt: \(error)")
        }
    }
    
    // 영수증 삭제 함수
    func deleteReceipt(_ receipt: Receipt) {
        context.delete(receipt)
        do {
            try context.save()
        } catch {
            print("Error deleting Receipt: \(error)")
        }
    }
}
