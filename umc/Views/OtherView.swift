import SwiftUI


struct OtherView: View {
    @AppStorage("nickname") private var storedNickname: String = ""
    @StateObject private var viewModel = OtherViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // 환영 메시지
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(viewModel.nickname) 님")
                            .font(.headline)
                            .foregroundColor(.green)
                        Text("환영합니다! 🙌")
                            .font(.title3)
                    }
                    .padding(.horizontal)

                    // 상단 버튼 3개
                    HStack(spacing: 10) {
                        TopFeatureButton(imageName: "star", title: "별 히스토리")
                        TopFeatureButton(imageName: "doc.text", title: "전자영수증")
                        TopFeatureButton(imageName: "cup.and.saucer", title: "나만의 메뉴")
                    }
                    .padding(.horizontal)

                    // Pay 섹션
                    SectionHeader(title: "Pay")
                    VStack(spacing: 8) {
                        HStack {
                            IconTextButton(imageName: "creditcard", title: "스타벅스 카드 등록")
                            IconTextButton(imageName: "giftcard", title: "카드 교환권 등록")
                        }
                        HStack {
                            IconTextButton(imageName: "qrcode", title: "쿠폰 등록")
                            IconTextButton(imageName: "list.bullet.rectangle", title: "쿠폰 히스토리")
                        }
                    }.padding(.horizontal)

                    Divider().padding(.horizontal)

                    // 고객지원 섹션
                    SectionHeader(title: "고객지원")
                    VStack(spacing: 8) {
                        HStack {
                            IconTextButton(imageName: "bag", title: "스토어 케어")
                            IconTextButton(imageName: "waveform", title: "고객의 소리")
                        }
                        HStack {
                            IconTextButton(imageName: "location", title: "매장 정보")
                            IconTextButton(imageName: "arrow.2.squarepath", title: "반납기 정보")
                        }
                        IconTextButton(imageName: "doc.plaintext", title: "마이 스타벅스 리뷰")
                    }
                    .padding(.horizontal)
                }
                .padding(.top).background(Color.gray.opacity(0.05))
            }
            .navigationTitle("Other")
            //.navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: {
//                        print("로그아웃")
//                    }) {
//                        Image(systemName: "door.right.hand.open")
//                            .imageScale(.large)
//                    }
//                }
//            }
        }
    }
}

struct SectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.headline)
            .padding(.horizontal)
            .padding(.top, 8)
    }
}



// 상단 버튼 3개: 별 히스토리, 전자영수증, 나만의 메뉴
struct TopFeatureButton: View {
    let imageName: String
    let title: String

    var body: some View {
        Button(action: {
            print(title)
        }) {
            VStack(spacing: 8) {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 24)
                    .foregroundColor(.green)
                Text(title)
                    .font(.footnote)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .cornerRadius(12)
        }
    }
}

// Pay / 고객지원 버튼: 아이콘 + 텍스트
struct IconTextButton: View {
    let imageName: String
    let title: String

    var body: some View {
        Button(action: {
            print(title)
        }) {
            HStack(spacing: 10) {
                Image(systemName: imageName)
                    .frame(width: 24, height: 24)
                Text(title)
                Spacer()
            }
            .padding(.vertical, 6)
            .foregroundColor(.primary)
        }
    }
}


#Preview {
    OtherView()
}
