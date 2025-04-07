import SwiftUI


// MARK: - View
struct ShopView: View {
    @StateObject private var viewModel = ShopViewModel()
       
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 30) {
                
                // MARK: - 상단 타이틀 (예시)
                Text("Starbucks Online Store")
                    .font(.title)
                    .bold()
                    .padding(.horizontal)
                
                // MARK: - 상단 배너 (가로 스크롤)
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        ForEach(viewModel.bannerImages, id: \.self) { banner in
                            Image(banner)
                                .resizable()
                                .scaledToFit()
//                                .frame(width: 300, height: 150)
                                .clipped()
                                .cornerRadius(8)
                                .shadow(radius: 3)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // MARK: - All Products (가로 스크롤)
                VStack(alignment: .leading, spacing: 10) {
                    Text("All Products")
                        .font(.headline)
                        .padding(.leading)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 20) {
                            ForEach(viewModel.allProducts) { shopModel in
                                VStack(spacing: 6) {
                                    Image(shopModel.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                    Text(shopModel.name)
                                        .font(.subheadline)
                                }
                                .frame(width: 100)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                
                // MARK: - Best Items (가로 스크롤 + 도트 인디케이터)
                VStack {
                            Text("Best Items")
                                .font(.headline)
                                .padding(.top, 30)
                                .padding(.bottom, 8)
                            
                            // **TabView**로 페이지별 뷰 구성
                    SwiftUI.TabView(selection: $viewModel.currentBestPage) {
                                ForEach(0..<viewModel.totalBestPages, id: \.self) { pageIndex in
                                    // 2×2 Grid = 한 페이지 4개
                                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())],
                                              alignment: .center,
                                              spacing: 20)
                                    {
                                        ForEach(viewModel.bestItemsForPage(pageIndex)) { item in
                                            VStack(spacing: 4) {
                                                Image(item.imageName)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 100, height: 100)
                                                Text(item.name)
                                                    .font(.subheadline)
                                                    .multilineTextAlignment(.center)
                                            }
                                        }
                                    }
                                    .tag(pageIndex) // Tag를 통해 현재 페이지 인덱스와 바인딩
                                }
                            }
                            .frame(height: 350)
                            // macOS나 iOS 13 이하에서 PageTabViewStyle가 안 되면 DefaultTabViewStyle()로도
                            // iOS14+라면 기본적으로 수평 스와이프가 가능.
                            .tabViewStyle(DefaultTabViewStyle())
                            .gesture(DragGesture())
                            
                            // **도트(●○)** 표시
                            HStack {
                                ForEach(0..<viewModel.totalBestPages, id: \.self) { index in
                                    Circle()
                                        .fill(index == viewModel.currentBestPage ? Color.black : Color.gray)
                                        .frame(width: 8, height: 8)
                                        .padding(.horizontal, 3)
                                        .padding(.bottom, 30)
                                }
                            }
                            .padding(.top, 4)
                        }
                    }
                
                // MARK: - New Products (LazyVGrid)
                VStack(alignment: .leading, spacing: 10) {
                    Text("New Products")
                        .font(.headline)
                        .padding(.leading)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())],
                              spacing: 20) {
                        ForEach(viewModel.newProducts) { shopModel in
                            VStack(spacing: 6) {
                                Image(shopModel.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                Text(shopModel.name)
                                    .font(.subheadline)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
    }


// MARK: - Preview
struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        ShopView()
    }
}

