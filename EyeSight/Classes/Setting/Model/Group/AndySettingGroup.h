//
//  AndySettingGroup.h
//  EyeSight
//
//  Created by 李扬 on 15/11/20.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AndySettingGroup : NSObject

@property (nonatomic, copy) NSString *header;

@property (nonatomic, copy) NSString *footer;

@property(nonatomic, strong) NSArray *items;

@end
