//
//  UIBarButtonItem+Andy.m
//  EyeSight
//
//  Created by 李扬 on 15/11/21.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "UIBarButtonItem+Andy.h"

#define AndyUIBarButtonItemButtonFont [UIFont systemFontOfSize:16.5]

@implementation UIBarButtonItem (Andy)

+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];
    button.frame = (CGRect){CGPointZero, 17, 17};
    //button.frame = (CGRect){CGPointZero, button.currentBackgroundImage.size};
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)itemWithButtonNormalTitle:(NSString *)normalTitle selectedTitle:(NSString *)selectedTitle target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"编辑" forState:UIControlStateNormal];
    [button setTitle:@"取消" forState:UIControlStateSelected];
    button.titleLabel.font = AndyUIBarButtonItemButtonFont;
    
    NSMutableDictionary *buttonLabelM = [NSMutableDictionary dictionary];
    buttonLabelM[NSFontAttributeName] = AndyUIBarButtonItemButtonFont;
    CGSize buttonSize = [button.titleLabel.text sizeWithAttributes:buttonLabelM];
    
    button.frame = (CGRect){CGPointZero, buttonSize};
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
