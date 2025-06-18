//import SwiftUI
//import MapKit
//
//
//@Observable
//final class PlaceSearchViewModel {
//    @Published var departureQuery: String = ""       // <- 텍스트 필드와 연결됨
//    @Published var alert: AlertData? = nil           // <- 오류 시 경고창용
//
//    private let locationManager = CLLocationManager()
//    private var cancellables = Set<AnyCancellable>()
//
//    // ✅ 현재 위치 요청 함수
//    func requestCurrentLocation() {
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//        locationManager.publishLastLocation()
//            .first()                            // 한 번만 받기
//            .sink { [weak self] loc in
//                guard let self else { return }
//                Task {
//                    await self.reverseGeocode(loc)
//                }
//            }
//            .store(in: &cancellables)
//    }
//
//    // ✅ 위도/경도 → 주소 변환
//    private func reverseGeocode(_ loc: CLLocation) async {
//        do {
//            let placemarks = try await CLGeocoder().reverseGeocodeLocation(loc)
//            guard let mark = placemarks.first else { return }
//
//            // ✅ 주소(법정동 또는 시군구) 추출
//            let district = mark.locality ?? mark.administrativeArea ?? ""
//
//            // ✅ 출발지 텍스트 필드에 자동 입력
//            await MainActor.run {
//                self.departureQuery = district
//            }
//        } catch {
//            // 오류 발생 시 Alert로 표시
//            await MainActor.run {
//                self.alert = .init(title: "위치 오류", message: error.localizedDescription)
//            }
//        }
//    }
//}
