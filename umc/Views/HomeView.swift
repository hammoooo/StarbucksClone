import SwiftUI

struct HomeView: View {
    // ViewModel
    @StateObject private var viewModel = HomeViewModel()
    
    // 닉네임(옵셔널)
    @AppStorage("userName") private var userName: String?
    
    
    @State private var showBanner: Bool = false
    @State private var showAdPopup = true
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    
                    
                    // MARK: 광고 팝업
                    if showAdPopup {
                        BannerView(showAdPopup: $showAdPopup)
                                      .transition(.scale.combined(with: .opacity))
                                      .zIndex(1)
                              }
                    
                    
                    
                    // MARK: 상단 배너 (ZStack 예시)
                    ZStack(alignment: .topLeading) {
                        // 뒤 배경 (노란색 + 토끼 이미지) - PDF로 가정
                        Image("top_img") // PDF 에셋
                            .resizable()
                            .scaledToFill()
                            .frame(height: 180)
                            .clipped()
                        
                        // 배너 위의 텍스트들
                        VStack(alignment: .leading, spacing: 6) {
                            Text("골든 미모사 그린 티\n행복한 새해의 축배를 들어요!")
                                .font(.headline)
                            
                            // until next Reward
                            Text("11★ until next Reward")
                                .font(.subheadline)
                            
                            // 하단 게이지 바 대신 간단 텍스트만 표시
                            Text("1 / 12 ★")
                                .font(.footnote)
                        }
                        .foregroundColor(.white)
                        .padding(.top, 40)
                        .padding(.leading, 16)
                    }
                    
                    // MARK: 아이스 챌린지 배너 (PDF)
                    Image("bear")
                        .resizable()
                        .scaledToFit()
                    
                    // MARK: (설정 닉네임)님을 위한 추천 메뉴
                    //                VStack(alignment: .leading, spacing: 8) {
                    //                    Text("\(userName ?? "설정 닉네임")님을 위한 추천 메뉴")
                    //                        .font(.headline)
                    //                        .padding(.leading, 16)
                    //                    
                    //                    // 스크롤뷰 예시 (HScroll)
                    //                    ScrollView(.horizontal, showsIndicators: false) {
                    //                        HStack(spacing: 16) {
                    //                            ForEach(viewModel.coffeeMenus) { coffee in
                    //                                CircleImageCard(title: coffee.name,
                    //                                                imageName: coffee.imageName)
                    //                            }
                    //                        }
                    //                        .padding(.horizontal, 16)
                    //                    }
                    //                }
                    
                    
                    
                    // MARK: (설정 닉네임)님을 위한 추천 메뉴
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(userName ?? "설정 닉네임")님을 위한 추천 메뉴")
                            .font(.headline)
                            .padding(.leading, 16)
                        
                        // 스크롤뷰 예시 (HScroll)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(viewModel.coffeeMenus) { coffee in
                                    // NavigationLink로 상세화면 이동
                                    NavigationLink(destination: CoffeeDetailView(coffee: coffee)) {
                                        CircleImageCard(title: coffee.name,
                                                        imageName: coffee.imageName)
                                    }
                                    // 필요시 버튼 스타일 제거 (기본 파란색 강조를 없앰)
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    
                    // MARK: Blooming Choux-Pring / 정규 서비스 론칭 배너들
                    // 그냥 단순 이미지(PDF)로 가정
                    VStack(spacing: 16) {
                        Image("eventBanner")
                            .resizable()
                            .scaledToFit()
                        Image("serviceSuscibe")
                            .resizable()
                            .scaledToFit()
                    }
                    
                    // MARK: What's New
                    VStack(alignment: .leading, spacing: 8) {
                        Text("What’s New")
                            .font(.headline)
                            .padding(.leading, 16)
                        
                        // 광고 카드 스크롤
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(viewModel.newAds) { ad in
                                    WhatsNewCard(item: ad)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    
                    // MARK: 나만의 취향을 표현할 수 있는 머그세트 / 온라인 스토어 별 적립 / 딜리버스 ...
                    VStack(spacing: 16) {
                        Image("mugbanner")
                            .resizable()
                            .scaledToFit()
                        ZStack {
                            // 배경 (필요하다면 색상/디자인 변경)
                            Color.white
                                .ignoresSafeArea()
                            
                            VStack(spacing: 8) {
                                // 상단 TIP 문구
                                Text("TIP")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                
                                // 온라인 스토어 (굵게)
                                Text("온라인 스토어")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                
                                // 별★ 적립 혜택
                                Text("별★ 적립 혜택")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                
                                // 부가설명
                                Text("온라인 스토어 구매 시\n별★을 적립해 드립니다.")
                                    .multilineTextAlignment(.center)
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            // 단순 애니메이션 예시: 뷰가 서서히 나타나도록
                            .opacity(showBanner ? 1.0 : 0.0)
                            .animation(.easeInOut(duration: 1.0), value: showBanner)
                        }
                        .onAppear {
                            // 뷰가 등장할 때 배너 표시
                            showBanner = true
                        }
                        Image("deliverybanner")
                            .resizable()
                            .scaledToFit()
                    }
                    
                    // MARK: 하루가 달콤해지는 디저트
                    VStack(alignment: .leading, spacing: 8) {
                        Text("하루가 달콤해지는 디저트")
                            .font(.headline)
                            .padding(.leading, 16)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(viewModel.desserts) { dessert in
                                    CircleImageCard(title: dessert.name,
                                                    imageName: dessert.imageName)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    
                    // MARK: 그 외 나머지 밑에 이미지
                    VStack(spacing: 16) {
                        Image("coldbrew")
                            .resizable()
                            .scaledToFit()
                        Image("barista")
                            .resizable()
                            .scaledToFit()
                        Image("bottomAd")
                            .resizable()
                            .scaledToFit()
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
            }
        }
    }
}
// MARK: - What's New 카드 (재사용 가능)
struct WhatsNewCard: View {
    let item: WhatsNewAdItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 180, height: 120)
                .clipped()
            Text(item.title)
                .font(.subheadline).bold()
            Text(item.description)
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .frame(width: 180)
    }
}



struct CircleImageCard: View {
    let title: String
    let imageName: String
    
    var body: some View {
        VStack(spacing: 8) {
            // 동그란 이미지
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
            
            // 아이템 이름
            Text(title)
                .font(.footnote)
                .multilineTextAlignment(.center)
        }
        .frame(width: 100) // 필요한 경우 프레임 조절
    }
}




#Preview {
    HomeView()
}
