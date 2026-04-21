import Foundation

enum EyeState: String, CaseIterable, Equatable {
    case idle
    case focused
    case relaxed
    case sleeping
    
    var blinkInterval: ClosedRange<TimeInterval> {
        switch self {
        case .idle:
            return 3.0...6.0
        case .focused:
            return 5.0...12.0
        case .relaxed:
            return 2.0...5.0
        case .sleeping:
            return 86400.0...86400.0 // Never blink
        }
    }
    
    var lookInterval: ClosedRange<TimeInterval> {
        switch self {
        case .idle:
            return 2.0...4.0
        case .focused:
            return 0.5...2.0
        case .relaxed:
            return 4.0...8.0
        case .sleeping:
            return 86400.0...86400.0 // Never look
        }
    }
}
