#pragma once

#import <Metal/Metal.h>

#include <glm/glm.hpp>
#include <string>

namespace mrbp {

struct LaunchParams {
  // [Only MacOS] OS will try to create a viewport of this size,
  // but it's not guaranteed.
  glm::uvec2 desiredViewportSize{1600, 1200};

  // [Only MacOS] Window title.
  std::string windowTitle = "Metal Rendering Boilerplate Window";

  // [Only MacOS] The app will by closed when the window is closed.
  bool closeAppWithClosingWindow = true;

  // Enables output format with gamma correction (sRGB).
  bool useGammaCorrection = true;

  // Depth-stencil format (turned off by default).
  MTLPixelFormat depthStencilPixelFormat = MTLPixelFormatInvalid;

  // [Only MacOS] Enable vertical synchronization.
  bool enableVerticalSync = true;

  // [Only MacOS] The app will emulate multi-touch behaviour on MacOS.
  // It generates the second touch symmetrically center of the viewport on
  // Option(⌥) holding.
  bool emulateMultiTouch = true;
};

}  // namespace mrbp
