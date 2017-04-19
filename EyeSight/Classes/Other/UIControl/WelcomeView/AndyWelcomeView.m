//
//  AndyWelcomeView.m
//  EyeSight
//
//  Created by 李扬 on 15/12/4.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyWelcomeView.h"
#import "AndySemanticImageView.h"

#define AppTitleLabelFont [UIFont systemFontOfSize:22]
#define AppSloganLabelFont [UIFont systemFontOfSize:19]

@interface AndyWelcomeView ()

@property (nonatomic, weak) AndySemanticImageView *semanticImageView;

@property (nonatomic, weak) UIImageView *appIconImageView;

@property (nonatomic, weak) UILabel *appTitleLabel;

@property (nonatomic, weak) UILabel *appSloganLabel;

@property (nonatomic, weak) UIView *coverView;

@end

@implementation AndyWelcomeView

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
    AndySemanticImageView *semanticImageView = [[AndySemanticImageView alloc] init];
    self.semanticImageView = semanticImageView;
    [self addSubview:self.semanticImageView];
    
    UIImageView *appIconImageView = [[UIImageView alloc] init];
    appIconImageView.image = [UIImage imageNamed:@"SplashIcon"];
    appIconImageView.contentMode = UIViewContentModeCenter;
    self.appIconImageView = appIconImageView;
    [self addSubview:self.appIconImageView];
    
    UILabel *appTitleLabel = [[UILabel alloc] init];
    appTitleLabel.font = AppTitleLabelFont;
    [appTitleLabel setTextColor:[UIColor whiteColor]];
    appTitleLabel.text = @"视窗";
    self.appTitleLabel = appTitleLabel;
    [self addSubview:appTitleLabel];

    UILabel *appSloganLabel = [[UILabel alloc] init];
    appSloganLabel.font = AppSloganLabelFont;
    [appSloganLabel setTextColor:[UIColor whiteColor]];
    appSloganLabel.text = @"看你说看，为你改变";
    self.appSloganLabel = appSloganLabel;
    [self addSubview:appSloganLabel];
    
    UIView *coverView = [[UIView alloc] init];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 1.0;
    self.coverView = coverView;
    [self addSubview:coverView];
}

- (void)layoutSubviews
{
    self.semanticImageView.imageData = self.imageData;
    self.semanticImageView.frame = (CGRect){CGPointZero, AndyMainScreenSize};

    NSMutableDictionary *appSloganLabelLabelMD = [NSMutableDictionary dictionary];
    appSloganLabelLabelMD[NSFontAttributeName] = AppSloganLabelFont;
    CGSize appSloganLabelSize = [self.appSloganLabel.text sizeWithAttributes:appSloganLabelLabelMD];
    CGFloat appSloganLabelX = (AndyMainScreenSize.width - appSloganLabelSize.width) / 2;
    CGFloat appSloganLabelY = AndyMainScreenSize.height * 0.75;
    self.appSloganLabel.frame = (CGRect){appSloganLabelX, appSloganLabelY, appSloganLabelSize};

    NSMutableDictionary *appTitleLabelLabelMD = [NSMutableDictionary dictionary];
    appTitleLabelLabelMD[NSFontAttributeName] = AppTitleLabelFont;
    CGSize appTitleLabelSize = [self.appTitleLabel.text sizeWithAttributes:appTitleLabelLabelMD];
    CGFloat appTitleLabelX = (AndyMainScreenSize.width - appTitleLabelSize.width) / 2;
    CGFloat appTitleLabelY = CGRectGetMinY(self.appSloganLabel.frame) - appTitleLabelSize.height - 35;
    self.appTitleLabel.frame = (CGRect){appTitleLabelX, appTitleLabelY, appTitleLabelSize};
    
    CGSize appIconImageViewSize = self.appIconImageView.image.size;
    CGFloat appIconImageViewX = (AndyMainScreenSize.width - appIconImageViewSize.width) / 2;
    CGFloat appIconImageViewY = CGRectGetMinY(self.appTitleLabel.frame) - appIconImageViewSize.height - 35;
    self.appIconImageView.frame = (CGRect){appIconImageViewX, appIconImageViewY, appIconImageViewSize};
    
    self.coverView.frame = self.semanticImageView.frame;
    
    [UIView animateWithDuration:1.0 animations:^{
        self.coverView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:0.6 delay:0.2 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
            self.appIconImageView.frame = (CGRect){appIconImageViewX, appIconImageViewY - 250, appIconImageViewSize};
            self.appIconImageView.alpha = 0.0;
        } completion:nil];
        
        [UIView animateKeyframesWithDuration:0.6 delay:0.3 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
            self.appTitleLabel.frame = (CGRect){appTitleLabelX, appTitleLabelY - 250, appTitleLabelSize};
            self.appTitleLabel.alpha = 0.0;
        } completion:nil];
        
        [UIView animateKeyframesWithDuration:0.6 delay:0.4 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
            self.appSloganLabel.frame = (CGRect){appSloganLabelX, appSloganLabelY - 250, appSloganLabelSize};
            self.appSloganLabel.alpha = 0.0;
        } completion:nil];
        
        //GCD延时
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hide];
        });
    }];
    
}

- (void)hide
{
    //设置顶部状态栏颜色为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    //应用启动时不显示顶部状态栏，进入应用界面再显示
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


































@end
