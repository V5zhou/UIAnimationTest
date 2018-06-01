//
//  ActionViewController.m
//  UIAnimationTest
//
//  Created by zmz on 2017/8/22.
//  Copyright © 2017年 zmz. All rights reserved.
//

#import "ActionViewController.h"

@interface ActionViewController () <CAAnimationDelegate>

@property (nonatomic, strong) CALayer *testLayer;
@property (nonatomic, strong) CALayer *testLayer1;

@end

@implementation ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.testLayer = [CALayer layer];
    _testLayer.frame = CGRectMake(80, 280, 80, 80);
    _testLayer.backgroundColor = [RGBHEX_(#0083ff) CGColor];
    [self.view.layer addSublayer:_testLayer];
    //add a custom action
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    self.testLayer.actions = @{@"backgroundColor": transition};
    
    //keyFrame动画
    self.testLayer1 = [CALayer layer];
    _testLayer1.frame = CGRectMake(80, 80, 80, 80);
    _testLayer1.backgroundColor = [RGBHEX_(#0083ff) CGColor];
    [self.view.layer addSublayer:_testLayer1];
    [_testLayer1 addAnimation:[self keyFrameAnimation] forKey:@"position"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [UIView beginAnimations:nil context:NULL];
    self.view.layer.backgroundColor = [[UIColor colorWithHex:random()%(256 * 256 * 256) andAlpha:1] CGColor];
    [UIView commitAnimations];
    
    self.testLayer.backgroundColor = [[UIColor colorWithHex:random()%(256 * 256 * 256) andAlpha:1] CGColor];
}

/*
 1.UIView默认关闭了动画
 2.可以通过beginAnimations开启
 3.可以自定义切换动画
 */

- (CAAnimation *)keyFrameAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.values = @[[NSValue valueWithCGPoint:CGPointMake(120, 120)],
                         [NSValue valueWithCGPoint:CGPointMake(180, 120)],
                         [NSValue valueWithCGPoint:CGPointMake(180, 180)],
                         [NSValue valueWithCGPoint:CGPointMake(120, 180)],
                         [NSValue valueWithCGPoint:CGPointMake(120, 120)]];
    animation.repeatCount = 100;
    animation.autoreverses = NO;
    animation.duration = 4.0f;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.delegate = self;
    return animation;
}

@end
