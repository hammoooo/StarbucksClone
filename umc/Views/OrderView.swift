import SwiftUI

struct OrderView: View {
    @StateObject private var viewModel = OrderViewModel()
    @Namespace private var animationNamespace

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - 상단 세그먼트
            topSegmentView

            Divider().padding(.top, 8)

            // MARK: - 하단 세그먼트
            bottomSegmentView

            // MARK: - 메뉴 리스트
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.drinkItems) { item in
                        HStack(spacing: 12) {
                            Image(item.imageName)
                                .resizable()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 4) {
                                    Text(item.name)
                                        //.font(.PretendardBold30)
                                       // .font(.system(size: 16, weight: .semibold))
                                    
                                    Circle()
                                        .fill(Color.green)
                                        .frame(width: 6, height: 6)
                                }

                                Text(item.description)
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 8)
            }

            // MARK: - 하단 매장 선택 버튼
            Button {
                viewModel.isStoreSheetPresented = true
            } label: {
                HStack {
                    Text("주문할 매장을 선택해 주세요")
                        .font(.system(size: 15, weight: .medium))
                    Spacer()
                    Image(systemName: "chevron.up")
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.black)
            }
            .sheet(isPresented: $viewModel.isStoreSheetPresented) {
                VStack {
                    OrderSheetView()
                }
                //.presentationDetents([.medium])
            }
        }
    }

    // MARK: - 상단 세그먼트 뷰
    private var topSegmentView: some View {
        HStack(spacing: 32) {
            ForEach(TopSegment.allCases, id: \.self) { segment in
                Button {
                    withAnimation {
                        viewModel.selectedTopSegment = segment
                    }
                } label: {
                    VStack(spacing: 4) {
                        Text(segment.rawValue)
                            .font(.system(size: 15))
                            .foregroundColor(viewModel.selectedTopSegment == segment ? .green : .gray)

                        if viewModel.selectedTopSegment == segment {
                            Capsule()
                                .fill(Color.green)
                                .frame(height: 2)
                                .matchedGeometryEffect(id: "topSegment", in: animationNamespace)
                        } else {
                            Capsule()
                                .fill(Color.clear)
                                .frame(height: 2)
                        }
                    }
                }
            }
            Spacer() // 왼쪽 정렬 유지
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }

    // MARK: - 하단 세그먼트 뷰
    private var bottomSegmentView: some View {
        HStack(spacing: 0) {
            ForEach(BottomSegment.allCases, id: \.self) { segment in
                Button {
                    withAnimation {
                        viewModel.selectedBottomSegment = segment
                    }
                } label: {
                    ZStack(alignment: .topTrailing) {
                        Text(segment.rawValue)
                            .foregroundColor(viewModel.selectedBottomSegment == segment ? .green : .gray)
                            .fontWeight(viewModel.selectedBottomSegment == segment ? .bold : .regular)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 2)

                        // "New" 뱃지 - 더 가깝게 offset
                        if segment == .drink || segment == .food || segment == .product {
                            Text("New")
                                .font(.system(size: 10))
                                .foregroundColor(.green)
                                .offset(x: 32, y: -6)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
    }
}
#Preview {
    OrderView()
}
