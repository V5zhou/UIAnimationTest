//
//  UIViewController+hook.m
//  UIAnimationTest
//
//  Created by zmz on 2017/8/23.
//  Copyright © 2017年 zmz. All rights reserved.
//

#import "UIViewController+hook.h"
#import <objc/runtime.h>

@implementation UIViewController (hook)

+ (void)load {
#if TARGET_IPHONE_SIMULATOR
    Method method1 = class_getInstanceMethod([UIViewController class], @selector(viewDidAppear:));
    class_addMethod([UIViewController class], @selector(hook_viewDidAppear:),
                    method_getImplementation(method1), method_getTypeEncoding(method1));
    method_setImplementation(
                             method1, class_getMethodImplementation([self class], @selector(hook_viewDidAppear:)));
    
    Method method2 =
    class_getInstanceMethod([UIViewController class], NSSelectorFromString(@"dealloc"));
    Method method22 = class_getInstanceMethod([UIViewController class], @selector(hook_dealloc));
    method_exchangeImplementations(method2, method22);
#endif
}

- (void)hook_viewDidAppear:(BOOL)animated {
    if ([self.nextResponder.nextResponder isKindOfClass:NSClassFromString(@"UINavigationTransitionView")]) {
        [self noticeCurruntPageView];
    }
    NSLog(@"%@-%@", [self titleName], [self class]);
}

- (NSString *)titleName {
    NSString *titleName = nil;
    if (self.navigationItem.title.length) {
        titleName = [NSString stringWithFormat:@"%@", self.navigationItem.title];
    }
    else if ([self.navigationItem.titleView isKindOfClass:[UILabel class]]) {
        titleName = [NSString stringWithFormat:@"Custom:%@", ((UILabel *) self.navigationItem.titleView).text];
    }
    return titleName;
}

- (void)hook_dealloc {
    NSLog(@"%@-%@ dealloc", [self titleName], [self class]);
    [self hook_dealloc];
}

#pragma mark - 提示当前页
- (void)noticeCurruntPageView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, kSCREEN_HEIGHT, 0, 0)];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = RGBHEX_(#ff0022);
    label.text = NSStringFromClass([self class]);
    label.layer.borderWidth = 0.5;
    label.layer.borderColor = [RGBHEX_(#ff0022) CGColor];
    label.layer.cornerRadius = 8;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:label];
    
    CGFloat W = [label.text sizeWithAttributes:@{NSFontAttributeName : label.font}].width;
    CGRect targetRect = CGRectMake(15, kSCREEN_HEIGHT - 20, W + 10, 16);
    [UIView animateWithDuration:0.3 animations:^{
        label.frame = targetRect;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:1.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
            label.frame = CGRectMake(0, kSCREEN_HEIGHT, 0, 0);
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}

@end
