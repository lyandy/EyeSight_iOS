//
//  AndySlideBarButton.m
//  EyeSight
//
//  Created by 李扬 on 15/11/13.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndySlideBarButton.h"

#define AndyLineMargin 30

@interface AndySlideBarButton ()

@end

@implementation AndySlideBarButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    
    [self setBackgroundColor:[UIColor clearColor]];
    
//    UIView *topLineView = [[UIView alloc] init];
//    topLineView.backgroundColor = AndyNavigationBarTintColor;
//    topLineView.alpha = 0.0;
//    self.topLineView = topLineView;
//    [self addSubview:self.topLineView];
//    
//    UIView *bottomLineView = [[UIView alloc] init];
//    bottomLineView.backgroundColor = AndyNavigationBarTintColor;
//    bottomLineView.alpha = 0.0;
//    self.bottomLineView = bottomLineView;
//    [self addSubview:self.bottomLineView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    CGFloat topLineViewX = AndyLineMargin;
//    CGFloat topLineViewY = 5;
//    CGFloat topLineViewW = self.frame.size.width - 2 * AndyLineMargin;
//    CGFloat topLineViewH = 1;
//    self.topLineView.frame = CGRectMake(topLineViewX, topLineViewY, topLineViewW, topLineViewH);
//    
//    CGFloat bottomLineViewX = topLineViewX;
//    CGFloat bottomLineViewY = self.frame.size.height - 5;
//    CGFloat bottomLineViewW = topLineViewW;
//    CGFloat bottomLineViewH = 1;
//    self.bottomLineView.frame = CGRectMake(bottomLineViewX, bottomLineViewY, bottomLineViewW, bottomLineViewH);
}

- (void)setHighlighted:(BOOL)highlighted{}






















// 内部文字的frame
//- (CGRect)titleRectForContentRect:(CGRect)contentRect
//{
//    CGFloat titleY = contentRect.size.height / 2;
//    CGFloat titleW = contentRect.size.width;
//    CGFloat titleH = contentRect.size.height - titleY;
//    return CGRectMake(0, titleY, titleW, titleH);
//}

@end
