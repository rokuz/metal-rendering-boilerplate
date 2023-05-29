#if !os(macOS)
import UIKit
import renderer

class SceneDelegateIOS: NSObject, UIWindowSceneDelegate {
  func sceneWillEnterForeground(_ scene: UIScene) {
    RendererView.onEnterForeground()
  }

  func sceneDidEnterBackground(_ scene: UIScene) {
    RendererView.onEnterBackground()
  }
}
#endif
