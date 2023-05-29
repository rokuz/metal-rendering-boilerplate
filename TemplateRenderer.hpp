#pragma once

#include <cstdint>
#include <mrbp/MetalRenderer.hpp>

class TemplateRenderer : public mrbp::MetalRenderer {
public:
  TemplateRenderer(id<MTLDevice> _Nonnull device,
                   glm::uvec2 size,
                   MTLPixelFormat colorPixelFormat) noexcept;

  void onResize(glm::uvec2 size) noexcept override;
  void onFrame(std::function<id<CAMetalDrawable> _Nullable()> drawableGetter,
               id<MTLTexture> _Nullable depthStencilTexture) noexcept override;

  void onTouchEvent(mrbp::TouchEvent event) noexcept override;
  void onKeyEvent(mrbp::KeyEvent event) noexcept override;

  void onEnterForeground() noexcept override;
  void onEnterBackground() noexcept override;

private:
  id<MTLCommandBuffer> _Nonnull beginFrame() noexcept;
  void endFrame(id<CAMetalDrawable> _Nonnull drawable,
                id<MTLCommandBuffer> _Nonnull commandBuffer) noexcept;

  id<MTLDevice> _Nonnull device_;
  glm::uvec2 size_;
  id<MTLCommandQueue> _Nonnull commandQueue_;

  // id<MTLLibrary> _Nonnull library_;

  dispatch_semaphore_t _Nonnull inFlightFramesSemaphore_{};
  uint32_t inFlightFrameIndex_ = 0;
};
