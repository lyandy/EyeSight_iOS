//
//  UIBarButtonItem+Andy.h
//  EyeSight
//
//  Created by 李扬 on 15/11/21.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Andy)

+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)itemWithButtonNormalTitle:(NSString *)normalTitle selectedTitle:(NSString *)selectedTitle target:(id)target action:(SEL)action;

@end
