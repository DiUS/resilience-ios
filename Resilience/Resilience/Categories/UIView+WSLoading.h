//
//  WSLoading.h
//  WSFoundation
//
//  Created by Ray Hilton on 8/12/11.
//  Copyright (c) 2011 Wirestorm Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WSLoading)
- (void)showLoading;
- (void)hideLoading;
- (void)showLoadingWithText:(NSString*)text;
- (void)hideLoadingWithDelay:(NSTimeInterval)timeInterval;
- (void)showLoadingWithOffset:(CGPoint)offset overlayColour:(UIColor *)colour text:(NSString*)text;
@end