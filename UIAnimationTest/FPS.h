//
//  FPS.h
//  UIAnimationTest
//
//  Created by zmz on 2017/8/25.
//  Copyright © 2017年 zmz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FPS : UILabel


/**
 显示在屏幕位置

 @param position (x, y)
 */
+ (void)showInPosition:(CGPoint)position;


/**
 隐藏
 */
+ (void)hidden;

@end
