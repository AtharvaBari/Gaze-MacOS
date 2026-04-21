import SwiftUI

struct SleepCurve: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.height / 2))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.height / 2),
                          control: CGPoint(x: rect.midX, y: rect.maxY))
        return path
    }
}

struct EyeView: View {
    var blinkScale: CGFloat
    var lookOffset: CGSize
    var isSleeping: Bool
    var emotion: EyeEmotion
    
    var body: some View {
        ZStack {
            Capsule()
                .fill(Color.white)
                .frame(width: 14, height: 18)
            
            ZStack {
                if let emoji = emotion.emoji {
                    Text(emoji)
                        .font(.system(size: 14))
                        .shadow(color: .black.opacity(0.4), radius: 1.5, x: 0, y: 1)
                        .offset(lookOffset)
                } else {
                    Circle()
                        .fill(Color(white: 0.12)) // Dark pupil
                        .frame(width: 9, height: 9)
                        .overlay(
                            Circle()
                                .fill(Color.white)
                                .frame(width: 3, height: 3)
                                .offset(x: -1.5, y: -2)
                        )
                        .offset(lookOffset)
                }
            }
            .clipShape(Capsule())
            
            // Sleep Curve overlay (Fades in when totally shut mechanically)
            SleepCurve()
                .stroke(Color.white, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                .frame(width: 12, height: 6)
                .offset(y: 4)
                .opacity(isSleeping ? 1.0 : 0.0)
        }
        .frame(width: 14, height: 18)
        .scaleEffect(y: isSleeping ? 0.05 : blinkScale)
        .animation(.easeInOut(duration: 0.2), value: isSleeping)
    }
}
