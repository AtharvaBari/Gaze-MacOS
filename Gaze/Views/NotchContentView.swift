import SwiftUI

struct NotchContentView: View {
    var geometry: NotchGeometry
    @ObservedObject var timerEngine: TimerEngine
    @ObservedObject var settings: SettingsStore
    @State private var isHovered = false
    
    @State private var isRevealed = false
    
    var shouldRetract: Bool {
        if isHovered { return false }
        
        if settings.isPeriodicPeekEnabled && !timerEngine.isPeeking {
            return true
        }
        
        if settings.hideOnInactivity && timerEngine.mode == .idle {
            return true
        }
        
        return false
    }
    
    var currentWidth: CGFloat {
        if !isRevealed || shouldRetract {
            return geometry.notchRect.width
        }
        return geometry.extensionRect.width
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.clear
                .contentShape(Rectangle())
            
            HStack(spacing: 0) {
                // Left area: Eyes or Play/Pause Button
                ZStack {
                    CompanionView(timerEngine: timerEngine, settings: settings)
                        .opacity(isHovered ? 0 : 1)
                        .opacity(isRevealed && !shouldRetract ? 1 : 0) // Fade eyes on expansion
                    
                    Button(action: {
                        if timerEngine.isRunning { timerEngine.pause() }
                        else { timerEngine.start() }
                    }) {
                        Image(systemName: timerEngine.isRunning ? "pause.fill" : "play.fill")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .opacity(isHovered && isRevealed && !shouldRetract ? 1 : 0)
                }
                .frame(width: isRevealed && !shouldRetract ? 80 : 0)
                .clipped()
                
                // Center area: Notch gap
                Spacer()
                    .frame(width: geometry.notchRect.width)
                
                // Right area: Timer or Reset Button
                ZStack {
                    TimerDisplayView(engine: timerEngine)
                        .opacity(isHovered ? 0 : 1)
                        .opacity(isRevealed && !shouldRetract ? 1 : 0)
                    
                    Button(action: {
                        timerEngine.reset()
                    }) {
                        Image(systemName: "stop.fill")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .opacity(isHovered && isRevealed && !shouldRetract ? 1 : 0)
                }
                .frame(width: isRevealed && !shouldRetract ? 100 : 0)
                .clipped()
            }
            .frame(width: currentWidth, height: geometry.notchRect.height)
            .background(Color.black)
            .clipShape(NotchShape(flareRadius: 8, bottomRadius: 12))
            .animation(.spring(response: 0.5, dampingFraction: 0.7), value: shouldRetract)
            .animation(.spring(response: 0.6, dampingFraction: 0.7), value: isRevealed)
        }
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    isRevealed = true
                }
            }
        }
    }
}
