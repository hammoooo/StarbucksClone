import Foundation
import SwiftUI

extension Font {
    enum Pretend {
        case extraBold
        case bold
        case semibold
        case medium
        case regular
        case light
        
        var value: String {
            switch self {
            case .extraBold:
                return "Pretendard-ExtraBold"
            case .bold:
                return "Pretendard-Bold"
            case .semibold:
                return "Pretendard-SemiBold"
            case .medium:
                return "Pretendard-Medium"
            case .regular:
                return "Pretendard-Regular"
            case .light:
                return "Pretendard-Light"
            }
        }
    }
    
    static func pretend(type: Pretend, size: CGFloat) -> Font {
        return .custom(type.value, size: size)
    }
    
    static func PretendardBold(_ size: CGFloat) -> Font {
        return .pretend(type: .bold, size: size)
    }

    static func PretendardMedium(_ size: CGFloat) -> Font {
        return .pretend(type: .medium, size: size)
    }

    static func PretendardSemiBold(_ size: CGFloat) -> Font {
        return .pretend(type: .semibold, size: size)
    }

    /* 여기에 더 추가해주세요 */
    
}
