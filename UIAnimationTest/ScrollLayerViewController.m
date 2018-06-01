//
//  ScrollLayerViewController.m
//  UIAnimationTest
//
//  Created by zmz on 2017/9/12.
//  Copyright © 2017年 zmz. All rights reserved.
//

#import "ScrollLayerViewController.h"

@interface ScrollLayerViewController () {
    UIImage *sourceImage;       ///< 原图
    CGSize sourceResolution;    ///< 原图分辨率
    float sourceTotalPixels;    ///< 原图总像素
    float sourceTotalMB;        ///< 原图占几M
    
    //压缩相关
    float imageScale;           ///< 缩放系数 dest/source
    CGSize destResolution;      ///< 缩放后分辨率
    
    //输出画板
    CGContextRef destContext;   ///< 输出上下文
    
    UIImageView *imageView;
}

@end

#define bytesPerMB 1048576.0f   ///< 一兆大小-->1024*1024
#define bytesPerPixel 4.0f      ///< 一像素4byte
#define pixelsPerMB ( bytesPerMB / bytesPerPixel )  ///< 每兆能存多少像素

//压缩相关
#define kDestImageSizeMB 60.0f          ///< 压缩后大小
#define destTotalPixels kDestImageSizeMB * pixelsPerMB  ///< 压缩后像素

//切割相关
#define kSourceImageTileSizeMB 20.0f    ///< 切割每个小图片大小
#define destOverlap 2.0f                ///< 额外每个图片多切高两像素，防止拼合时出现裂缝。

@implementation ScrollLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self downSize];
    });
}

- (void)downSize {
    sourceImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"large_leaves_70mp.jpg" ofType:nil]];
    if (!sourceImage) {
        NSLog(@"指定路径下，图片未找到");
    }
    //原图分辨率
    sourceResolution = sourceImage.size;
    //原图总像素
    sourceTotalPixels = sourceResolution.width * sourceResolution.height;
    //原图大小几M
    sourceTotalMB = sourceTotalPixels/pixelsPerMB;
    
    //缩放比例
    imageScale = destTotalPixels/sourceTotalPixels;
    //缩放后分辨率
    destResolution = CGSizeMake((int)(sourceResolution.width*imageScale), (int)(sourceResolution.height*imageScale));
    
    //创立一个画板
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    destContext = CGBitmapContextCreate(NULL,
                                        destResolution.width,
                                        destResolution.height,
                                        8,
                                        bytesPerPixel * destResolution.width,
                                        colorSpace,
                                        kCGImageAlphaPremultipliedLast);
    //注意：CGBitmapContextCreate里1234参数为size_t，不能为小数，否则会创建失败
    if( destContext == NULL ) {
        NSLog(@"bitmap创建失败!");
        return;
    }
    CGColorSpaceRelease( colorSpace );
    
    //图片切割
    int sourceOverlap = (int)(destOverlap / imageScale);   //原图多切高N行
    CGFloat sourceTileHeight = (int)(kSourceImageTileSizeMB/sourceTotalMB*sourceResolution.height);
    CGRect sourceTile = CGRectMake(0, 0, sourceResolution.width, sourceTileHeight + sourceOverlap);
    CGRect destTile = CGRectMake(0, 0, destResolution.width, (sourceTileHeight + sourceOverlap) * imageScale);
    
    //切成几块
    int iterations = (int)( sourceResolution.height / sourceTileHeight );
    int remainder = (int)sourceResolution.height % (int)sourceTileHeight;
    if (remainder > 0) {
        iterations += 1;
    }
    
    for (int i = 0; i < iterations; i++) {
        sourceTile.origin.y = i * sourceTileHeight;
        destTile.origin.y = (iterations - 1 - i) * sourceTileHeight *imageScale - (1 - remainder/sourceTileHeight)*imageScale;
        //原图切图
        CGImageRef sourceTileImageRef = CGImageCreateWithImageInRect( sourceImage.CGImage, sourceTile );
        //画到目标画布上
        CGContextDrawImage( destContext, destTile, sourceTileImageRef );
        CGImageRelease( sourceTileImageRef );
        
        //刷新显示
        if (i < iterations) {
            CGImageRef destImageRef = CGBitmapContextCreateImage( destContext );
            UIImage *image = [UIImage imageWithCGImage:destImageRef scale:1.0f orientation:UIImageOrientationUp];
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = image;
            });
            CGImageRelease(destImageRef);
        }
    }
    CGContextRelease( destContext );
}

@end
