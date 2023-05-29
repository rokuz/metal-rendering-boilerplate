import SwiftUI
import renderer

@main
struct LauncherApp: App {
#if os(macOS)
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
#else
  @UIApplicationDelegateAdaptor(AppDelegateIOS.self) var appDelegate
#endif
  
  var body: some Scene {
    WindowGroup {
      ContentView()
#if os(macOS)
        .navigationTitle(LaunchParams.windowTitle())
        .frame(width: LaunchParams.viewportSize().width / (NSScreen.main?.backingScaleFactor ?? 1.0),
               height: LaunchParams.viewportSize().height / (NSScreen.main?.backingScaleFactor ?? 1.0),
               alignment: .center)
#else
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.red)
        .edgesIgnoringSafeArea(.all)
#endif
    }
#if os(macOS)
    .windowResizability(.contentSize)
#endif
  }
}
