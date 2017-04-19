//
//  AndySemanticImageView.m
//  EyeSight
//
//  Created by 李扬 on 15/12/4.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndySemanticImageView.h"

@implementation AndySemanticImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

- (void)setImageData:(NSData *)imageData
{
    _imageData = imageData;
    
    self.image = [UIImage imageWithData:imageData];
    
    //对图片做动画，要操作其所在的图层layer
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.scale";
    anim.values = @[@(1.0), @(1.3)];
    anim.duration = 6.0;
    anim.repeatCount = MAXFLOAT;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:anim forKey:@"scale"];
}

@end
