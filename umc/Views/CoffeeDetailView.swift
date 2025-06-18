

import SwiftUI

/// 커피 상세 뷰 (재사용 가능)
/// - `coffee` 파라미터로 어떤 커피인지 정보를 받아와 화면에 표시
struct CoffeeDetailView: View {
    
    @Environment(\.dismiss) private var dismiss  // 뒤로가기
    let coffee: CoffeeMenuItem
    
    // 현재 선택된 온도(HOT/ICED) (애니메이션용)
    @State private var selectedTemp: CoffeeTemperatureOption? = nil
    
    // 초기 설정
    // - availableTemperatures에 두 옵션이 다 있으면 HOT로 시작한다든지,
    //   1개만 있으면 해당 옵션으로 시작할 수도 있음
    init(coffee: CoffeeMenuItem) {
        self.coffee = coffee
        
        // _selectedTemp에 초기값 세팅
        // SwiftUI의 State는 init에서 직접 세팅 불가하므로, 조금 뒤에 onAppear에서 설정
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: - 상단 이미지
            Image(coffee.imageName)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 300) // 원하는 만큼 조절
                .background(Color("DarkGreen")) // 피그마와 유사한 배경색 (옵션)
            
            // MARK: - 커피 정보 섹션
            VStack(alignment: .leading, spacing: 8) {
                // 한글 커피이름 + NEW
                HStack(spacing: 6) {
                    Text(coffee.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("New")
                        .foregroundColor(.green)
                        .font(.footnote)
                        .padding(.top, 4)
                }
                
                // 영어 이름
                Text(coffee.englishName)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                // 설명
                Text(coffee.description)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
                
                // 가격
                Text("\(coffee.price)원")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.top, 4)
            }
            .padding()
            
            // MARK: - HOT/ICED 선택 (애니메이션 포함)
            if coffee.availableTemperatures.count >= 1 {
                // 만약 [hot, iced] 2가지 옵션이 모두 있다면 2버튼
                // 1개만 있으면 1버튼만 표시 (예: HOT만 제공)
                temperatureSelectionView
                    .padding(.vertical, 16)
                    .transition(.opacity.animation(.easeInOut)) // withAnimation 시 사용
            }
            
            Spacer()
            
            // MARK: - 하단 주문하기 버튼
            OrderButtonView {
                print("주문하기") // 단순 액션
            }
        }
        // 상단 네비게이션
        .navigationBarBackButtonHidden(true) // 기본 BackButton 숨기기
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button {
//                    dismiss() // 이전 화면 POP
//                } label: {
//                    Image(systemName: "chevron.left")
//                        .foregroundColor(.black)
//                }
//            }
//            ToolbarItem(placement: .navigationBarTrailing) {
//                // 아무 기능 없는 버튼 (추후 사용)
//                Button {
//                    // 나중에 활용할 액션
//                } label: {
//                    Image(systemName: "square.and.arrow.up") // 공유 아이콘
//                }
//            }
//        }
//        .onAppear {
//            // 화면 뜰 때 초기 선택옵션 설정
//            // - 여러 옵션이 있으면 HOT 우선
//            // - 혹은 첫 번째 availableTemperatures를 선택
//            withAnimation {
//                if coffee.availableTemperatures.contains(.hot) {
//                    selectedTemp = .hot
//                } else {
//                    selectedTemp = coffee.availableTemperatures.first
//                }
//            }
//        }
    }
}




// MARK: - HOT/ICED 세그먼트 (커스텀)
extension CoffeeDetailView {
    private var temperatureSelectionView: some View {
        // 커피가 가진 옵션이 2개라면 HOT/ICED 모두 표시
        // 1개만 있다면 그 하나만 표시
        HStack(spacing: 0) {
            // HOT 버튼 (있을 때만)
            if coffee.availableTemperatures.contains(.hot) {
                Button {
                    withAnimation {
                        selectedTemp = .hot
                    }
                } label: {
                    Text("HOT")
                        .fontWeight(.semibold)
                        .foregroundColor(
                            selectedTemp == .hot ? .red : .gray
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            selectedTemp == .hot
                            ? Color.white
                            : Color.gray.opacity(0.2)
                        )
                }
            }
            
            // ICED 버튼 (있을 때만)
            if coffee.availableTemperatures.contains(.iced) {
                Button {
                    withAnimation {
                        selectedTemp = .iced
                    }
                } label: {
                    Text("ICED")
                        .fontWeight(.semibold)
                        .foregroundColor(
                            selectedTemp == .iced ? .red : .gray
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            selectedTemp == .iced
                            ? Color.white
                            : Color.gray.opacity(0.2)
                        )
                }
            }
        }
        .clipShape(Capsule()) // 둥근 모양
        .padding(.horizontal, 20)
    }
}

struct OrderButtonView: View {
    let action: () -> Void
    
    var body: some View {
        VStack {
            Button(action: action) {
                Text("주문하기")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(8)
                    .padding(.horizontal, 16)
            }
        }
        .padding(.bottom, 16) // 바닥쪽 여백
    }
}




//#Preview {
//    CoffeeDetailView()
//}
