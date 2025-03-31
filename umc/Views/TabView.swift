import SwiftUI

struct TabView: View {
    
    enum Tab {
        case home, pay, order, shop, other
    }

    // 현재 선택된 탭 상태
    @State private var selectedTab: Tab = .home

    var body: some View {
        VStack(spacing: 0) {
            // 메인 콘텐츠 영역
            ZStack {
                switch selectedTab {
                case .home:
                    HomeView()
                case .pay:
                    PayView()
                case .order:
                    OrderView()
                case .shop:
                    ShopView()
                case .other:
                    OtherView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // 커스텀 탭바
            Divider()
            HStack {
                // 각 탭 아이템
                TabBarItem(
                    tab: .home,
                    selectedTab: $selectedTab,
                    icon: "house.fill",
                    label: "Home"
                )
                TabBarItem(
                    tab: .pay,
                    selectedTab: $selectedTab,
                    icon: "creditcard.fill",
                    label: "Pay"
                )
                TabBarItem(
                    tab: .order,
                    selectedTab: $selectedTab,
                    icon: "cup.and.saucer.fill",
                    label: "Order"
                )
                TabBarItem(
                    tab: .shop,
                    selectedTab: $selectedTab,
                    icon: "bag.fill",
                    label: "Shop"
                )
                TabBarItem(
                    tab: .other,
                    selectedTab: $selectedTab,
                    icon: "ellipsis.circle.fill",
                    label: "Other"
                )
            }
            .padding(.horizontal, 8)
            .padding(.top, 10)
            .padding(.bottom, 16)
            .background(Color.white) // 배경 색상
        }
        .edgesIgnoringSafeArea(.bottom) // 탭바 영역도 안전영역에서 제외
    }
}

// 개별 탭 아이템 버튼
struct TabBarItem: View {
    let tab: TabView.Tab
    @Binding var selectedTab: TabView.Tab
    let icon: String
    let label: String

    var body: some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(label)
                    .font(.caption)
            }
            // 선택된 탭은 .green, 아니면 .gray
            .foregroundColor(selectedTab == tab ? .green : .gray)
        }
        .frame(maxWidth: .infinity)
    }
}

// 예시 뷰들
struct Home2View: View {
    var body: some View {
        Text("Home Screen")
            .font(.largeTitle)
    }
}

struct PayView: View {
    var body: some View {
        Text("Pay Screen")
            .font(.largeTitle)
    }
}

struct OrderView: View {
    var body: some View {
        Text("Order Screen")
            .font(.largeTitle)
    }
}

struct ShopView: View {
    var body: some View {
        Text("Shop Screen")
            .font(.largeTitle)
    }
}

struct Other2View: View {
    var body: some View {
        Text("Other Screen")
            .font(.largeTitle)
    }
}


#Preview {
    TabView()
}
