import Foundation
import CoreLocation
import MapKit
import Observation

@Observable
class LocationManager: NSObject {
    
    static let shared = LocationManager()
    
    // MARK: - CLLocationManager
    private let locationManager = CLLocationManager()
    
    // MARK: - Published Properties
    var currentLocation: CLLocation?
    var currentHeading: CLHeading?
    
    var currentSpeed: CLLocationSpeed = 0
    var currentDirection: CLLocationDirection = 0
    
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    var didEnterGeofence: Bool = false
    
    // MARK: - Init
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.headingFilter = kCLHeadingFilterNone
        
        requestAuthorization()
        startUpdatingLocation()
        startUpdatingHeading()
        
        
    }
    
    // MARK: - 권한 요청
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
    }

    // MARK: - 위치 추적
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - 방향 추적
    func startUpdatingHeading() {
        locationManager.startUpdatingHeading()
    }
    
    func stopUpdatingHeading() {
        locationManager.stopUpdatingHeading()
    }

    // MARK: - Significant Location Change
    func startMonitoringSignificantLocationChanges() {
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func stopMonitoringSignificantLocationChanges() {
        locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    // MARK: - 방문 감지
    func startMonitoringVisits() {
        locationManager.startMonitoringVisits()
    }

    // MARK: - 지오펜싱
    func startMonitoringGeofence(center: CLLocationCoordinate2D,
                                 radius: CLLocationDistance,
                                 identifier: String) {
        let region = CLCircularRegion(center: center,
                                      radius: radius,
                                      identifier: identifier)
        region.notifyOnEntry = true
        region.notifyOnExit = true
        
        locationManager.startMonitoring(for: region)
    }

    func stopMonitoringAllGeofences() {
        for region in locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: region)
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    
    // 권한 변경 감지
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }

    // 위치 업데이트 감지 (기본 위치 추적 + Significant Change)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let latest = locations.last {
            DispatchQueue.main.async {
                self.currentLocation = latest
                self.currentSpeed = max(latest.speed, 0)
            }
        }
    }

    // 방향 감지
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        DispatchQueue.main.async {
            self.currentHeading = newHeading
            self.currentDirection = newHeading.trueHeading > 0 ? newHeading.trueHeading : newHeading.magneticHeading
        }
    }

    // 방문 감지 (visit monitoring)
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        print("방문 감지됨 - 좌표: \(visit.coordinate), 도착: \(visit.arrivalDate), 출발: \(visit.departureDate)")
    }

    // 지오펜싱: 진입
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        DispatchQueue.main.async {
            self.didEnterGeofence = true
        }
    }

    // 지오펜싱: 이탈
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        DispatchQueue.main.async {
            self.didEnterGeofence = false
        }
    }

    // 오류 처리
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치 오류: \(error.localizedDescription)")
    }
}



/*

### init() 코드 설명

- **locationManager.delegate = self**
    - 위치 정보나 방향이 바뀔 때 자신한테 알려달라는 의미
- **locationManager.desiredAccuracy = kCLLocationAccuracyBest**
    - 위치 정보의 정확도 수준을 설정, 배터리 많이 소모
- **locationManager.headingFilter = kCLHeadingFilterNone**
    - 방향(나침반) 업데이트 민감도 설정
    - 아주 작은 변화도 모두 반영
    - 사용자가 핸드폰을 살짝 돌려도 방향 정보가 업데이트 됨
- **startUpdatingLocation()**
    - 실시간 위치 추적 시작
    - 호출 이후 **`locationManager(_:didUpdateLocations:)`** 델리게이트 메서드가 주기적으로 호출됨
    - 위치 변경이 감지되면 자동으로 알려줌
- **startUpdatingHeading()**
    - 기기의 나침반(방향 센서) 정보 수신 시작
    - 호출 이후 locationManager(_:didUpdateHeading:) 메서드 호출

### Extension 설명

- **locationManagerDidChangeAuthorization(_:)**
    - 사용자가 위치 권한을 승인/거부하거나 설정을 변경했을 때 호출
- **didUpdateLocations**
    - startUpdatingLocation() 호출 후, 위치가 변경될 때마다 반복적으로 호출됨
- **didUpdateHeading**
    - startUpdatingHeading()을 호출하면 방향(나침반) 값이 바뀔 때마다 호출됨
- **didFailWithError**
    - 위치 정보 요청 중 문제가 발생했을 때 호출됨
- **didVisit**
    - 사용자가 어떤 장소에 도착해서 일정 시간 머무르고 떠났을 때 호출
    - 보통은 머무른  시간이 수 분 이상이고, 이동이 명확하게 감지될 경우 호출
    - iOS 시스템이 자동으로 의미 있는 장소를 인식해서 감지함
- **didEnterRegion**
    - 사용자가 지정한 영역(**CLCircularRegion)** 안으로 들어갔을 때
- **didExitRegion**
    - 사용자가 설정한 영역 밖으로 나갔을 때

*/







//import Foundation
//import CoreLocation
//
//class LocationManager: NSObject, CLLocationManagerDelegate {
//    static let shared = LocationManager()
//
//    private let manager = CLLocationManager()
//    private var completion: ((CLLocation?) -> Void)?
//
//    private override init() {
//        super.init()
//        manager.delegate = self
//        manager.desiredAccuracy = kCLLocationAccuracyBest
//    }
// 이게 원샷 위치 추적이라 배터리 효율이래
//    func requestLocation(completion: @escaping (CLLocation?) -> Void) {
//        self.completion = completion
//        manager.requestWhenInUseAuthorization()
//        manager.requestLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        completion?(locations.first)
//        completion = nil
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("위치 요청 실패: \(error.localizedDescription)")
//        completion?(nil)
//        completion = nil
//    }
//}
