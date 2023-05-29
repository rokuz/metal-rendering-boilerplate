#include "TemplateRenderer.hpp"

#include <mrbp/Config.hpp>
#include <mrbp/Utils.hpp>

std::unique_ptr<mrbp::MetalRenderer> createMetalRenderer(id<MTLDevice> _Nonnull device,
                                                         glm::uvec2 size,
                                                         MTLPixelFormat colorPixelFormat) {
  return std::make_unique<TemplateRenderer>(device, std::move(size), std::move(colorPixelFormat));
}

mrbp::LaunchParams getLaunchParams() {
  return mrbp::LaunchParams{.windowTitle = "Template Renderer"};
}

constexpr uint32_t kMaxFramesInFlight = 3;

TemplateRenderer::TemplateRenderer(id<MTLDevice> _Nonnull device,
                                   glm::uvec2 size,
                                   MTLPixelFormat colorPixelFormat) noexcept
  : mrbp::MetalRenderer(device, std::move(size), colorPixelFormat),
    device_(device),
    size_(std::move(size)) {
  commandQueue_ = [device_ newCommandQueue];

  // NOTE: Uncomment for loading default Metal shaders library.
  // auto shaderData = mrbp::loadResourceFromBundle(mrbp::kDefaultMetalLib);
  // if (shaderData.empty()) {
  //  NSLog(@"Error: Could not load %s", mrbp::kDefaultMetalLib.c_str());
  //  assert(false);
  // }
  // NSError * err = nil;
  // auto data = dispatch_data_create(shaderData.data(), shaderData.size(),
  //                                  nullptr, nullptr);
  // library_ = [device_ newLibraryWithData:data error:&err];
  // if (err) {
  //  NSLog(@"Error: %@", err.description);
  // }
  // assert(library_ != nil);

  inFlightFramesSemaphore_ = dispatch_semaphore_create(kMaxFramesInFlight);
}

void TemplateRenderer::onResize(glm::uvec2 size) noexcept { size_ = std::move(size); }

void TemplateRenderer::onFrame(std::function<id<CAMetalDrawable> _Nullable()> drawableGetter,
                               id<MTLTexture> _Nullable depthStencilTexture) noexcept {
  id<MTLCommandBuffer> commandBuffer = beginFrame();

  // Main render pass.
  auto drawable = drawableGetter();
  if (drawable) {
    MTLRenderPassDescriptor * rpDesc = [MTLRenderPassDescriptor renderPassDescriptor];
    rpDesc.colorAttachments[0].loadAction = MTLLoadActionClear;
    rpDesc.colorAttachments[0].storeAction = MTLStoreActionStore;
    rpDesc.colorAttachments[0].clearColor = MTLClearColorMake(0.0f, 0.0f, 0.0f, 0.0f);
    rpDesc.colorAttachments[0].texture = drawable.texture;

    id<MTLRenderCommandEncoder> renderEncoder =
      [commandBuffer renderCommandEncoderWithDescriptor:rpDesc];
    renderEncoder.label = @"Main Render Encoder";

    MTLViewport vp{.originX = 0,
                   .originY = 0,
                   .width = static_cast<float>(size_.x),
                   .height = static_cast<float>(size_.y),
                   .znear = 0,
                   .zfar = 1};
    [renderEncoder setViewport:vp];

    // Your rendering code.

    [renderEncoder endEncoding];
  }

  endFrame(drawable, commandBuffer);
}

id<MTLCommandBuffer> _Nonnull TemplateRenderer::beginFrame() noexcept {
  dispatch_semaphore_wait(inFlightFramesSemaphore_, DISPATCH_TIME_FOREVER);
  inFlightFrameIndex_ = (inFlightFrameIndex_ + 1) % kMaxFramesInFlight;

  id<MTLCommandBuffer> commandBuffer = [commandQueue_ commandBuffer];
  commandBuffer.label = @"Main Command Buffer";

  __block dispatch_semaphore_t blockSem = inFlightFramesSemaphore_;
  [commandBuffer addCompletedHandler:^(id<MTLCommandBuffer> _Nonnull) {
    dispatch_semaphore_signal(blockSem);
  }];

  return commandBuffer;
}

void TemplateRenderer::endFrame(id<CAMetalDrawable> _Nonnull drawable,
                                id<MTLCommandBuffer> _Nonnull commandBuffer) noexcept {
#if TARGET_IOS
  [commandBuffer presentDrawable:drawable afterMinimumDuration:0.016];  // 16ms
#else
  [commandBuffer presentDrawable:drawable];
#endif

  [commandBuffer commit];
}

void TemplateRenderer::onTouchEvent(mrbp::TouchEvent event) noexcept {}

void TemplateRenderer::onKeyEvent(mrbp::KeyEvent event) noexcept {}

void TemplateRenderer::onEnterForeground() noexcept {}

void TemplateRenderer::onEnterBackground() noexcept {}
