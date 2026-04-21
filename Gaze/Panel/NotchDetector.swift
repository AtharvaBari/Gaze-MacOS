import AppKit
import Combine

struct NotchGeometry: Equatable {
    var notchRect: CGRect
    var extensionRect: CGRect
    var hasHardwareNotch: Bool
    var screenFrame: CGRect
}

class NotchDetector: ObservableObject {
    @Published var geometry: NotchGeometry?
    
    func detect(for screen: NSScreen?) {
        guard let screen = screen else { return }
        
        let screenFrame = screen.frame
        let hasNotch = screen.safeAreaInsets.top > 0
        let notchHeight: CGFloat = hasNotch ? screen.safeAreaInsets.top : 32.0
        let notchY = screenFrame.maxY - notchHeight
        
        var notchRect: CGRect
        if hasNotch, #available(macOS 12.0, *) {
            if let topLeft = screen.auxiliaryTopLeftArea, let topRight = screen.auxiliaryTopRightArea {
                let notchX = topLeft.maxX
                let notchWidth = topRight.minX - notchX
                notchRect = CGRect(x: notchX, y: notchY, width: notchWidth, height: notchHeight)
            } else {
                let width: CGFloat = 200
                notchRect = CGRect(x: screenFrame.midX - (width/2), y: notchY, width: width, height: notchHeight)
            }
        } else {
            let width: CGFloat = 200
            notchRect = CGRect(x: screenFrame.midX - (width/2), y: notchY, width: width, height: notchHeight)
        }
        
        let leftExtension: CGFloat = 80
        let rightExtension: CGFloat = 100
        
        let extensionX = notchRect.minX - leftExtension
        let extensionWidth = leftExtension + notchRect.width + rightExtension
        let extensionRect = CGRect(x: extensionX, y: notchY, width: extensionWidth, height: notchHeight)
        
        self.geometry = NotchGeometry(notchRect: notchRect, extensionRect: extensionRect, hasHardwareNotch: hasNotch, screenFrame: screenFrame)
    }
    
    func startMonitoring() {
        NotificationCenter.default.addObserver(forName: NSApplication.didChangeScreenParametersNotification, object: nil, queue: .main) { [weak self] _ in
            self?.detect(for: NSScreen.main)
        }
    }
}
