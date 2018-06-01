//
//  PresentationViewController.m
//  UIAnimationTest
//
//  Created by zmz on 2017/8/22.
//  Copyright © 2017年 zmz. All rights reserved.
//

#import "PresentationViewController.h"

@interface PresentationViewController ()

@property (nonatomic, strong) CALayer *testLayer;

@end

@implementation PresentationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.testLayer = [CALayer layer];
    self.testLayer.frame = CGRectMake(0, 0, 100, 100);
    self.testLayer.position = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
    self.testLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:self.testLayer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    if ([self.testLayer.presentationLayer hitTest:touchPoint]) {
        self.testLayer.backgroundColor = [[UIColor colorWithHex:random()%(256 * 256 * 256) andAlpha:1] CGColor];
    }
    else {
        [CATransaction begin];
        [CATransaction setAnimationDuration:4];
        self.testLayer.position = touchPoint;
        [CATransaction commit];
    }
}

@end
