//
//  ViewController.m
//  UIAnimationTest
//
//  Created by zmz on 2017/8/22.
//  Copyright © 2017年 zmz. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *dataArray;

@end

typedef NS_ENUM(NSUInteger, PushFunction) {
    PushFunction_TextLayer,           ///< 文本Layer
    PushFunction_TransformLayer,      ///< 整体变换Layer
    PushFunction_GradientLayer,       ///< 渐变Layer
    PushFunction_ReplicatorLayer,     ///< 重复Layer
    PushFunction_ScrollLayer,         ///< 滚动Layer
    PushFunction_EmitterLayer,        ///< 粒子Layer
    PushFunction_EAGLLayer,           ///< OpenGL型Layer
    PushFunction_AVPlayerLayer,       ///< AVPlayer
    
    PushFunction_Transaction,   ///< 事务
    PushFunction_Action,        ///< 图层行为
    PushFunction_Presentation,  ///< 呈现图层
    PushFunction_HitTest,       ///< 点击事件
    
    PushFunction_CAAnimation,           ///< 属性动画
    PushFunction_CAAnimationGroup,      ///< 组动画
    PushFunction_Transition,            ///< 过渡动画
    PushFunction_StopAnimation,         ///< 停止进行中动画
    
    PushFunction_ManualAnimation,       ///< 手动动画
    PushFunction_MediaTiming,           ///< 缓冲
    
    PushFunction_Magnificate,           ///< 拉伸过滤
};

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleArray = @[@"各种layer", @"隐式动画", @"显式动画", @"手动与缓冲", @"其它"];
    self.dataArray = @[@[
                           @(PushFunction_TextLayer),
                           @(PushFunction_TransformLayer),
                           @(PushFunction_GradientLayer),
                           @(PushFunction_ReplicatorLayer),
                           @(PushFunction_ScrollLayer),
                           @(PushFunction_EmitterLayer),
                           @(PushFunction_EAGLLayer),
                           @(PushFunction_AVPlayerLayer),
                           ],
                       @[
                           @(PushFunction_Transaction),
                           @(PushFunction_Action),
                           @(PushFunction_Presentation),
                           @(PushFunction_HitTest),
                           ],
                       @[
                           @(PushFunction_CAAnimation),
                           @(PushFunction_CAAnimationGroup),
                           @(PushFunction_Transition),
                           @(PushFunction_StopAnimation),
                           ],
                       @[
                           @(PushFunction_ManualAnimation),
                           @(PushFunction_MediaTiming),
                           ],
                       @[
                           @(PushFunction_Magnificate),
                           ]
                       ];
    [self.tableView reloadData];
}

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath {
    PushFunction type = [_dataArray[indexPath.section][indexPath.row] integerValue];
    switch (type) {
        case PushFunction_TextLayer:
            return @"文本layer";
            break;
        case PushFunction_TransformLayer:
            return @"整体变换layer";
            break;
        case PushFunction_GradientLayer:
            return @"渐变Layer";
            break;
        case PushFunction_ReplicatorLayer:
            return @"重复Layer";
            break;
        case PushFunction_ScrollLayer:
            return @"滚动Layer";
            break;
        case PushFunction_EmitterLayer:
            return @"粒子Layer";
            break;
        case PushFunction_EAGLLayer:
            return @"OpenGL型Layer";
            break;
        case PushFunction_AVPlayerLayer:
            return @"AVPlayer";
            break;
            
        case PushFunction_Transaction:
            return @"事务";
            break;
        case PushFunction_Action:
            return @"图层行为";
            break;
        case PushFunction_Presentation:
            return @"呈现图层";
            break;
        case PushFunction_HitTest:
            return @"点击事件";
            break;
        case PushFunction_CAAnimation:
            return @"属性动画";
            break;
        case PushFunction_CAAnimationGroup:
            return @"组动画";
            break;
        case PushFunction_Transition:
            return @"过渡动画";
            break;
        case PushFunction_StopAnimation:
            return @"停止进行中动画";
            break;
        case PushFunction_ManualAnimation:
            return @"手动动画";
            break;
        case PushFunction_MediaTiming:
            return @"动画缓冲";
            break;
        case PushFunction_Magnificate:
            return @"拉伸过滤";
            break;
            
        default:
            break;
    }
    return @"--";
}

- (Class)classForType:(PushFunction)type {
    Class cls = nil;
    switch (type) {
        case PushFunction_TextLayer:          //文本layer
            cls = NSClassFromString(@"TextLayerViewController");
            break;
        case PushFunction_TransformLayer:          //变换layer
            cls = NSClassFromString(@"TransformLayerViewController");
            break;
        case PushFunction_GradientLayer:          //渐变layer
            cls = NSClassFromString(@"GradientLayerViewController");
            break;
        case PushFunction_ReplicatorLayer:          //重复layer
            cls = NSClassFromString(@"ReplicatorLayerViewController");
            break;
        case PushFunction_ScrollLayer:          //滚动layer
            cls = NSClassFromString(@"ScrollLayerViewController");
            break;
        case PushFunction_EmitterLayer:          //粒子layer
            cls = NSClassFromString(@"EmitterLayerViewController");
            break;
        case PushFunction_EAGLLayer:          //OpenGL型Layer
            cls = NSClassFromString(@"EAGLLayerViewController");
            break;
        case PushFunction_AVPlayerLayer:          //AVPlayer
            cls = NSClassFromString(@"AVPlayerLayerViewController");
            break;
            
        case PushFunction_Transaction:  //@"事务";
            cls = NSClassFromString(@"TransactionViewController");
            break;
        case PushFunction_Action:       //@"图层行为";
            cls = NSClassFromString(@"ActionViewController");
            break;
        case PushFunction_Presentation:   //@"呈现图层";
            cls = NSClassFromString(@"PresentationViewController");
            break;
        case PushFunction_HitTest:   //@"点击事件";
            cls = NSClassFromString(@"CustomTabBarController");
            break;
        case PushFunction_CAAnimation:   //@"属性动画";
            cls = NSClassFromString(@"CAAnimationViewController");
            break;
        case PushFunction_CAAnimationGroup:   //@"组动画";
            cls = NSClassFromString(@"CAAnimationGroupViewController");
            break;
        case PushFunction_Transition:       //过渡动画
            cls = NSClassFromString(@"TransitionViewController");
            break;
        case PushFunction_StopAnimation:    //停止进行中动画
            cls = NSClassFromString(@"StopAnimationViewController");
            break;
        case PushFunction_ManualAnimation:      //手动动画
            cls = NSClassFromString(@"ManualAnimationViewController");
            break;
        case PushFunction_MediaTiming:          //动画缓冲
            cls = NSClassFromString(@"MediaTimingViewController");
            break;
        case PushFunction_Magnificate:          //拉伸过滤
            cls = NSClassFromString(@"MagnificateViewController");
            break;
            
        default:
            break;
    }
    return cls;
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    view.backgroundColor = RGBHEX_(#f2f3f4);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kSCREEN_WIDTH - 30, 30)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = RGBHEX_(#008312);
    label.text = _titleArray[section];
    [view addSubview:label];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"test"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test"];
    }
    cell.textLabel.text = [self titleForIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    PushFunction type = [_dataArray[indexPath.section][indexPath.row] integerValue];
    Class cls = [self classForType:type];
    UIViewController *ctl = [[cls alloc] init];
    ctl.view.backgroundColor = [UIColor whiteColor];
    ctl.title = [self titleForIndexPath:indexPath];
    [self.navigationController pushViewController:ctl animated:YES];
}

@end
