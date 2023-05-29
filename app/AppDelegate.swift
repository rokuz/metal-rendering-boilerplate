import Foundation
import renderer

#if os(macOS)

import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return LaunchParams.closeAppWithClosingWindow()
  }
}

#elseif os(iOS)

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
}

#endif
