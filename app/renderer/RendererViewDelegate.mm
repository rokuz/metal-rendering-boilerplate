#import "RendererViewDelegate.h"

#include <memory>

#import "../interface/mrbp/MetalRenderer.hpp"

@interface RendererViewDelegate () {
  std::unique_ptr<mrbp::MetalRenderer> _renderer;
}
@end

@implementation RendererViewDelegate

+ (instancetype)sharedDelegate {
  static RendererViewDelegate * instance;
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    instance = [[self alloc] init];
    instance.metalDevice = MTLCreateSystemDefaultDevice();
  });
  return instance;
}

- (void)drawInMTKView:(nonnull MTKView *)view {
  if (_renderer) {
    @autoreleasepool {
      _renderer->onFrame([view = view]() { return view.currentDrawable; },
                         view.depthStencilTexture);
    }
  }
}

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size {
  NSLog(@"Viewport size = %d x %d", static_cast<int>(size.width), static_cast<int>(size.height));
  self.viewportSize = size;
  if (!_renderer) {
    _renderer = createMetalRenderer(
      self.metalDevice,
      glm::uvec2{static_cast<uint32_t>(size.width), static_cast<uint32_t>(size.height)},
      view.colorPixelFormat);
#if TARGET_IOS || TARGET_OS_SIMULATOR
    _renderer->onEnterForeground();
#endif
  } else {
    _renderer->onResize(
      glm::uvec2{static_cast<uint32_t>(size.width), static_cast<uint32_t>(size.height)});
  }
}

- (void)onTouchEvent:(mrbp::TouchEvent)event {
  if (_renderer) {
    _renderer->onTouchEvent(std::move(event));
  }
}

- (void)onKeyEvent:(mrbp::KeyEvent)event {
  if (_renderer) {
    _renderer->onKeyEvent(std::move(event));
  }
}

- (void)onEnterForeground {
  if (_renderer) {
    _renderer->onEnterForeground();
  }
}

- (void)onEnterBackground {
  if (_renderer) {
    _renderer->onEnterBackground();
  }
}

@end
