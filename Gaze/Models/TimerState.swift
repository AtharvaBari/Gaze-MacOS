import Foundation
import SwiftUI

enum TimerMode: Equatable {
    case idle
    case countdown
    case work
    case `break`
    case completed
    
    var textColor: Color {
        switch self {
        case .break:
            return .orange.opacity(0.9)
        case .completed:
            return .green.opacity(0.9)
        default:
            return .white
        }
    }
}
