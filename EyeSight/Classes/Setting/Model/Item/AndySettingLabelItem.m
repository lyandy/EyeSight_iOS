//
//  AndySettingLabelItem.m
//  EyeSight
//
//  Created by 李扬 on 15/11/20.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndySettingLabelItem.h"

@implementation AndySettingLabelItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title labelInfo:(NSString *)labelInfo
{
    AndySettingLabelItem *item = [self itemWithIcon:icon title:title];
    item.LabelInfo = labelInfo;
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title labelInfo:(NSString *)labelInfo
{
    AndySettingLabelItem *item = [self itemWithTitle:title];
    item.LabelInfo = labelInfo;
    return item;
}

@end
