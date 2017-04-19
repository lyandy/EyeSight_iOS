//
//  AndySettingItem.m
//  EyeSight
//
//  Created by 李扬 on 15/11/20.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndySettingItem.h"

@implementation AndySettingItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title subTitle:(NSString *)subTitle
{
    AndySettingItem *item = [[self alloc] init];
    item.icon = icon;
    item.title = title;
    item.subTile = subTitle;
    return item;
}

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title
{
    return [self itemWithIcon:icon title:title subTitle:nil];
}

+ (instancetype)itemWithTitle:(NSString *)title
{
    return [self itemWithIcon:nil title:title subTitle:nil];
}

+ (instancetype)itemWithTitle:(NSString *)title subTitle:(NSString *)subTitle
{
    return [self itemWithIcon:nil title:title subTitle:subTitle];
}

@end
