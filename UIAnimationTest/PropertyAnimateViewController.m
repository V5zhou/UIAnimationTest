//
//  PropertyAnimateViewController.m
//  UIAnimationTest
//
//  Created by 多米智投 on 2018/6/5.
//  Copyright © 2018年 zmz. All rights reserved.
//

#import "PropertyAnimateViewController.h"

@interface PropertyAnimateViewController ()

@property (nonatomic, strong) UISlider *slider;

@end

#define viewRead(index) UIView *view = [self.view viewWithTag:kTagstart + index];

@implementation PropertyAnimateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
#define kTagstart 1000
    //创建一组页面
    CGFloat w = kSCREEN_WIDTH/3;
    for (NSInteger i = 0; i < 9; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake((i%3)*w, (i/3)*w + 100, 30, 30)];
        view.backgroundColor = [UIColor lightGrayColor];
        view.tag = i + kTagstart;
        [self.view addSubview:view];
    }
    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(60, 420, kSCREEN_WIDTH - 120, 40)];
    _slider.minimumValue = 0;
    _slider.maximumValue = 1;
    _slider.value = 0.2;
    [_slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_slider];
}

static UIViewPropertyAnimator *weak_animate4 = nil;
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGFloat w = kSCREEN_WIDTH/3;
    //普通动画
    UIViewPropertyAnimator *animate0 = [[UIViewPropertyAnimator alloc] initWithDuration:0.25 curve:UIViewAnimationCurveEaseIn animations:^{
        viewRead(0);
        view.transform = CGAffineTransformMakeTranslation(w/2, 0);
    }];
    [animate0 startAnimation];
    //自定义动画曲线
    UIViewPropertyAnimator *animate1 = [[UIViewPropertyAnimator alloc] initWithDuration:0.25 controlPoint1:CGPointMake(0.3, 0.3) controlPoint2:CGPointMake(-0.3, 1) animations:^{
        viewRead(1);
        view.transform = CGAffineTransformMakeTranslation(w/2, 0);
    }];
    [animate1 startAnimation];
    //阻尼系数:damping
    UIViewPropertyAnimator *animate2 = [[UIViewPropertyAnimator alloc] initWithDuration:0.25 dampingRatio:0.6 animations:^{
        viewRead(2);
        view.transform = CGAffineTransformMakeTranslation(w/2, 0);
    }];
    [animate2 startAnimationAfterDelay:0.25];   //延迟0.25s执行
    //组合动画
    UIViewPropertyAnimator *animate3 = [[UIViewPropertyAnimator alloc] initWithDuration:0.25 curve:UIViewAnimationCurveEaseIn animations:^{
        viewRead(3);
        view.transform = CGAffineTransformMakeTranslation(w/2, 0);
    }];
    [animate3 addAnimations:^{
        viewRead(3);
        view.alpha = 0.2;
    }];
    [animate3 addCompletion:^(UIViewAnimatingPosition finalPosition) {
        NSLog(@"组合动画执行完成");
    }];
    [animate3 startAnimation];
    //动画进度控制
    UIViewPropertyAnimator *animate4 = [[UIViewPropertyAnimator alloc] initWithDuration:0.25 curve:UIViewAnimationCurveEaseIn animations:^{
        viewRead(4);
        view.transform = CGAffineTransformMakeTranslation(w/2, 0);
    }];
    weak_animate4 = animate4;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    weak_animate4 = nil;
}

- (void)sliderChanged:(UISlider *)slider {
    weak_animate4.fractionComplete = slider.value;
}

@end
