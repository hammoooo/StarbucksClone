import SwiftUI
import SwiftData

@MainActor
class ReceiptViewModel: ObservableObject {
    @Published var receipts: [Receipt] = []
    
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchReceipts()
    }
    
    // SwiftData에서 Receipt 전체 목록 불러오기
    func fetchReceipts() {
        do {
            // 가장 단순한 FetchDescriptor (조건 x)
            let fetchDescriptor = FetchDescriptor<Receipt>()
            receipts = try modelContext.fetch(fetchDescriptor)
        } catch {
            print("Error fetching receipts: \(error)")
        }
    }
    
    // 새 영수증 추가
    func addReceipt(storeName: String, date: Date, price: Double, imageData: Data?) {
        let newReceipt = Receipt(
            storeName: storeName,
            purchaseDate: date,
            totalPrice: price
        )
        // 이미지가 있다면 1:1 관계 생성
        if let data = imageData {
            let receiptImage = ReceiptImage(imageData: data)
            newReceipt.receiptImage = receiptImage
        }
        modelContext.insert(newReceipt)
        
        // SwiftData에 저장
        do {
            try modelContext.save()
            // in-memory 목록에도 반영
            receipts.append(newReceipt)
        } catch {
            print("Error saving new receipt: \(error)")
        }
    }
    
    // 영수증 삭제
    func deleteReceipt(_ receipt: Receipt) {
        modelContext.delete(receipt)
        do {
            try modelContext.save()
            receipts.removeAll { $0.id == receipt.id }
        } catch {
            print("Error deleting receipt: \(error)")
        }
    }
}
