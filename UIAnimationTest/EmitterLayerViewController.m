//
//  EmitterLayerViewController.m
//  UIAnimationTest
//
//  Created by zmz on 2017/9/13.
//  Copyright © 2017年 zmz. All rights reserved.
//

#import "EmitterLayerViewController.h"

@interface EmitterLayerViewController ()

@end

@implementation EmitterLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    emitter.frame = CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64);
    [self.view.layer addSublayer:emitter];
    
    //配置
    emitter.renderMode = kCAEmitterLayerAdditive;
    emitter.emitterPosition = CGPointMake(emitter.frame.size.width / 2.0, emitter.frame.size.height / 2.0);
    
    //粒子
    CAEmitterCell *cell = [[CAEmitterCell alloc] init];
    cell.contents = (__bridge id)[UIImage imageNamed:@"粒子.png"].CGImage;
    cell.birthRate = 150;
    cell.lifetime = 5.0;
    cell.color = [UIColor colorWithRed:1 green:0.5 blue:0.1 alpha:1.0].CGColor;
    cell.alphaSpeed = -0.4;
    cell.velocity = 50;
    cell.velocityRange = 50;
    cell.emissionRange = M_PI * 2.0;
    
    //add particle template to emitter
    emitter.emitterCells = @[cell];
}

/*
 CAEMitterCell的属性基本上可以分为三种：
 这种粒子的某一属性的初始值。比如，color属性指定了一个可以混合图片内容颜色的混合色。在示例中，我们将它设置为桔色。
 例子某一属性的变化范围。比如emissionRange属性的值是2π，这意味着例子可以从360度任意位置反射出来。如果指定一个小一些的值，就可以创造出一个圆锥形
 指定值在时间线上的变化。比如，在示例中，我们将alphaSpeed设置为-0.4，就是说例子的透明度每过一秒就是减少0.4，这样就有发射出去之后逐渐小时的效果。
 */

@end
