import SwiftUI

@MainActor
final class OrderViewModel: ObservableObject {
    @Published var selectedTopSegment: TopSegment = .all
    @Published var selectedBottomSegment: BottomSegment = .drink
    @Published var isStoreSheetPresented = false

    let drinkItems: [MenuItem] = [
        MenuItem(name: "추천", description: "Recommend", imageName: "espresso_conpanna"),
        MenuItem(name: "아이스 카페 아메리카노", description: "Reserve Espresso", imageName: "cafe_americano"),
        MenuItem(name: "카페 아메리카노", description: "Reserve Drip", imageName: "cafe_americano"),
        MenuItem(name: "카푸치노", description: "Dcaf Coffee", imageName: "drink4"),
        MenuItem(name: "아이스 카푸치노", description: "Espresso", imageName: "drink5"),
        MenuItem(name: "카라멜 마키아또", description: "Blonde Coffee", imageName: "caramel_macchiato"),
        MenuItem(name: "아이스 카라멜 마키아또", description: "Cold Brew", imageName: "ice_caramel_macchiato"),
        MenuItem(name: "아포가토/기타", description: "Others", imageName: "drink8"),
        MenuItem(name: "럼 샷 코르타도", description: "Brewed Coffee", imageName: "drink9"),
        MenuItem(name: "라벤더 카페 브레베", description: "Teavana", imageName: "drink10"),
        MenuItem(name: "병음료", description: "RTD", imageName: "drink11")
    ]
}
