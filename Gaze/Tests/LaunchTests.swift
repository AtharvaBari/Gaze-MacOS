//
//  LaunchTests.swift
//  GazeTests
//

import XCTest
import SwiftUI
import ViewInspector
@testable import Gaze

extension WelcomeView: Inspectable {}

final class LaunchTests: XCTestCase {
    func testWelcomeViewAppearsOnFirstLaunch() throws {
        // Ensure first launch flag is reset
        UserDefaults.standard.removeObject(forKey: "hasLaunched")
        let manager = LaunchManager()
        XCTAssertTrue(manager.isFirstLaunch)
        
        let view = WelcomeView()
        // Verify that the view contains the expected text
        let text = try view.inspect().find(text: "Welcome to Gaze")
        XCTAssertEqual(try text.string(), "Welcome to Gaze")
    }
}
