//
//  AndyVideoDetailOperateButton.m
//  EyeSight
//
//  Created by 李扬 on 15/11/17.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyVideoDetailOperateButton.h"

@implementation AndyVideoDetailOperateButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.titleLabel.textAlignment = NSTextAlignmentNatural;
        self.titleLabel.font = AndyVideoDetailViewCategoryAndDurationFont;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted{}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = 13;
    CGFloat imageH = imageW;
    return CGRectMake(0, 5, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 18;
    CGFloat titleY = 1.5;
    
//    NSMutableDictionary *operateButtonTextMD = [NSMutableDictionary dictionary];
//    operateButtonTextMD[NSFontAttributeName] = AndyVideoDetailViewCategoryAndDurationFont;
//    CGSize operateButtonTextSize = [self.titleLabel.text sizeWithAttributes:operateButtonTextMD];
    
    return (CGRect){{titleX, titleY}, {55, 20}};
}

@end
