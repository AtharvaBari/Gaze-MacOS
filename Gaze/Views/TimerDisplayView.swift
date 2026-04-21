import SwiftUI

struct TimerDisplayView: View {
    @ObservedObject var engine: TimerEngine
    
    var body: some View {
        Text(displayText)
            .font(.system(size: 14, weight: .regular, design: .rounded))
            .foregroundColor(engine.mode.textColor.opacity(0.85))
            .frame(width: 100)
            .animation(.default, value: engine.mode)
    }
    
    private var displayText: String {
        switch engine.mode {
        case .idle:
            return "Ready"
        case .countdown:
            return "\(engine.countdownValue)"
        case .work, .break:
            let m = engine.timeRemaining / 60
            let s = engine.timeRemaining % 60
            return String(format: "%02d:%02d", m, s)
        case .completed:
            return "Done!"
        }
    }
}
