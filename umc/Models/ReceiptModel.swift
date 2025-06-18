import Foundation
import SwiftData

@Model                               
final class Receipt {
    @Attribute(.unique) var id: UUID = UUID()
    var storeName: String                // 매장명
    var amount: Int                      // 총 사용 금액 (원)
    var date: Date                       // 결제 일자
    var imageData: Data?                 // 영수증 원본 이미지 (JPEG)

    init(storeName: String, amount: Int, date: Date, imageData: Data?) {
        self.storeName = storeName
        self.amount = amount
        self.date = date
        self.imageData = imageData
    }
}
