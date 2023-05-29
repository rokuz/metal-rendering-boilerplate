#pragma once

#import <Foundation/Foundation.h>

@interface LaunchParams : NSObject

+ (CGSize)viewportSize;
+ (NSString * _Nonnull)windowTitle;
+ (BOOL)closeAppWithClosingWindow;

@end
