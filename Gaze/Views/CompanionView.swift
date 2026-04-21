import SwiftUI

struct ZAnimationView: View {
    @State private var phase = 0.0
    
    var body: some View {
        ZStack {
            Text("z")
                .font(.system(size: 9, weight: .bold, design: .rounded))
                .foregroundColor(Color(white: 0.8))
                .offset(x: sin(phase) * 5 + 2, y: -phase * 4 + 4)
                .opacity(max(0, 1.0 - phase / 4.0))
                .scaleEffect(0.5 + phase / 4.0)
            
            Text("Z")
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundColor(Color(white: 0.8))
                .offset(x: sin(phase + .pi) * 6 - 2, y: -phase * 3 - 2)
                .opacity(max(0, 1.0 - max(0, phase - 1.0) / 3.0))
                .scaleEffect(0.5 + phase / 5.0)
        }
        .onAppear {
            withAnimation(.linear(duration: 4.0).repeatForever(autoreverses: false)) {
                phase = 4.0
            }
        }
    }
}

struct CompanionView: View {
    @StateObject private var controller = EyeController()
    @ObservedObject var timerEngine: TimerEngine
    @ObservedObject var settings: SettingsStore
    
    var body: some View {
        ZStack {
            // Z particles
            if controller.state == .sleeping {
                ZAnimationView()
                    .offset(x: 10, y: -10)
            }
            HStack(spacing: 8) {
                ZStack {
                    EyeView(blinkScale: controller.leftBlinkScale, lookOffset: controller.lookOffset, isSleeping: controller.state == .sleeping && controller.leftBlinkScale < 0.5, emotion: controller.currentEmotion)
                    
                    if controller.state == .sleeping && controller.showsMagnifyingGlass && controller.isLeftEyePeeking {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 24, weight: .heavy))
                            .foregroundColor(Color(white: 0.12)) // Dark contrast
                            .shadow(color: .white.opacity(0.8), radius: 2)
                            .offset(x: controller.lookOffset.width - 4, y: controller.lookOffset.height - 4)
                            .rotationEffect(.degrees(15))
                    }
                }
                ZStack {
                    EyeView(blinkScale: controller.rightBlinkScale, lookOffset: controller.lookOffset, isSleeping: controller.state == .sleeping && controller.rightBlinkScale < 0.5, emotion: controller.currentEmotion)
                    
                    if controller.state == .sleeping && controller.showsMagnifyingGlass && !controller.isLeftEyePeeking {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 24, weight: .heavy))
                            .foregroundColor(Color(white: 0.12))
                            .shadow(color: .white.opacity(0.8), radius: 2)
                            .offset(x: controller.lookOffset.width - 4, y: controller.lookOffset.height - 4)
                            .rotationEffect(.degrees(15))
                    }
                }
            }
        }
        .onChange(of: timerEngine.mode) { newMode in
            switch newMode {
            case .countdown:
                controller.state = .idle
            case .idle, .completed:
                controller.state = .sleeping
            case .work:
                controller.state = .focused
            case .break:
                controller.state = .relaxed
            }
        }
        .onChange(of: settings.trackCursor) { tracking in
            controller.isCursorTrackingEnabled = tracking
        }
        .onAppear {
            controller.isCursorTrackingEnabled = settings.trackCursor
            if timerEngine.mode == .idle {
                controller.state = .sleeping
            }
        }
    }
}
