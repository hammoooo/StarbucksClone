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
    
    static var PretendardBold30: Font {
        return .pretend(type: .bold, size: 30)
    }
    
    /* 여기에 더 추가해주세요 */
    
}
