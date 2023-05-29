#pragma once

#import <MetalKit/MetalKit.h>

#include "../interface/mrbp/Input.hpp"

@interface RendererViewDelegate : NSObject <MTKViewDelegate>

+ (instancetype)sharedDelegate;
@property(nonatomic, strong) id<MTLDevice> metalDevice;
@property(nonatomic) CGSize viewportSize;

- (void)onTouchEvent:(mrbp::TouchEvent)event;
- (void)onKeyEvent:(mrbp::KeyEvent)event;

- (void)onEnterForeground;
- (void)onEnterBackground;

@end
