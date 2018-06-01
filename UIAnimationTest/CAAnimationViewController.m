//
//  CAAnimationViewController.m
//  UIAnimationTest
//
//  Created by zmz on 2017/8/22.
//  Copyright © 2017年 zmz. All rights reserved.
//

#import "CAAnimationViewController.h"

@interface CAAnimationViewController () <CAAnimationDelegate>

@property (nonatomic, strong) CALayer *testLayer;

@property (nonatomic, weak)   NSTimer *timer;
@property (nonatomic, strong) CAShapeLayer *clock;
@property (nonatomic, strong) CAShapeLayer *clockH;
@property (nonatomic, strong) CAShapeLayer *clockM;
@property (nonatomic, strong) CAShapeLayer *clockS;

@end

@implementation CAAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.testLayer = [CALayer layer];
    _testLayer.frame = CGRectMake(80, 80, 80, 80);
    _testLayer.backgroundColor = [RGBHEX_(#0083ff) CGColor];
    [self.view.layer addSublayer:_testLayer];
    
    //创建时钟
    self.clock = [CAShapeLayer layer];
    _clock.frame = CGRectMake(20, 200, 300, 300);
    UIBezierPath *clockPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 300, 300)];
    _clock.path = clockPath.CGPath;
    _clock.lineWidth = 1;
    _clock.strokeColor = RGBHEX_(#d6131b).CGColor;
    _clock.fillColor = RGBHEX_(#ffeeee).CGColor;
    [self.view.layer addSublayer:_clock];
    _clock.transform = CATransform3DRotate(CATransform3DIdentity, -M_PI/2, 0, 0, 1);
    
    //时
    self.clockH = [CAShapeLayer layer];
    _clockH.frame = CGRectMake(100, 145, 100, 10);
    _clockH.anchorPoint = CGPointMake(0.1, 0.5);
    UIBezierPath *pathH = [UIBezierPath bezierPathWithArcCenter:CGPointMake(5, 5) radius:5 startAngle:M_PI/2 endAngle:M_PI/2*3 clockwise:YES];
    [pathH addLineToPoint:CGPointMake(100, 5)];
    [pathH addLineToPoint:CGPointMake(5, 10)];
    _clockH.path = pathH.CGPath;
    _clockH.fillColor = RGBHEX_(#224466).CGColor;
    [_clock addSublayer:_clockH];
    
    //分
    self.clockM = [CAShapeLayer layer];
    _clockM.frame = CGRectMake(80, 145, 140, 10);
    _clockM.anchorPoint = CGPointMake(0.1, 0.5);
    UIBezierPath *pathM = [UIBezierPath bezierPath];
    [pathM moveToPoint:CGPointMake(0, 5)];
    [pathM addLineToPoint:CGPointMake(10, 0)];
    [pathM addLineToPoint:CGPointMake(140, 5)];
    [pathM addLineToPoint:CGPointMake(10, 10)];
    [pathM addLineToPoint:CGPointMake(0, 5)];
    _clockM.path = pathM.CGPath;
    _clockM.fillColor = RGBHEX_(#587480).CGColor;
    [_clock addSublayer:_clockM];

    //秒
    self.clockS = [CAShapeLayer layer];
    _clockS.frame = CGRectMake(75, 145, 150, 10);
    _clockS.anchorPoint = CGPointMake(0.15, 0.5);
    UIBezierPath *pathS = [UIBezierPath bezierPathWithArcCenter:CGPointMake(10, 5) radius:3.5 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    [pathS appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(0, 4, 150, 2)]];
    _clockS.path = pathS.CGPath;
    _clockS.fillColor = RGBHEX_(#ff0000).CGColor;
    [_clock addSublayer:_clockS];
    
    //中心点
    CAShapeLayer *pointLayer = [CAShapeLayer layer];
    pointLayer.frame = CGRectMake(150 - 3, 150 - 3, 6, 6);
    pointLayer.backgroundColor = [UIColor colorWithHex:256*256 andAlpha:0.3].CGColor;
    UIBezierPath *pathPoint = [UIBezierPath bezierPathWithArcCenter:CGPointMake(3, 3) radius:3 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    pointLayer.path = pathPoint.CGPath;
    pointLayer.fillColor = RGBHEX_(#f8d83f).CGColor;
    [_clock addSublayer:pointLayer];
    
    //每秒走一下
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger units = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    kWeakSelf
    self.timer = [NSTimer repeatWithInterval:1 block:^(NSTimer *timer) {
        //校正时间
        NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
        CGFloat hourAngle = (components.hour / 12.0) * M_PI * 2.0;
        CGFloat minuteAngle = (components.minute / 60.0) * M_PI * 2.0;
        CGFloat secondAngle = (components.second / 60.0) * M_PI * 2.0;
        [weakSelf updateTimes:hourAngle arngle2:minuteAngle arngle3:secondAngle];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CABasicAnimation *animate = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    animate.toValue = (__bridge id)[[UIColor colorWithHex:random()%(256 * 256 * 256) andAlpha:1] CGColor];
    animate.delegate = self;
    [animate setValue:self.testLayer forKey:@"test"];
    [self.testLayer addAnimation:animate forKey:@"COLOR"];
}

- (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag {
    if ([anim valueForKey:@"myClock"]) {
        CATransform3D transform;
        [(NSValue *)anim.toValue getValue:&transform];
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        ((CALayer *)[anim valueForKey:@"myClock"]).transform = transform;
        [CATransaction commit];
    }
    else if ([anim valueForKey:@"test"]) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        ((CALayer *)[anim valueForKey:@"test"]).backgroundColor = (__bridge CGColorRef _Nullable)(anim.toValue);
        [CATransaction commit];
    }
}

//更新表盘时间
- (void)updateTimes:(CGFloat)angle1 arngle2:(CGFloat)angle2 arngle3:(CGFloat)angle3 {
    [_clockH addAnimation:[self newAnimation:angle1 forLayer:_clockH] forKey:@"HH"];
    [_clockM addAnimation:[self newAnimation:angle2 forLayer:_clockM] forKey:@"MM"];
    [_clockS addAnimation:[self newAnimation:angle3 forLayer:_clockS] forKey:@"SS"];
}

- (CABasicAnimation *)newAnimation:(CGFloat)angle forLayer:(CALayer *)layer {
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform";
    animation.fillMode = kCAFillModeForwards;
    animation.fromValue = [NSValue valueWithCATransform3D:layer.transform];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(angle, 0, 0, 1)];
    animation.duration = 0.2;
    animation.delegate = self;
    [animation setValue:layer forKey:@"myClock"];
    return animation;
}

- (void)dealloc {
    [_timer invalidate];
}

/*
 1.animation.removedOnCompletion = NO时，会导致不释放。
 2.替代方式可以为：在animationDidStop代理中，去静态设置最终toValue。
 */

@end
