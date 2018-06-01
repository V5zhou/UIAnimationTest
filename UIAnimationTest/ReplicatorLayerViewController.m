//
//  ReplicatorLayerViewController.m
//  UIAnimationTest
//
//  Created by zmz on 2017/9/8.
//  Copyright © 2017年 zmz. All rights reserved.
//

#import "ReplicatorLayerViewController.h"

@interface ReplicatorView : UIView

@end

@implementation ReplicatorView

+ (Class)layerClass {
    return [CAReplicatorLayer class];
}

- (void)setUp {
    //configure replicator
    CAReplicatorLayer *layer = (CAReplicatorLayer *)self.layer;
    layer.instanceCount = 2;
    
    //move reflection instance below original and flip vertically
    CATransform3D transform = CATransform3DIdentity;
    CGFloat verticalOffset = self.bounds.size.height + 2;
    transform = CATransform3DTranslate(transform, 0, verticalOffset, 0);
    transform = CATransform3DScale(transform, 1, -1, 0);
    layer.instanceTransform = transform;
    
    //reduce alpha of reflection layer
    layer.instanceAlphaOffset = -0.6;
    
    CALayer *layer2 = [CALayer layer];
    layer2.frame = self.bounds;
    layer2.contents = (__bridge id _Nullable)([UIImage imageNamed:@"Digits"].CGImage);
    layer2.contentsGravity = kCAGravityResizeAspect;
    [self.layer addSublayer:layer2];
}

- (id)initWithFrame:(CGRect)frame {
    //this is called when view is created in code
    if ((self = [super initWithFrame:frame])) {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

@end

@implementation ReplicatorLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.frame = CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT/2);
    [self.view.layer addSublayer:replicator];
    
    replicator.instanceCount = 10;
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 35, 4, 0);
//    transform = CATransform3DRotate(transform, M_PI / 5, 0, 0, 1);
//    transform = CATransform3DTranslate(transform, 0, -10, 0);
    replicator.instanceTransform = transform;
    
    replicator.instanceGreenOffset = -0.08;
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(10.0f, 50.0f, 50.0f, 50.0f);
    layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    [replicator addSublayer:layer];
    
    //倒影
    ReplicatorView *view = [[ReplicatorView alloc] initWithFrame:CGRectMake(0, kSCREEN_HEIGHT/2, kSCREEN_WIDTH, 50)];
    view.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:view];
}

@end
