//
//  FPS.m
//  UIAnimationTest
//
//  Created by zmz on 2017/8/25.
//  Copyright © 2017年 zmz. All rights reserved.
//

#import "FPS.h"

#define FPS_REFRESH_SPEED 1     //本控件一秒刷新N次。
//最终统计得FPS值计算规则：【统计fps * FPS_REFRESH_SPEED】

@interface FPS ()

@property (nonatomic, strong) dispatch_source_t timer;      //每秒执行一次
@property (nonatomic, strong) CADisplayLink *diplaylink;    //计算有效fps
@property (nonatomic, assign) NSInteger fps;                //fps值

@end

@implementation FPS

UIWindow *UIAplicationWindow() {
    return [[UIApplication sharedApplication].delegate window];
}

/**
 显示在屏幕位置
 
 @param position (x, y)
 */
+ (void)showInPosition:(CGPoint)position {
    FPS *fps = [FPS shareInstance];
    fps.frame = CGRectMake(position.x, position.y, 80, 20);
    [UIAplicationWindow() addSubview:fps];
}

/**
 隐藏
 */
+ (void)hidden {
    [[FPS shareInstance] removeFromSuperview];
    FPS *fps = [FPS shareInstance];
    dispatch_source_cancel(fps.timer);
    [fps.diplaylink invalidate];
    fps = nil;  //释放
}

+ (instancetype)shareInstance {
    static FPS *fps = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fps = [[FPS alloc] init];
        [fps initStyle];
        [fps startMonitor];
    });
    return fps;
}

//初始化样式
- (void)initStyle {
    self.backgroundColor = [UIColor lightGrayColor];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowRadius = 4;
    
    self.textColor = [UIColor whiteColor];
    self.textAlignment = NSTextAlignmentCenter;
    self.font = [UIFont boldSystemFontOfSize:10];
}

//开始监控
- (void)startMonitor {
    [self startTimer:1.0f/FPS_REFRESH_SPEED];
    [self startDisplayLink];
}

//刷新界面显示
- (void)refreshFPS {
    NSInteger predictFPS = _fps * FPS_REFRESH_SPEED;
    self.text = [NSString stringWithFormat:@"%03ld", predictFPS];
    switch (predictFPS/10) {
        case 6:
        case 5:
        case 4:
            self.backgroundColor = [UIColor colorWithRed:38/255.0 green:161/255.0 blue:99/255.0 alpha:1];
            break;
        case 3:
        case 2:
            self.backgroundColor = [UIColor colorWithRed:254/255.0 green:205/255.0 blue:82/255.0 alpha:1];
            break;
        case 1:
        case 0: {
            self.backgroundColor = [UIColor colorWithRed:222/255.0 green:83/255.0 blue:75/255.0 alpha:1];
        }break;
            
        default:
            break;
    }
    _fps = 0;
}

- (void)startTimer:(NSTimeInterval)inteval {
    __weak typeof(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_queue_create("uiop", DISPATCH_QUEUE_SERIAL);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, inteval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf refreshFPS];
        });
    });
    dispatch_resume(timer);
    self.timer = timer;
}

- (void)startDisplayLink {
    self.diplaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTrigger)];
    [_diplaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)displayLinkTrigger {
    self.fps++;
}

@end

@interface FPSStackRecoder : NSObject {
    NSInteger blockTime;
    
}

+ (instancetype)create;

@end

@implementation FPSStackRecoder

//+ (instancetype)create {
//    FPSStackRecoder *recorder = [[FPSStackRecoder alloc] init];
//    
//}

@end
