import SwiftUI

class SettingsStore: ObservableObject {
    @AppStorage("workDurationMinutes") var workDurationMinutes: Int = 25
    @AppStorage("breakDurationMinutes") var breakDurationMinutes: Int = 5
    @AppStorage("maxCycles") var maxCycles: Int = 4
    @AppStorage("isPeriodicPeekEnabled") var isPeriodicPeekEnabled: Bool = false
    @AppStorage("peekIntervalMinutes") var peekIntervalMinutes: Int = 5
    @AppStorage("trackCursor") var trackCursor: Bool = false
    @AppStorage("autoCheckUpdates") var autoCheckUpdates: Bool = true
    @AppStorage("enableSounds") var enableSounds: Bool = true
    @AppStorage("hideOnInactivity") var hideOnInactivity: Bool = false
    
    var workDurationSeconds: Int { workDurationMinutes * 60 }
    var breakDurationSeconds: Int { breakDurationMinutes * 60 }
    
    func playSound(_ name: NSSound.Name) {
        guard enableSounds else { return }
        if let sound = NSSound(named: name) {
            sound.volume = 0.4
            sound.play()
        }
    }
}
