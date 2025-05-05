import SwiftData
import Foundation

@Model
class ReceiptImage {
    // 고유 식별자
    var id: UUID
    // 실제 이미지 바이너리 (JPEG/PNG 등 Data)
    var data: Data
    // Receipt와 1:1 관계
    @Relationship(.belongsTo, inverse: \.receiptImage)
    var receipt: Receipt

    init(
        id: UUID = UUID(),
        data: Data,
        receipt: Receipt? = nil
    ) {
        self.id = id
        self.data = data
        self.receipt = receipt ?? Receipt() // 관계 연결
    }
}
