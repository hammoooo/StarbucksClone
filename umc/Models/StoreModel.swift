import Foundation
import CoreLocation

struct Store: Identifiable, Decodable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    let category: StoreCategory
    let imageName: String
    let address: String

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

enum StoreCategory: String, Decodable {
    case reserve = "R"
    case dt = "D"
    case normal = "N"
}

enum StoreListType: String, CaseIterable {
    case nearby = "가까운 매장"
    case frequent = "자주 가는 매장"
}
