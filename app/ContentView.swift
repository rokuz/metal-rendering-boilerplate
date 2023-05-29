import SwiftUI

struct ContentView: View {
  var body: some View {
    makeRendererViewRepresetable()
      .ignoresSafeArea()
  }
  
#if os(macOS)
  private func makeRendererViewRepresetable() -> some View {
    return RendererViewRepresetable()
  }
#elseif os(iOS)
  private func makeRendererViewRepresetable() -> some View {
    return RendererViewRepresetable()
  }
#endif
}
