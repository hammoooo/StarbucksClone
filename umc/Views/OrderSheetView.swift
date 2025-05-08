import SwiftUI
import MapKit

struct OrderSheetView: View {
    @StateObject private var viewModel = OrderSheetViewModel()

    var body: some View {
        VStack(spacing: 0) {
            sheetHandleBar
            header
            searchBar
            segmentControl
            Divider()

            if viewModel.isMapMode {
                mapView
            } else {
                storeListView
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    // 상단 반원 바
    private var sheetHandleBar: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .frame(width: 40, height: 5)
            .cornerRadius(2.5)
            .padding(.top, 8)
    }

    private var header: some View {
        ZStack {
            HStack {
                Spacer()
                Button(action: { viewModel.toggleMapListMode() }) {
                    Image(systemName: viewModel.isMapMode ? "list.bullet" : "map")
                        .font(.title3)
                }
            }

            Text("매장 설정")
                .font(.PretendardMedium(15))
                
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }


    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            Text("검색")
                .foregroundColor(.gray)
            Spacer()
        }
        .padding(12)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.top, 8)
    }

    private var segmentControl: some View {
        HStack(spacing: 0) {
            ForEach(StoreListType.allCases.indices, id: \.self) { index in
                let type = StoreListType.allCases[index]

                Button(action: {
                    viewModel.selectedSegment = type
                }) {
                    Text(type.rawValue)
                        .foregroundColor(viewModel.selectedSegment == type ? .black : .gray)
                        .fontWeight(viewModel.selectedSegment == type ? .bold : .regular)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                }

                // Insert vertical divider except after the last item
                if index < StoreListType.allCases.count - 1 {
                    Divider()
                        .frame(width: 1, height: 20)
                        .background(Color.gray.opacity(0.3))
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }


    private var storeListView: some View {
        ScrollView {
            if let userLocation = viewModel.userLocation {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(viewModel.filteredStores) { store in
                        StoreRow(store: store, userLocation: userLocation)
                    }
                }
                .padding(.top, 8)
            } else {
                Text("위치 정보를 불러오는 중입니다...")
                    .foregroundColor(.gray)
                    .padding(.top, 40)
            }
        }
    }

    private var mapView: some View {
        ZStack(alignment: .top) {
            MapView(region: $viewModel.region, stores: viewModel.filteredStores)

            // 중앙 상단에 "이 지역 검색" 버튼
            VStack {
                Button(action: {
                    if let center = viewModel.cameraCenter {
                        viewModel.refreshMarkers(for: center)
                    }
                }) {
                    Text("이 지역 검색")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 3)
                }
                .padding(.top, 12)
                Spacer()
            }

            // 우측 상단 모드 토글 버튼은 header에서 처리됨
        }
    }
}


#Preview {
    OrderSheetView()
    
}
