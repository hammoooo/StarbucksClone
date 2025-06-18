//import SwiftUI
//
//struct FindRouteView: View {
//    @StateObject private var vm = PlaceSearchViewModel()
//    @FocusState private var focus: Field?
//
//    enum Field { case departure, destination }
//
//    var body: some View {
//        VStack(spacing: 16) {
//            // 출발지 텍스트 필드 + 버튼들
//            HStack {
//                TextField("출발지를 입력하세요", text: $vm.departureQuery)
//                    .textFieldStyle(.roundedBorder)
//                    .frame(height: 44)
//                    .focused($focus, equals: .departure)
//
//                Button {
//                    vm.requestCurrentLocation()
//                } label: {
//                    Image(systemName: "location.fill")
//                }
//
//                // 카카오
//                Button {
//                    vm.searchDeparture()
//                    focus = nil
//                } label: {
//                    Image(systemName: "magnifyingglass")
//                }
//            }
//        }
//    }
//}
