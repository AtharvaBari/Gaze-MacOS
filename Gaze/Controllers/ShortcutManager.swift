import Foundation
import AppKit

class ShortcutManager {
    static let shared = ShortcutManager()
    
    var onToggleTimer: (() -> Void)?
    
    private var globalMonitor: Any?
    private var localMonitor: Any?
    
    private init() {
        setupGlobalShortcut()
    }
    
    func setupGlobalShortcut() {
        // Global hook (Only fires when app is NOT active)
        globalMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            // keycode 35 is 'P'. Modifiers Cmd + Option
            let expectedModifiers: NSEvent.ModifierFlags = [.command, .option]
            if event.keyCode == 35 && event.modifierFlags.contains(expectedModifiers) && !event.modifierFlags.contains(.control) && !event.modifierFlags.contains(.shift) {
                DispatchQueue.main.async {
                    self?.onToggleTimer?()
                }
            }
        }
        
        // Local hook (Fires when App is active, e.g. Settings window)
        localMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            let expectedModifiers: NSEvent.ModifierFlags = [.command, .option]
            if event.keyCode == 35 && event.modifierFlags.contains(expectedModifiers) && !event.modifierFlags.contains(.control) && !event.modifierFlags.contains(.shift) {
                DispatchQueue.main.async {
                    self?.onToggleTimer?()
                }
                return nil // Consume entirely
            }
            return event
        }
    }
    
    deinit {
        if let globalMonitor = globalMonitor {
            NSEvent.removeMonitor(globalMonitor)
        }
        if let localMonitor = localMonitor {
            NSEvent.removeMonitor(localMonitor)
        }
    }
}
