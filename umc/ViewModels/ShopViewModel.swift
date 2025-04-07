import SwiftUI

// MARK: - ViewModel
class ShopViewModel: ObservableObject {
    // Banner 이미지 리스트 (실제 프로젝트에서는 받아온 URL이나 로컬 이미지 이름 사용)
    let bannerImages = ["shop1", "shop2", "shop3"]
    
    // All Products 더미 데이터 (ShopModel 배열)
    let allProducts: [ShopModel] = [
        ShopModel(name: "텀블러", imageName: "allproduct1"),
        ShopModel(name: "커피 용품", imageName: "allproduct2"),
        ShopModel(name: "선물세트", imageName: "allproduct3"),
        ShopModel(name: "보온병", imageName: "allproduct4"),
        ShopModel(name: "머그/컵", imageName: "allproduct5"),
        ShopModel(name: "라이프스타일", imageName: "allproduct6"),
    ]
    
    // Best Items 더미 데이터
    let bestItems: [ShopModel] = [
        ShopModel(name: "그린 사이렌 슬리브 머그\n355ml", imageName: "best1"),
        ShopModel(name: "그린 사이렌 클래식 머그\n355ml", imageName: "best2"),
        ShopModel(name: "사이렌 머그 앤 우드 소서", imageName: "best3"),
        ShopModel(name: "리저브 골드 테일 머그\n355ml", imageName: "best4"),
        ShopModel(name: "리저브 골드 테일 머그\n355ml", imageName: "best5"),
        ShopModel(name: "리저브 골드 테일 머그\n355ml", imageName: "best6"),
        ShopModel(name: "리저브 골드 테일 머그\n355ml", imageName: "best7"),
        ShopModel(name: "리저브 골드 테일 머그\n355ml", imageName: "best8")
    ]
    
    // MARK: - Best Items Page Info
    @Published var currentBestPage: Int = 0
    
    var totalBestPages: Int {
        let itemsPerPage = 4
        return Int(ceil(Double(bestItems.count) / Double(itemsPerPage)))
    }
    
    func bestItemsForPage(_ pageIndex: Int) -> [ShopModel] {
        let start = pageIndex * 4
        let end = min(start + 4, bestItems.count)
        return Array(bestItems[start..<end])
    }
    // New Products 더미 데이터 (4개라고 가정)
    let newProducts: [ShopModel] = [
        ShopModel(name: "그린 사이렌 도트 머그\n237ml", imageName: "new1"),
        ShopModel(name: "그린 사이렌 도트 머그\n355ml", imageName: "new2"),
        ShopModel(name: "홈 카페 미니 머그 세트", imageName: "new3"),
        ShopModel(name: "홈 카페 글라스 세트", imageName: "new4")
    ]
    
 
}
