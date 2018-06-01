//
//  TransitionViewController.m
//  UIAnimationTest
//
//  Created by zmz on 2017/8/23.
//  Copyright © 2017年 zmz. All rights reserved.
//

#import "TransitionViewController.h"

@interface TransitionViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *imageView1;

@end

@implementation TransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 80, 80, 80)];
    _imageView.image = [UIImage imageNamed:@"1"];
    [self.view addSubview:_imageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = RGBHEX_(#7d7d7d);
    button.layer.cornerRadius = 3;
    button.frame = CGRectMake(40, 180, 80, 30);
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    [button setTitle:@"CATransition" forState:UIControlStateNormal];
    kWeakSelf
    [button setsAction:^(UIButton *button) {
        CATransition *transition = [CATransition animation];
        transition.duration = 1.5;
        transition.type = kCATransitionFade;
//        transition.subtype = kCATransitionFromRight;    //subtype控制方向
        [weakSelf.imageView.layer addAnimation:transition forKey:nil];
        
        NSInteger index = arc4random()%10 + 1;
        weakSelf.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld", index]];
    }];
    [self.view addSubview:button];
    
#pragma mark - UIView添加动画
    self.imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(140, 80, 80, 80)];
    _imageView1.image = [UIImage imageNamed:@"1"];
    [self.view addSubview:_imageView1];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.backgroundColor = RGBHEX_(#7d7d7d);
    button1.layer.cornerRadius = 3;
    button1.frame = CGRectMake(140, 180, 80, 30);
    button1.titleLabel.adjustsFontSizeToFitWidth = YES;
    [button1 setTitle:@"transitionWithView" forState:UIControlStateNormal];
    [button1 setsAction:^(UIButton *button) {
        [UIView transitionWithView:weakSelf.imageView1 duration:2 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            NSInteger index = arc4random()%10 + 1;
            weakSelf.imageView1.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld", index]];
        } completion:nil];
    }];
    [self.view addSubview:button1];
}

/*
 1.CATransition 
 type:
 kCATransitionFade
 kCATransitionMoveIn 
 kCATransitionPush 
 kCATransitionReveal
 
 subType:
 kCATransitionFromRight 
 kCATransitionFromLeft 
 kCATransitionFromTop 
 kCATransitionFromBottom
 
 2.[UIView transitionWithView...]
 options:
 UIViewAnimationOptionTransitionFlipFromLeft
 UIViewAnimationOptionTransitionCurlUp
 UIViewAnimationOptionTransitionCrossDissolve
 UIViewAnimationOptionTransitionFlipFromTop
 */

@end
