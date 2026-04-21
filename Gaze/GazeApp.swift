import SwiftUI

@main
struct GazeApp: App {
    #if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #else
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif
    
    var body: some Scene {
        // We use an empty Scene because the app is purely accessory (LSUIElement)
        // and windows are managed manually by the AppDelegate.
        #if os(macOS)
        Settings { EmptyView() }
        #else
        WindowGroup { EmptyView() }
        #endif
    }
}
