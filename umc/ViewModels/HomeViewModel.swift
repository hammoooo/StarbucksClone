import SwiftUI

class HomeViewModel: ObservableObject {
    
//    @Published var coffeeMenus: [CoffeeMenuItem] = [
//            CoffeeMenuItem(
//                name: "에스프레소 콘파나",
//                imageName: "espresso_conpanna",
//                description: "에스프레소에 풍성한 휘핑크림이 올라간 진한 커피",
//                price: 5000
//            ),
//            CoffeeMenuItem(
//                name: "에스프레소 마키아또",
//                imageName: "espresso_macchiato",
//                description: "에스프레소에 우유 거품이 살짝 올려진 클래식한 커피",
//                price: 5000
//            ),
//            CoffeeMenuItem(
//                name: "카페 아메리카노",
//                imageName: "cafe_americano",
//                description: "에스프레소에 물을 더해 깔끔하게 즐기는 커피",
//                price: 4000
//            ),
//            CoffeeMenuItem(
//                name: "아이스 아메리카노",
//                imageName: "ice_americano",
//                description: "시원하게 즐기는 아메리카노",
//                price: 4500
//            ),
//            CoffeeMenuItem(
//                name: "카라멜 마키아또",
//                imageName: "caramel_macchiato",
//                description: "달콤한 카라멜 소스와 부드러운 우유 거품이 조화로운 커피",
//                price: 5500
//            ),
//            CoffeeMenuItem(
//                name: "아이스 카라멜 마키아또",
//                imageName: "ice_caramel_macchiato",
//                description: "차갑고 달콤하게 즐기는 아이스 카라멜 마키아또",
//                price: 6000
//            )
//        ]
    
    
    @Published var coffeeMenus: [CoffeeMenuItem] = [
        CoffeeMenuItem(
            name: "에스프레소 콘파나",
            englishName: "Espresso Con Panna",
            description: "에스프레소에 풍성한 휘핑크림이 올라간 진한 커피",
            price: 5000,
            imageName: "espresso_conpanna",
            availableTemperatures: [.hot]
        ),
        CoffeeMenuItem(
            name: "에스프레소 마키아또",
            englishName: "Espresso Macchiato",
            description: "에스프레소에 우유 거품이 살짝 올려진 클래식한 커피",
            price: 5000,
            imageName: "espresso_macchiato",
            availableTemperatures: [.hot]
        ),
        CoffeeMenuItem(
            name: "카페 아메리카노",
            englishName: "Cafe Americano",
            description: "에스프레소에 물을 더해 깔끔하게 즐기는 커피",
            price: 4000,
            imageName: "cafe_americano",
            availableTemperatures: [.hot, .iced]
        ),
        CoffeeMenuItem(
            name: "아이스 아메리카노",
            englishName: "Iced Americano",
            description: "시원하게 즐기는 아메리카노",
            price: 4500,
            imageName: "ice_americano",
            availableTemperatures: [.iced]
        ),
        CoffeeMenuItem(
            name: "카라멜 마키아또",
            englishName: "Caramel Macchiato",
            description: "달콤한 카라멜 소스와 부드러운 우유 거품이 조화로운 커피",
            price: 5500,
            imageName: "caramel_macchiato",
            availableTemperatures: [.hot, .iced]
        ),
        CoffeeMenuItem(
            name: "아이스 카라멜 마키아또",
            englishName: "Iced Caramel Macchiato",
            description: "차갑고 달콤하게 즐기는 아이스 카라멜 마키아또",
            price: 6000,
            imageName: "ice_caramel_macchiato",
            availableTemperatures: [.iced]
        )
    ]

    @Published var selectedCoffee: CoffeeMenuItem? = nil

    func didSelectCoffee(_ coffee: CoffeeMenuItem) {
        self.selectedCoffee = coffee
    }

    
    
//    // 사용자가 선택한 커피 (상세화면으로 이동할 때 사용)
//    @Published var selectedCoffee: CoffeeMenuItem? = nil
//    
//    // 커피 항목을 탭했을 때 선택 이벤트 처리
//    func didSelectCoffee(_ coffee: CoffeeMenuItem) {
//        self.selectedCoffee = coffee
//    }

    
    // 2) What's New 광고
    @Published var newAds: [WhatsNewAdItem] = [
        WhatsNewAdItem(
            title: "25년 3월 일회용컵 없는 날 캠페인",
            description: "매월 10일은 일회용컵 없는 날!\n개인컵 및 다회용 컵을 이용하세요.",
            imageName: "wn1"
        ),
        WhatsNewAdItem(
            title: "스타벅스 OOO점을 찾습니다",
            description: "스타벅스 커뮤니티 스토어 파트너를\n운영할 기관을 공모합니다.",
            imageName: "wn2"
        ),
        WhatsNewAdItem(
            title: "2월 8일, 리저브 스프링 신규 커피 출시",
            description: "산뜻하고 달콤한 풍미가 가득한 리저브를\n맛보세요.",
            imageName: "wn3"
        )
    ]
    
    // 3) 디저트
    @Published var desserts: [DessertItem] = [
        DessertItem(name: "너티 크루아상",   imageName: "nutty_croissant"),
        DessertItem(name: "매콤 소시지",     imageName: "spicy_sausage"),
        DessertItem(name: "미니 리프 파이", imageName: "mini_leaf"),
        DessertItem(name: "뺑 오 쇼콜라",    imageName: "pain_au_chocolat"),
        DessertItem(name: "소시지 & 올리브 파이", imageName: "sausage_olive_pie")
    ]
    
    // 추후 필요한 로직(네트워크, 데이터 처리 등)이 있다면 여기에 작성
}
