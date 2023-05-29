#import "LaunchParams.h"

#include "../interface/mrbp/MetalRenderer.hpp"

@implementation LaunchParams

+ (CGSize)viewportSize {
  auto const sz = getLaunchParams().desiredViewportSize;
  return CGSize{static_cast<float>(sz.x), static_cast<float>(sz.y)};
}

+ (NSString * _Nonnull)windowTitle {
  return @(getLaunchParams().windowTitle.c_str());
}

+ (BOOL)closeAppWithClosingWindow {
  return getLaunchParams().closeAppWithClosingWindow;
}

@end
