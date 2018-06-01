//
//  AVPlayerLayerViewController.m
//  UIAnimationTest
//
//  Created by zmz on 2017/9/13.
//  Copyright © 2017年 zmz. All rights reserved.
//

#import "AVPlayerLayerViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface AVPlayerLayerViewController ()

@end

@implementation AVPlayerLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    NSURL *URL = [[NSBundle mainBundle] URLForResource:@"loginmovie" withExtension:@"mp4"];
    AVPlayer *player = [[AVPlayer alloc] initWithURL:URL];
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
    CGSize videoSize = [self getsVideoSize:URL];
    layer.frame = CGRectMake((kSCREEN_WIDTH - videoSize.width)/2, (kSCREEN_HEIGHT - 64 - videoSize.height)/2, videoSize.width, videoSize.height);
    [self.view.layer addSublayer:layer];
    
    //
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0 / 500.0;
    transform = CATransform3DRotate(transform, M_PI_4, 1, 1, 0);
    layer.transform = transform;
    
    layer.masksToBounds = YES;
    layer.cornerRadius = 20.0;
    layer.borderColor = [UIColor redColor].CGColor;
    layer.borderWidth = 5.0;
    
    [player play];
}

- (CGSize)getsVideoSize:(NSURL *)videoURl {
    AVAsset *asset = [AVAsset assetWithURL:videoURl];
    for (AVAssetTrack *track in asset.tracks) {
        if ([track.mediaType isEqualToString:AVMediaTypeVideo]) {
            return track.naturalSize;
        }
    }
    return CGSizeZero;
}

@end
