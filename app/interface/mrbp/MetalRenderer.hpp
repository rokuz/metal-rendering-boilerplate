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
  virtual ~MetalRenderer() = default;

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

struct MetalDevice {
  id<MTLDevice> _Nonnull metalDevice;
};
}  // namespace mrbp

// These functions must be implemented in custom renderer.
extern std::shared_ptr<mrbp::MetalDevice> createMetalDevice();

extern std::unique_ptr<mrbp::MetalRenderer> createMetalRenderer(
  std::shared_ptr<mrbp::MetalDevice> device,
  glm::uvec2 size,
  MTLPixelFormat colorPixelFormat);
extern mrbp::LaunchParams getLaunchParams();
