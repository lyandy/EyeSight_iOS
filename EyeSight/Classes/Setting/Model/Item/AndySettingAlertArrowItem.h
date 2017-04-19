//
//  AndySettingAlertArrowItem.h
//  EyeSight
//
//  Created by 李扬 on 15/11/21.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndySettingItem.h"

@interface AndySettingAlertArrowItem : AndySettingItem

@property (nonatomic, copy) NSString *LabelInfo;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title labelInfo:(NSString *)labelInfo;
+ (instancetype)itemWithTitle:(NSString *)title labelInfo:(NSString *)labelInfo;

@end
