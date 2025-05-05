import SwiftData
import Foundation

@Model
class Receipt {
    var id: UUID
    var storeName: String
    var date: Date
    var totalPrice: Double
    
    // 1:1 관계로 영수증 이미지를 담을 수 있도록 (ReceiptImage와 연결)
    @Relationship(.hasOne, inverse: \.receipt)
    var receiptImage: ReceiptImage?
    
    init(
        id: UUID = UUID(),
        storeName: String = "",
        date: Date = Date(),
        totalPrice: Double = 0.0,
        receiptImage: ReceiptImage? = nil
    ) {
        self.id = id
        self.storeName = storeName
        self.date = date
        self.totalPrice = totalPrice
        self.receiptImage = receiptImage
    }
}
