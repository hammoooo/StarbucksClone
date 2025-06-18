import Foundation
import Moya


protocol BaseTarget: TargetType {}

extension BaseTarget {
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
}
