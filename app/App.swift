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
        .frame(idealWidth: LaunchParams.viewportSize().width / (NSScreen.main?.backingScaleFactor ?? 1.0),
               maxWidth: .infinity,
               idealHeight: LaunchParams.viewportSize().height / (NSScreen.main?.backingScaleFactor ?? 1.0),
               maxHeight: .infinity,
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
