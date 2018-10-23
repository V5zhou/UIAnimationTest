//
//  MagnificateViewController.m
//  UIAnimationTest
//
//  Created by zmz on 2017/9/7.
//  Copyright © 2017年 zmz. All rights reserved.
//

#import "MagnificateViewController.h"

@interface MagnificateViewController ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSMutableArray<CALayer *> *layers;

@end

@implementation MagnificateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.layers = [NSMutableArray array];
    UIImage *image = [UIImage imageNamed:@"Digits"];
    CGFloat W = (kSCREEN_WIDTH - 40)/6;
    for (NSInteger i = 0; i < 6; i++) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(20 + W * i, 200, W, W);
        layer.contents = (__bridge id _Nullable)(image.CGImage);
        layer.contentsGravity = kCAGravityResizeAspectFill;
        layer.contentsRect = CGRectMake(0, 0, 0.1, 1.0);
        layer.magnificationFilter = kCAFilterNearest;   //去除模糊
        [self.view.layer addSublayer:layer];
        [_layers addObject:layer];
    }
    
    //
    kWeakSelf
    self.timer = [NSTimer repeatWithInterval:1 block:^(NSTimer *timer) {
        [weakSelf trigger];
    }];
    [self trigger];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_timer invalidate];
}

- (void)trigger {
    NSUInteger units = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [self.calendar components:units fromDate:[NSDate date]];
    
    //
    [self updateDigit:components.hour / 10 atIndex:0];
    [self updateDigit:components.hour % 10 atIndex:1];
    [self updateDigit:components.minute / 10 atIndex:2];
    [self updateDigit:components.minute % 10 atIndex:3];
    [self updateDigit:components.second / 10 atIndex:4];
    [self updateDigit:components.second % 10 atIndex:5];
}

- (void)updateDigit:(NSUInteger)digit atIndex:(NSInteger)index {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    CALayer *layer = self.layers[index];
    layer.contentsRect = CGRectMake(0.1 * digit, 0, 0.1, 1);
    [CATransaction commit];
}

- (NSCalendar *)calendar {
    if (!_calendar) {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    }
    return _calendar;
}

@end
