//
//  AndySettingAlertArrowItem.m
//  EyeSight
//
//  Created by 李扬 on 15/11/21.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndySettingAlertArrowItem.h"

@implementation AndySettingAlertArrowItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title labelInfo:(NSString *)labelInfo
{
    AndySettingAlertArrowItem *item = [self itemWithIcon:icon title:title];
    item.LabelInfo = labelInfo;
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title labelInfo:(NSString *)labelInfo
{
    AndySettingAlertArrowItem *item = [self itemWithTitle:title];
    item.LabelInfo = labelInfo;
    return item;
}

@end
