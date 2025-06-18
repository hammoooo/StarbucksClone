import SwiftUI

struct TabView: View {
    
    enum Tab {
        case home, pay, order, shop, other
    }

    @State private var selectedTab: Tab = .home

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                switch selectedTab {
                case .home:
                    NavigationView {
                        HomeView()
                            .navigationTitle("Home")
                    }
                case .pay:
                    NavigationView {
                        PayView()
                            .navigationTitle("Pay")
                    }
                case .order:
                    NavigationView {
                        OrderView()
                            .navigationTitle("Order")
                            .navigationBarTitleDisplayMode(.inline)
                    }
                case .shop:
                    NavigationView {
                        ShopView()
                            //.navigationTitle("Shop")
                    }
                case .other:
                    NavigationView {
                        OtherView()
                           // .navigationTitle("Other")
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            Divider()

            HStack {
                TabBarItem(tab: .home, selectedTab: $selectedTab, icon: "house.fill", label: "Home")
                TabBarItem(tab: .pay, selectedTab: $selectedTab, icon: "creditcard.fill", label: "Pay")
                TabBarItem(tab: .order, selectedTab: $selectedTab, icon: "cup.and.saucer.fill", label: "Order")
                TabBarItem(tab: .shop, selectedTab: $selectedTab, icon: "bag.fill", label: "Shop")
                TabBarItem(tab: .other, selectedTab: $selectedTab, icon: "ellipsis.circle.fill", label: "Other")
            }
            .padding(.horizontal, 8)
            .padding(.top, 10)
            .padding(.bottom, 16)
            .background(Color.white)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

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
            .foregroundColor(selectedTab == tab ? .green : .gray)
        }
        .frame(maxWidth: .infinity)
    }
}



struct PayView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Pay")
                .font(.title)
                .foregroundColor(.gray)
            Spacer()
        }
    }
}


#Preview {
    TabView()
}
