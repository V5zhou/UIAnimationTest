//
//  StopAnimationViewController.m
//  UIAnimationTest
//
//  Created by zmz on 2017/8/23.
//  Copyright © 2017年 zmz. All rights reserved.
//

#import "StopAnimationViewController.h"

@interface StopAnimationViewController () <CAAnimationDelegate>

@property (nonatomic, strong) CALayer *testLayer;

@end

@implementation StopAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.testLayer = [CALayer layer];
    _testLayer.frame = CGRectMake(80, 80, 80, 80);
    _testLayer.backgroundColor = [RGBHEX_(#0083ff) CGColor];
    [self.view.layer addSublayer:_testLayer];
    
    //
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = RGBHEX_(#7d7d7d);
    button.layer.cornerRadius = 3;
    button.frame = CGRectMake(40, 180, 80, 30);
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitle:@"开始" forState:UIControlStateNormal];
    [button setTitle:@"停止" forState:UIControlStateSelected];
    kWeakSelf
    [button setsAction:^(UIButton *button) {
        button.selected = !button.selected;
        if (button.selected) {
            [weakSelf.testLayer addAnimation:[weakSelf keyFrameAnimation] forKey:@"position"];
        }
        else {
            [weakSelf.testLayer removeAnimationForKey:@"position"];
        }
    }];
    [self.view addSubview:button];
}

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
    animation.removedOnCompletion = NO;
    animation.delegate = self;
    return animation;
}

- (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag {
    if ([anim.keyPath isEqualToString:@"position"]) {
        CGPoint position = self.testLayer.presentationLayer.position;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        _testLayer.position = position;
        [CATransaction commit];
    }
}

/*
 1.取消动画就用removeAnimationForKey
 2.移除动画后，会立即显示在动画前位置，有没有办法留在keyFrame动画停止时位置？？？有待发现
 3.貌似可以用layer.speed=0 layer.timeOffset=xxx来手动控制进度，把时间放进CADisplayLink来手动控制。
 4.验证了下，果然可以！！！！！！！
 */

@end
