#pragma once

#import <MetalKit/MetalKit.h>

@interface RendererView : MTKView

+ (void)onEnterForeground;
+ (void)onEnterBackground;

@end
