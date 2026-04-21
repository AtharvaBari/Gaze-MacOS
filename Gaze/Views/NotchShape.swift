import SwiftUI

struct NotchShape: Shape {
    var flareRadius: CGFloat = 8
    var bottomRadius: CGFloat = 12
    
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(flareRadius, bottomRadius) }
        set {
            flareRadius = newValue.first
            bottomRadius = newValue.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let fr = flareRadius
        let br = bottomRadius
        
        // Start at top-left
        path.move(to: CGPoint(x: 0, y: 0))
        
        // Top-left flare (inward curve)
        // Center of arc is at (0, fr). From UP (270) to RIGHT (0/360).
        path.addArc(center: CGPoint(x: 0, y: fr),
                    radius: fr,
                    startAngle: .degrees(270),
                    endAngle: .degrees(360),
                    clockwise: false)
        
        // Down left side
        path.addLine(to: CGPoint(x: fr, y: rect.maxY - br))
        
        // Bottom-left standard corner
        // Center is (fr + br, maxY - br). From LEFT (180) to DOWN (90).
        path.addArc(center: CGPoint(x: fr + br, y: rect.maxY - br),
                    radius: br,
                    startAngle: .degrees(180),
                    endAngle: .degrees(90),
                    clockwise: true)
        
        // Bottom edge
        path.addLine(to: CGPoint(x: rect.maxX - fr - br, y: rect.maxY))
        
        // Bottom-right standard corner
        // Center is (maxX - fr - br, maxY - br). From DOWN (90) to RIGHT (0).
        path.addArc(center: CGPoint(x: rect.maxX - fr - br, y: rect.maxY - br),
                    radius: br,
                    startAngle: .degrees(90),
                    endAngle: .degrees(0),
                    clockwise: true)
        
        // Up right side
        path.addLine(to: CGPoint(x: rect.maxX - fr, y: fr))
        
        // Top-right flare
        // Center is (maxX, fr). From LEFT (180) to UP (270).
        path.addArc(center: CGPoint(x: rect.maxX, y: fr),
                    radius: fr,
                    startAngle: .degrees(180),
                    endAngle: .degrees(270),
                    clockwise: false)
        
        // Close path
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        return path
    }
}
