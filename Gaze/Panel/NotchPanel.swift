import AppKit
import SwiftUI

class NotchPanel: NSPanel {
    init(contentRect: NSRect) {
        super.init(
            contentRect: contentRect,
            styleMask: [.nonactivatingPanel, .borderless, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        
        self.isFloatingPanel = true
        self.level = .statusBar
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]
        self.backgroundColor = .clear
        self.isOpaque = false
        self.hasShadow = false
        self.titlebarAppearsTransparent = true
        self.titleVisibility = .hidden
        self.isMovable = false
        self.becomesKeyOnlyIfNeeded = true
        self.ignoresMouseEvents = false
        self.acceptsMouseMovedEvents = true
        self.isReleasedWhenClosed = false
    }
    
    override var canBecomeKey: Bool { return true }
    override var canBecomeMain: Bool { return false }
    
    func setContent(_ view: some View) {
        self.contentView = NSHostingView(rootView: view)
    }
}
