//
//  TransformLayerViewController.m
//  UIAnimationTest
//
//  Created by zmz on 2017/9/8.
//  Copyright © 2017年 zmz. All rights reserved.
//

#import "TransformLayerViewController.h"

@interface TransformLayerViewController ()

@end

@implementation TransformLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    CATransform3D pt = CATransform3DIdentity;
    pt.m34 = -1.0 / 500.0;
    self.view.layer.sublayerTransform = pt;
    
    CATransform3D c1t = CATransform3DIdentity;
    c1t = CATransform3DTranslate(c1t, -100, 0, 0);
    CALayer *cube1 = [self cubeWithTransform:c1t];
    [self.view.layer addSublayer:cube1];
    
    CATransform3D c2t = CATransform3DIdentity;
    c2t = CATransform3DTranslate(c2t, 100, 0, 0);
    c2t = CATransform3DRotate(c2t, -M_PI_4, 1, 0, 0);
    c2t = CATransform3DRotate(c2t, -M_PI_4, 0, 1, 0);
    CALayer *cube2 = [self cubeWithTransform:c2t];
    [self.view.layer addSublayer:cube2];
}

- (CALayer *)cubeWithTransform:(CATransform3D)transform
{
    //create cube layer
    CATransformLayer *cube = [CATransformLayer layer];
    
    //add cube face 1
    CATransform3D ct = CATransform3DMakeTranslation(0, 0, 50);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    //add cube face 2
    ct = CATransform3DMakeTranslation(50, 0, 0);
    ct = CATransform3DRotate(ct, M_PI_2, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    //add cube face 3
    ct = CATransform3DMakeTranslation(0, -50, 0);
    ct = CATransform3DRotate(ct, M_PI_2, 1, 0, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    //add cube face 4
    ct = CATransform3DMakeTranslation(0, 50, 0);
    ct = CATransform3DRotate(ct, -M_PI_2, 1, 0, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    //add cube face 5
    ct = CATransform3DMakeTranslation(-50, 0, 0);
    ct = CATransform3DRotate(ct, -M_PI_2, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    //add cube face 6
    ct = CATransform3DMakeTranslation(0, 0, -50);
    ct = CATransform3DRotate(ct, M_PI, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    //center the cube layer within the container
    CGSize containerSize = self.view.bounds.size;
    cube.position = CGPointMake(containerSize.width / 2.0, containerSize.height / 2.0);
    
    //apply the transform and return
    cube.transform = transform;
    return cube;
}

- (CALayer *)faceWithTransform:(CATransform3D)transform
{
    //create cube face layer
    CALayer *face = [CALayer layer];
    face.frame = CGRectMake(-50, -50, 100, 100);
    face.backgroundColor = [UIColor randomColor].CGColor;
    face.transform = transform;
    return face;
}

@end
