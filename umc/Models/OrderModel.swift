// OrderSegment.swift

import Foundation
enum TopSegment: String, CaseIterable {
    case all = "전체 메뉴"
    case myMenu = "나만의 메뉴"
    case cake = "홀케이크 예약"
}

enum BottomSegment: String, CaseIterable {
    case drink = "음료"
    case food = "푸드"
    case product = "상품"
}

struct MenuItem: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let imageName: String
}
