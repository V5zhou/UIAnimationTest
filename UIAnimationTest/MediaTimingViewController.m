//
//  MediaTimingViewController.m
//  UIAnimationTest
//
//  Created by zmz on 2017/8/24.
//  Copyright © 2017年 zmz. All rights reserved.
//

#import "MediaTimingViewController.h"

@interface MediaTimingViewController () <CAAnimationDelegate>

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation MediaTimingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.gradientLayer = [CAGradientLayer layer];
    _gradientLayer.frame = CGRectMake(100, 100, 100, 100);
    [self.view.layer addSublayer:_gradientLayer];
    
    _gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor greenColor].CGColor, (__bridge id)[UIColor blueColor].CGColor];
    _gradientLayer.locations = @[@0.0, @0.5, @1.0];
    _gradientLayer.startPoint = CGPointMake(0, 0);
    _gradientLayer.endPoint = CGPointMake(1, 1);
    
    [_gradientLayer addAnimation:[self dropAnimation] forKey:nil];
    
    //底部bezier
    [self drawFiveBezier];
    
    //缓冲
    CAMediaTimingFunction *function = [CAMediaTimingFunction functionWithControlPoints:1 :0 :0.75 :1];
    UIBezierPath *path = [self bezierForMediaTiming:function];
    [path applyTransform:CGAffineTransformMakeScale(100, 100)];
    [self drawBezier:path inRect:CGRectMake(kSCREEN_WIDTH/2 - 50, kSCREEN_HEIGHT - 200, 100, 100)];
}

//绘制5种贝塞尔
- (void)drawFiveBezier {
    NSArray *fiveMediaTiming = @[kCAMediaTimingFunctionLinear,
                                 kCAMediaTimingFunctionEaseIn,
                                 kCAMediaTimingFunctionEaseOut,
                                 kCAMediaTimingFunctionEaseInEaseOut,
                                 kCAMediaTimingFunctionDefault,
                                 ];
    CGFloat space = 10;
    CGFloat W = (kSCREEN_WIDTH - (fiveMediaTiming.count + 1) * space)/fiveMediaTiming.count;
    for (NSInteger i = 0; i < fiveMediaTiming.count; i++) {
        CGRect rect = CGRectMake(space + (space + W) * i, kSCREEN_HEIGHT - W - space, W, W);
        CAMediaTimingFunction *function = [CAMediaTimingFunction functionWithName:fiveMediaTiming[i]];
        UIBezierPath *path = [self bezierForMediaTiming:function];
        [path applyTransform:CGAffineTransformMakeScale(W, W)];
        [self drawBezier:path inRect:rect];
    }
}

//画单个曲线图
- (void)drawBezier:(UIBezierPath *)path inRect:(CGRect)rect {
    CGFloat W = CGRectGetWidth(rect);
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = rect;
    shapeLayer.backgroundColor = [UIColor whiteColor].CGColor;
    shapeLayer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, W, W)].CGPath;
    shapeLayer.shadowColor = [UIColor blackColor].CGColor;
    shapeLayer.shadowOpacity = 0.8;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 4.0f;
    shapeLayer.path = path.CGPath;
    [self.view.layer addSublayer:shapeLayer];
    //flip geometry so that 0,0 is in the bottom-left
    shapeLayer.geometryFlipped = YES;
}

//mediaTiming转化bezier
- (UIBezierPath *)bezierForMediaTiming:(CAMediaTimingFunction *)function {
    float controlPoint1[2], controlPoint2[2];
    [function getControlPointAtIndex:1 values:(float *)&controlPoint1];
    [function getControlPointAtIndex:2 values:(float *)&controlPoint2];
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointZero];
    [path addCurveToPoint:CGPointMake(1, 1) controlPoint1:CGPointMake(controlPoint1[0], controlPoint1[1]) controlPoint2:CGPointMake(controlPoint2[0], controlPoint2[1])];
    return path;
}

#pragma mark - 动画 - 罗伯特·彭纳
//弹性球
float bounceEaseOut(float t)
{
    if (t < 4/11.0) {
        return (121 * t * t)/16.0;
    } else if (t < 8/11.0) {
        return (363/40.0 * t * t) - (99/10.0 * t) + 17/5.0;
    } else if (t < 9/10.0) {
        return (4356/361.0 * t * t) - (35442/1805.0 * t) + 16061/1805.0;
    }
    return (54/5.0 * t * t) - (513/25.0 * t) + 268/25.0;
}

float interpolate(float from, float to, float time)
{
    return (to - from) * time + from;
}

- (CAKeyframeAnimation *)dropAnimation {
    NSValue *fromValue = [NSValue valueWithCGPoint:CGPointMake(150, 150)];
    NSValue *toValue = [NSValue valueWithCGPoint:CGPointMake(150, 350)];
    CFTimeInterval duration = 2.0;
    NSInteger numFrames = duration * 160;
    NSMutableArray *frames = [NSMutableArray array];
    for (int i = 0; i < numFrames; i++) {
        @autoreleasepool {
            float time = 1/(float)numFrames * (i + 1);
            time = bounceEaseOut(time);
            [frames addObject:[self interpolateFromValue:fromValue toValue:toValue time:time]];
        }
    }
    //create keyframe animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = duration;
    animation.delegate = self;
    animation.values = frames;
    return animation;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        if ([anim isKindOfClass:[CAKeyframeAnimation class]]) {
            CAKeyframeAnimation *animate = (CAKeyframeAnimation *)anim;
            NSValue *lastPosition = [animate.values lastObject];
            CGPoint point;
            [lastPosition getValue:&point];
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            _gradientLayer.position = point;
            [CATransaction commit];
        }
    }
}

- (id)interpolateFromValue:(id)fromValue toValue:(id)toValue time:(float)time
{
    if ([fromValue isKindOfClass:[NSValue class]]) {
        //get type
        const char *type = [fromValue objCType];
        if (strcmp(type, @encode(CGPoint)) == 0) {
            CGPoint from = [fromValue CGPointValue];
            CGPoint to = [toValue CGPointValue];
            CGPoint result = CGPointMake(interpolate(from.x, to.x, time), interpolate(from.y, to.y, time));
            return [NSValue valueWithCGPoint:result];
        }
    }
    //provide safe default implementation
    return (time < 0.5)? fromValue: toValue;
}

@end
