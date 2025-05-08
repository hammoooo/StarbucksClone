import SwiftUI

struct ShopView: View {
    @StateObject private var viewModel = ShopViewModel()
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 30) {
                
                // MARK: - 타이틀
                Text("Starbucks Online Store")
                    .font(.title)
                    .bold()
                    .padding(.horizontal)
                
                // MARK: - 상단 배너
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 16) {
                        ForEach(viewModel.bannerImages, id: \.self) { banner in
                            Image(banner)
                                .resizable()
                                .scaledToFit()
                                .clipped()
                                .cornerRadius(8)
                                .shadow(radius: 3)
                        }
                    }
                    .padding(.horizontal)
                }
                .scrollIndicators(.hidden, axes: .horizontal)
                
                // MARK: - All Products
                VStack(alignment: .leading, spacing: 10) {
                    Text("All Products")
                        .font(.headline)
                        .padding(.leading)
                    
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 20) {
                            ForEach(viewModel.allProducts) { product in
                                VStack(spacing: 6) {
                                    Image(product.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                    Text(product.name)
                                        .font(.subheadline)
                                }
                                .frame(width: 100)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .scrollIndicators(.hidden, axes: .horizontal)
                }
                
                // MARK: - Best Items (TabView + 도트 인디케이터)
                VStack {
                                Text("Best Items")
                                    .font(.headline)
                                    .padding(.top, 30)
                                    .padding(.bottom, 8)
                                
                    SwiftUI.TabView(selection: $viewModel.currentBestPage) {
                                    ForEach(0..<viewModel.totalBestPages, id: \.self) { pageIndex in
                                        ShopView_GridSection(
                                            title: "",
                                            items: viewModel.bestItemsForPage(pageIndex),
                                            columns: [GridItem(.flexible()), GridItem(.flexible())]
                                        )
                                        .tag(pageIndex)
                                    }
                                }
                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // 도트 숨김
                                .frame(height: 350)

                                // ✅ 수동 도트 인디케이터
                                HStack {
                                    ForEach(0..<viewModel.totalBestPages, id: \.self) { index in
                                        Circle()
                                            .fill(index == viewModel.currentBestPage ? .black : .gray.opacity(0.3))
                                            .frame(width: 8, height: 8)
                                    }
                                }
                                .padding(.top, 4)
                                .padding(.bottom, 30)
                            }
                // MARK: - New Products (재사용 뷰)
                ShopView_GridSection(
                    title: "New Products",
                    items: viewModel.newProducts,
                    columns: [GridItem(.flexible()), GridItem(.flexible())]
                )
            }
            .padding(.vertical)
        }
        .scrollIndicators(.hidden, axes: .vertical)
    }
}

#Preview {
    ShopView()
}
