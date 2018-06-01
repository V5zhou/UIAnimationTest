//
//  TransactionViewController.m
//  UIAnimationTest
//
//  Created by zmz on 2017/8/22.
//  Copyright © 2017年 zmz. All rights reserved.
//

#import "TransactionViewController.h"

@interface TransactionViewController ()

@property (nonatomic, strong) CALayer *testLayer;

@end

@implementation TransactionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.testLayer = [CALayer layer];
    _testLayer.frame = CGRectMake(80, 80, 80, 80);
    _testLayer.backgroundColor = [RGBHEX_(#0083ff) CGColor];
    [self.view.layer addSublayer:_testLayer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [CATransaction begin];
    [CATransaction setAnimationDuration:2];
    _testLayer.backgroundColor = [[UIColor colorWithHex:random()%(256 * 256 * 256) andAlpha:1] CGColor];
    [CATransaction setCompletionBlock:^{
        [CATransaction begin];
        [CATransaction setAnimationDuration:2];
        CGAffineTransform transform = self.testLayer.affineTransform;
        transform = CGAffineTransformRotate(transform, M_PI_2);
        self.testLayer.affineTransform = transform;
        [CATransaction commit];
    }];
    [CATransaction commit];
}

/*
 1.默认CALayer自带动画。
 2.也可通过[CATransaction begin]开启动画，设置时间。
 3.擦，setCompletionBlock根本不等动画完成就执行了。是不是写的有问题？待验证
 */

@end
