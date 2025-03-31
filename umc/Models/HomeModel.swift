import SwiftUI


//struct CoffeeMenuItem: Identifiable {
//    let id = UUID()
//    let name: String
//    let imageName: String
//    let description: String
//    let price: Int          
//}

struct CoffeeMenuItem: Identifiable {
    let id = UUID()
    let name: String
    let englishName: String
    let description: String
    let price: Int
    let imageName: String
    // HOT/ICED 관련 정보
    let availableTemperatures: [CoffeeTemperatureOption]
}

enum CoffeeTemperatureOption: String, CaseIterable {
    case hot = "HOT"
    case iced = "ICED"
}

/// 커피 상세 모델
/// - `availableTemperatures`에 [hot, iced]가 둘 다 있으면
///   상세화면에서 두 가지 선택 버튼 모두 표시
//struct CoffeeDetailModel: Identifiable {
//    let id = UUID()
//    let name: String         // 예: "카페 아메리카노"
//    let englishName: String  // 예: "Caffe Americano"
//    let description: String  // 예: "진한 에스프레소와 뜨거운 물을..."
//    let price: Int           // 예: 4700
//    let imageName: String    // 정사각형 커피 이미지 (피그마 다운)
//    let availableTemperatures: [CoffeeTemperatureOption]
//}

// 광고 모델 (What's New)
struct WhatsNewAdItem: Identifiable {
    let id = UUID()            // Identifier 적용
    let title: String
    let description: String
    let imageName: String      // PDF 에셋 이름
}

// 디저트 모델
struct DessertItem: Identifiable {
    let id = UUID()            // Identifier 적용
    let name: String
    let imageName: String      // PDF 에셋 이름
}
