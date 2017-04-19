//
//  AndySettingSwitchItem.h
//  EyeSight
//
//  Created by 李扬 on 15/11/20.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndySettingItem.h"

@interface AndySettingSwitchItem : AndySettingItem

@property (nonatomic, copy) NSString *key;

@property (nonatomic, assign) BOOL defaultValue;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title forKey:(NSString *)key forDefaultValue:(BOOL)defaultValue;
+ (instancetype)itemWithTitle:(NSString *)title forKey:(NSString *)key forDefaultValue:(BOOL)defaultValue;

@end
