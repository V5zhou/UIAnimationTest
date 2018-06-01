//
//  UIImage+category.h
//  UIAnimationTest
//
//  Created by zmz on 2017/8/28.
//  Copyright © 2017年 zmz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (color)

+ (UIImage *)imageWithColor:(UIColor *)aColor;

- (BOOL)hasAlphaChannel;

+ (UIImage *)imageWithSize:(CGSize)size drawBlock:(void (^)(CGContextRef context))drawBlock;

@end
