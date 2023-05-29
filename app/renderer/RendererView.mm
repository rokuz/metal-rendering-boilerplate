#import "RendererView.h"

#include <algorithm>

#include "../interface/mrbp/MetalRenderer.hpp"
#import "RendererViewDelegate.h"

@interface RendererView ()

@property(nonatomic) MTLPixelFormat pixelFormat;
@property(nonatomic) BOOL emulateMultiTouch;
@property(nonatomic) BOOL needGenerateSecondTouch;
@end

@implementation RendererView

- (id)init {
  self = [super init];
  if (self) {
    self.device = RendererViewDelegate.sharedDelegate.metalDevice;
    self.delegate = RendererViewDelegate.sharedDelegate;

    auto launchParams = getLaunchParams();
    self.colorPixelFormat =
      launchParams.useGammaCorrection ? MTLPixelFormatBGRA8Unorm_sRGB : MTLPixelFormatBGRA8Unorm;
    self.depthStencilPixelFormat = launchParams.depthStencilPixelFormat;

#if !(TARGET_IOS || TARGET_OS_SIMULATOR)
    CAMetalLayer * layer = static_cast<CAMetalLayer *>(self.layer);
    layer.displaySyncEnabled = launchParams.enableVerticalSync;
#endif

    self.emulateMultiTouch = launchParams.emulateMultiTouch;
    self.needGenerateSecondTouch = NO;
  }
  return self;
}

+ (void)onEnterForeground {
  [RendererViewDelegate.sharedDelegate onEnterForeground];
}

+ (void)onEnterBackground {
  [RendererViewDelegate.sharedDelegate onEnterBackground];
}

#if TARGET_IOS || TARGET_OS_SIMULATOR

- (mrbp::TouchEvent)buildTouchEvent:(UIEvent *)event withType:(mrbp::TouchType)type {
  mrbp::TouchEvent e{.type = type};

  uint32_t index = 0;
  float const scaleFactor = self.contentScaleFactor;
  NSArray * allTouches = [[event allTouches] allObjects];
  for (UITouch * touch in allTouches) {
    if (index >= e.touches.size()) break;
    CGPoint pt = [touch locationInView:self];
    e.touches[index++] = glm::vec2{pt.x * scaleFactor, pt.y * scaleFactor};
  }
  return e;
}

- (void)touchesBegin:(NSSet *)touches withEvent:(UIEvent *)event {
  [RendererViewDelegate.sharedDelegate onTouchEvent:[self buildTouchEvent:event
                                                                 withType:mrbp::TouchType::Down]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  [RendererViewDelegate.sharedDelegate onTouchEvent:[self buildTouchEvent:event
                                                                 withType:mrbp::TouchType::Move]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [RendererViewDelegate.sharedDelegate onTouchEvent:[self buildTouchEvent:event
                                                                 withType:mrbp::TouchType::Up]];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  [RendererViewDelegate.sharedDelegate onTouchEvent:[self buildTouchEvent:event
                                                                 withType:mrbp::TouchType::Cancel]];
}

#else

- (mrbp::TouchEvent)buildTouchEvent:(NSEvent *)event
                           withType:(mrbp::TouchType)type
                    withSecondTouch:(BOOL)secondTouch {
  mrbp::TouchEvent e{.type = type};

  CGSize viewportSize = RendererViewDelegate.sharedDelegate.viewportSize;
  float const scaleFactor = self.window.backingScaleFactor;
  CGPoint pt = [event locationInWindow];

  e.touches[0] = glm::vec2{
    std::min(std::max(pt.x * scaleFactor, 0.0), viewportSize.width),
    viewportSize.height - std::min(std::max(pt.y * scaleFactor, 0.0), viewportSize.height)};
  if (secondTouch) {
    e.touches[1] = glm::vec2{viewportSize.width, viewportSize.height} - e.touches[0].value();
  }

  return e;
}

- (void)mouseDown:(NSEvent *)event {
  [RendererViewDelegate.sharedDelegate
    onTouchEvent:[self buildTouchEvent:event
                              withType:mrbp::TouchType::Down
                       withSecondTouch:self.needGenerateSecondTouch]];
}

- (void)mouseDragged:(NSEvent *)event {
  [RendererViewDelegate.sharedDelegate
    onTouchEvent:[self buildTouchEvent:event
                              withType:mrbp::TouchType::Move
                       withSecondTouch:self.needGenerateSecondTouch]];
}

- (void)mouseUp:(NSEvent *)event {
  [RendererViewDelegate.sharedDelegate
    onTouchEvent:[self buildTouchEvent:event
                              withType:mrbp::TouchType::Up
                       withSecondTouch:self.needGenerateSecondTouch]];
}

- (BOOL)acceptsFirstResponder {
  return YES;
}

- (void)flagsChanged:(NSEvent *)event {
  if (self.emulateMultiTouch && (event.modifierFlags & NSEventModifierFlagOption)) {
    self.needGenerateSecondTouch = YES;
  } else {
    self.needGenerateSecondTouch = NO;
  }
}

- (void)keyDown:(NSEvent *)event {
  [RendererViewDelegate.sharedDelegate
    onKeyEvent:mrbp::KeyEvent{.type = mrbp::KeyType::Down,
                              .code = static_cast<mrbp::KeyCode>(event.keyCode)}];
}

- (void)keyUp:(NSEvent *)event {
  [RendererViewDelegate.sharedDelegate
    onKeyEvent:mrbp::KeyEvent{.type = mrbp::KeyType::Up,
                              .code = static_cast<mrbp::KeyCode>(event.keyCode)}];
}

#endif

@end
