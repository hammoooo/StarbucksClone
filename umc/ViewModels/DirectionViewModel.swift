

import Foundation
import CoreLocation

@MainActor
final class DirectionViewModel: ObservableObject {
    // MARK: - 위치 관련
    @Published var currentAddress: String? = nil
    @Published var currentLocation: CLLocation? = nil // why>?

    // MARK: - 키워드 검색 관련
    @Published var keyword: String = ""
    @Published var searchResults: [KakaoPlace] = []
    @Published var showAlert: Bool = false
    @Published var selectedPlaceName: String? = nil

    private let geocoder = CLGeocoder()

    // MARK: - 현재 위치 주소 받아오기
    func fetchCurrentLocationAddress() async {
        guard let location = LocationManager.shared.currentLocation else {
            print("위치 정보 없음")
            return
        }

        self.currentLocation = location

        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            if let placemark = placemarks.first {
                let rawComponents = [
                    placemark.administrativeArea,
                    placemark.locality,
                    placemark.subLocality,
                    placemark.thoroughfare
                ].compactMap { $0 }

                var seen = Set<String>()
                let filteredComponents = rawComponents.filter { seen.insert($0).inserted }

                let address = filteredComponents.joined(separator: " ")
                self.currentAddress = address
                self.keyword = address
                print("주소: \(address)")
            }
        } catch {
            print("역지오코딩 실패: \(error.localizedDescription)")
        }

    }

    // MARK: - 카카오 키워드 검색
    func performSearch() async {
        guard !keyword.isEmpty else { return }

        // 위치가 없다면 새로 받아와본다
        if currentLocation == nil {
            currentLocation = LocationManager.shared.currentLocation
        }

        guard let location = currentLocation else {
            print("위치 정보 없음")
            return
        }

        let results = await KakaoSearchAPI.shared.searchKeyword(keyword, at: location)

        if results.isEmpty {
            self.showAlert = true
        } else {
            self.searchResults = results
        }
    }

    // MARK: - 장소 선택
    func selectPlace(_ place: KakaoPlace) {
        selectedPlaceName = place.place_name
        keyword = place.place_name
        searchResults = []
    }
}
