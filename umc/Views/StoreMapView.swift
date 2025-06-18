import SwiftUI
import MapKit

struct StoreMapView: View {
    
    @StateObject private var mapViewModel = DirectionViewModel()
    
    @StateObject private var destinationSearchVM = DestinationSearchViewModel()
    @State private var destination: String = ""
    
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = StoreMapViewModel()
    @Namespace private var animation
    
    
    @State private var isCurrentLocation: Bool = true
    @State private var departure: String = ""
    
    
    var body: some View {
        
        
        VStack(spacing: 20) {
            header
            segmentBar
            Divider().padding(.vertical, 5)
            
            if viewModel.selectedSegment == .direction {
                
                DirectionInputFields
                 .padding(.horizontal)
                 .padding(.vertical)
                
            }
            
            
            
            ZStack(alignment: .top) {
                if viewModel.selectedSegment == .store {
                    mapView
                    searchHereButton
                    locationButton
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
    }
    
    
    
    private var DirectionInputFields: some View {
        ScrollView {
            VStack(spacing: 20) {
                // MARK: 출발지 필드
                HStack {
                    Text("출발")
                        .font(.PretendardSemiBold(16))
                    
                    Button(action: {
                        isCurrentLocation = true
                        departure = ""
                        Task {
                            await mapViewModel.fetchCurrentLocationAddress()
                            if let address = mapViewModel.currentAddress {
                                departure = address
                            }
                        }
                    }) {
                        Text("현재위치")
                            .font(.PretendardSemiBold(13))
                            .frame(maxWidth: 58, maxHeight: 30)
                            .foregroundColor(.white)
                            .background(RoundedRectangle(cornerRadius: 6).fill(.brown01))
                    }
                    
                    TextField("출발지 입력", text: $mapViewModel.keyword)
                        .font(.PretendardRegular(16))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(RoundedRectangle(cornerRadius: 4).stroke(Color.gray.opacity(0.6), lineWidth: 1))
                        .frame(maxWidth: 237, maxHeight: 30)
                        .onSubmit {
                            Task { await mapViewModel.performSearch() }
                        }
                    
                    Button {
                        Task { await mapViewModel.performSearch() }
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.black02)
                    }
                }
                
                
                
                // MARK: 도착지 필드
                HStack {
                    Text("도착")
                        .font(.PretendardSemiBold(16))
                    
                    TextField("매장명 또는 주소", text: $destinationSearchVM.keyword)
                        .font(.PretendardRegular(16))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(RoundedRectangle(cornerRadius: 4).stroke(Color.gray.opacity(0.6), lineWidth: 1))
                        .frame(maxWidth: 303, maxHeight: 30)
                        .onSubmit {
                            print("🚨 도착지 검색 시작됨")
                            destinationSearchVM.search()
                        }
                    
                    Button {
                        destinationSearchVM.search()
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.black02)
                    }
                }
                
//                Button(action: {
//                    print("경로 찾기")
//                }) {
//                    Text("경로 찾기")
//                        .font(.PretendardSemiBold(16))
//                        .foregroundColor(.white)
//                        .frame(maxWidth: 369, maxHeight: 38)
//                        .background(RoundedRectangle(cornerRadius: 10).fill(.green00))
//                }.frame(height: 44)
//                .padding(.top, 30)
                
                Button {
                    print("🚀 경로 요청 시작")
                    if mapViewModel.selectedPlaceName == nil {
                        print("❌ 출발지 이름이 선택되지 않았습니다")
                    }
                    if !mapViewModel.searchResults.contains(where: { $0.place_name == mapViewModel.selectedPlaceName }) {
                        print("❌ 출발지 이름이 searchResults에 존재하지 않습니다")
                    }
                    if !destinationSearchVM.results.contains(where: { $0.name == destination }) {
                        print("❌ 도착지 이름이 검색 결과에 존재하지 않습니다")
                    }
                    guard let startPlace = mapViewModel.searchResults.first(where: { $0.place_name == mapViewModel.selectedPlaceName }),
                          let destinationStore = destinationSearchVM.results.first(where: { $0.name == destination }) else {
                        print("❌ 출발지 또는 도착지 정보 부족")
                        return
                    }

                    let fromCoordinate = CLLocationCoordinate2D(latitude: startPlace.y, longitude: startPlace.x)
                    let toCoordinate = CLLocationCoordinate2D(latitude: destinationStore.latitude, longitude: destinationStore.longitude)

                    destinationSearchVM.fetchWalkingRoute(from: fromCoordinate, to: toCoordinate)
                } label: {
                    if destinationSearchVM.isLoadingRoute {
                        ProgressView()
                            .frame(maxWidth: 369, maxHeight: 38)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.green00))
                    } else {
                        Text("경로 찾기")
                            .font(.PretendardSemiBold(16))
                            .foregroundColor(.white)
                            .frame(maxWidth: 369, maxHeight: 38)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.green00))
                    }
                }
                .frame(height: 44)
                .padding(.top, 30)


                
                // MARK: 검색 결과 리스트
                if !mapViewModel.searchResults.isEmpty {
                    VStack(spacing: 0) {
                        ForEach(mapViewModel.searchResults, id: \.place_name) { place in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(place.place_name)
                                    .font(.PretendardRegular(16))
                                Text(place.address_name)
                                    .font(.PretendardRegular(13))
                                    .foregroundColor(.gray01)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.white)
                            .onTapGesture {
                                departure = place.place_name
                                mapViewModel.keyword = place.place_name
                                mapViewModel.selectPlace(place)
                            }
                            
                            Divider()
                        }
                    }
                }
                
                // 출발지 검색 결과 리스트
                //            if !mapViewModel.searchResults.isEmpty {
                //                StoreSearchResultListView(results: mapViewModel.searchResults) { place in
                //                    departure = place.place_name
                //                    mapViewModel.keyword = place.place_name
                //                    mapViewModel.selectPlace(place)
                //                }
                //            }
                
                // 도착지 검색 결과 리스트
                if !destinationSearchVM.results.isEmpty {
                    StoreSearchResultListView(results: destinationSearchVM.results) { store in
                        destination = store.name
                        destinationSearchVM.keyword = store.name
                        destinationSearchVM.results = []
                    }
                }
                
            }.padding(.top, 10)
        }
        .alert("검색 결과가 존재하지 않습니다.", isPresented: $mapViewModel.showAlert) {
            Button("확인", role: .cancel) {}
        }
    }
    
    
    
    private var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .foregroundColor(.black)
            }
            Spacer()
            Text("매장 찾기")
                .font(.headline)
            Spacer()
        }
        .padding()
    }
    
    private var segmentBar: some View {
        HStack(spacing: 0) {
            ForEach(StoreMapSegment.allCases, id: \.self) { segment in
                Button {
                    withAnimation(.spring()) {
                        viewModel.selectedSegment = segment
                    }
                } label: {
                    VStack(spacing: 4) {
                        Text(segment.rawValue)
                            .font(.PretendardBold(22))
                            .foregroundColor(viewModel.selectedSegment == segment ? .black : .gray)
                        
                        if viewModel.selectedSegment == segment {
                            Rectangle()
                                .fill(Color.brown)
                                .frame(height: 2)
                                .matchedGeometryEffect(id: "underline", in: animation)
                        } else {
                            Color.clear.frame(height: 2)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal)
        .background(Color.white)
    }
    
    
    
    
    private var mapView: some View {
        Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.stores) { store in
            MapAnnotation(coordinate: store.coordinate) {
                Image("starbucks_pin") // ✅ 커스텀 핀
                    .resizable()
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(radius: 3)
                    .onTapGesture {
                        // 매장 상세 보기 연결 가능
                    }
                    .offset(y: -22) // 핀 하단이 위치 중심에 맞도록 조정
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private var locationButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    viewModel.moveToCurrentLocation()
                }) {
                    Image(systemName: "location.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.black)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .padding(.trailing, 16)
                .padding(.bottom, 40)
            }
        }
    }
    
    private var searchHereButton: some View {
        HStack {
            Spacer()
            Button(action: {
                print("이 지역 검색 실행")
                // 여기에 viewModel.refreshNearbyStores() 등 로직 연결 가능
            }) {
                Text("이 지역 검색")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
            Spacer()
        }
        .padding(.top, 12)
    }
}

#Preview {
    StoreMapView()
}
