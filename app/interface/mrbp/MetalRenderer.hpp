#pragma once

#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

#include <functional>
#include <glm/glm.hpp>
#include <memory>

#include "Input.hpp"
#include "LaunchParams.hpp"

namespace mrbp {

class MetalRenderer {
public:
  MetalRenderer(id<MTLDevice> _Nonnull device,
                glm::uvec2 size,
                MTLPixelFormat colorPixelFormat) noexcept {}

  virtual void onResize(glm::uvec2 size) noexcept {}
  virtual void onFrame(std::function<id<CAMetalDrawable> _Nullable()> drawableGetter,
                       id<MTLTexture> _Nullable depthStencilTexture) noexcept {}

  // On MacOS mouse input is considered as a touch.
  virtual void onTouchEvent(TouchEvent event) noexcept {}

  // Only MacOS
  virtual void onKeyEvent(KeyEvent event) noexcept {}

  // Only iOS
  virtual void onEnterForeground() noexcept {}

  // Only iOS
  virtual void onEnterBackground() noexcept {}
};
}  // namespace mrbp

// These functions must be implemented in custom renderer.
extern std::unique_ptr<mrbp::MetalRenderer> createMetalRenderer(id<MTLDevice> _Nonnull device,
                                                                glm::uvec2 size,
                                                                MTLPixelFormat colorPixelFormat);
extern mrbp::LaunchParams getLaunchParams();
