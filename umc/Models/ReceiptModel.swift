import SwiftUI
import SwiftData

@Model
final class Receipt {
    let id: UUID
    var storeName: String
    var purchaseDate: Date
    var totalPrice: Double
    
    // 1:1 관계로 연결 (이미지)
    var receiptImage: ReceiptImage?
    
    init(storeName: String,
         purchaseDate: Date,
         totalPrice: Double,
         receiptImage: ReceiptImage? = nil) {
        self.id = UUID()
        self.storeName = storeName
        self.purchaseDate = purchaseDate
        self.totalPrice = totalPrice
        self.receiptImage = receiptImage
    }
}

@Model
final class ReceiptImage {
    var imageData: Data
    
    init(imageData: Data) {
        self.imageData = imageData
    }
}

