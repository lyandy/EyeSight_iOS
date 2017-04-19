//
//  AndyVideoDetailTopUIImageView.m
//  EyeSight
//
//  Created by 李扬 on 15/11/5.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyVideoDetailTopUIImageView.h"
#import "UIImageView+WebCache.h"

@implementation AndyVideoDetailTopUIImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    
    //这种写法可以通用弱指针，防止循环强引用防止内存泄露
    __unsafe_unretained typeof(self) selfImageView = self;
    
    [self setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        [UIView animateWithDuration:0.2 animations:^{
            selfImageView.alpha = 1.0;
        }];
    }];
    //[self setImageWithURL:[NSURL URLWithString:imageUrl]];
    
    //对图片做动画，要操作其所在的图层layer
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.scale";
    anim.values = @[@(1.0), @(1.05), @(1.0)];
    anim.duration = 10.0;
    anim.repeatCount = MAXFLOAT;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:anim forKey:@"scale"];
    
    //停止动画用下面这个方法
    //[self.layer removeAnimationForKey:@"shake"];
    
//    [UIView animateWithDuration:3 animations:^{
//        self.transform = CGAffineTransformMakeScale(2, 2);
//    } completion:^(BOOL finished) {
//        self.transform = CGAffineTransformIdentity;
//    }];
}

@end
