import SwiftUI

/// Manages first‑launch state for the app.
///
/// The `isFirstLaunch` property is `true` only on the very first run of the app.
/// After the welcome animation finishes, call `markLaunched()` to persist the flag.
final class LaunchManager: ObservableObject {
    @Published var isFirstLaunch: Bool
    private let launchedKey = "hasLaunched"

    init() {
        let launched = UserDefaults.standard.bool(forKey: launchedKey)
        self.isFirstLaunch = !launched
    }

    /// Call this when the welcome animation has completed.
    func markLaunched() {
        UserDefaults.standard.set(true, forKey: launchedKey)
        // Update the published property so the UI switches to the main content.
        withAnimation {
            self.isFirstLaunch = false
        }
    }
}
