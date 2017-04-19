//
//  AndySettingSwitchItem.m
//  EyeSight
//
//  Created by 李扬 on 15/11/20.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndySettingSwitchItem.h"

@implementation AndySettingSwitchItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title forKey:(NSString *)key forDefaultValue:(BOOL)defaultValue;
{
    AndySettingSwitchItem *item = [self itemWithIcon:icon title:title];
    item.key = key;
    item.defaultValue = defaultValue;
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title forKey:(NSString *)key forDefaultValue:(BOOL)defaultValue;
{
    AndySettingSwitchItem *item = [self itemWithTitle:title];
    item.key = key;
    item.defaultValue = defaultValue;
    return item;
}

@end
