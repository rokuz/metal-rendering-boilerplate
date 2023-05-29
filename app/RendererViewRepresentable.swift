import SwiftUI
import renderer

#if os(macOS)
struct RendererViewRepresetable: NSViewRepresentable {
  func makeNSView(context: Context) -> RendererView {
    RendererView()
  }
  
  func updateNSView(_ nsView: RendererView, context: Context) {
  }
}
#elseif os(iOS)
struct RendererViewRepresetable: UIViewRepresentable {
  func makeUIView(context: Context) -> RendererView {
    RendererView()
  }
  
  func updateUIView(_ nsView: RendererView, context: Context) {
  }
}
#endif
