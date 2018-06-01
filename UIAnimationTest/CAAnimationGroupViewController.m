//
//  CAAnimationGroupViewController.m
//  UIAnimationTest
//
//  Created by zmz on 2017/8/22.
//  Copyright © 2017年 zmz. All rights reserved.
//

#import "CAAnimationGroupViewController.h"

@interface CAAnimationGroupViewController ()

@property (nonatomic, strong) CALayer *testLayer;

@end

@implementation CAAnimationGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.testLayer = [CALayer layer];
    _testLayer.frame = CGRectMake(80, 80, 80, 80);
    _testLayer.backgroundColor = [RGBHEX_(#0083ff) CGColor];
    [self.view.layer addSublayer:_testLayer];
    
    //
    UIBezierPath *keyPath = [UIBezierPath bezierPath];
    [keyPath moveToPoint:CGPointMake(120, 120)];
    [keyPath addCurveToPoint:CGPointMake(300, 400) controlPoint1:CGPointMake(80, 200) controlPoint2:CGPointMake(280, 200)];
    
    //画线
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = keyPath.CGPath;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.lineWidth = 2.0f;
    [self.view.layer addSublayer:pathLayer];
    
    //颜色
    CABasicAnimation *animate_color = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    animate_color.toValue = (__bridge id _Nullable)(RGBHEX_(#ff0028).CGColor);
    //位置
    CAKeyframeAnimation *animate_frame = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animate_frame.path = keyPath.CGPath;
    animate_frame.rotationMode = kCAAnimationRotateAuto;
    
    //组合
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[animate_color, animate_frame];
    group.duration = 3;
    group.autoreverses = YES;
    group.repeatCount = HUGE_VAL;
    [_testLayer addAnimation:group forKey:@"color_frame"];
}



@end
