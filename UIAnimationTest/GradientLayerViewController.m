//
//  GradientLayerViewController.m
//  UIAnimationTest
//
//  Created by zmz on 2017/9/8.
//  Copyright © 2017年 zmz. All rights reserved.
//

#import "GradientLayerViewController.h"

@interface GradientLayerViewController ()

@end

@implementation GradientLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(100, 100, 100, 100);
    [self.view.layer addSublayer:gradientLayer];
    
    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor greenColor].CGColor, (__bridge id)[UIColor blueColor].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    gradientLayer.locations = @[@0.1, @0.5, @0.8];
}



@end
