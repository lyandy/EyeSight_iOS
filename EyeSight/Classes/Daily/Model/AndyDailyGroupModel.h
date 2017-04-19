//
//  AndyDailyGroupModel.h
//  EyeSight
//
//  Created by 李扬 on 15/10/22.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AndyDailyGroupModel : NSObject
@property (nonatomic, copy) NSString *today;

@property (nonatomic, assign) long date;

@property(nonatomic, strong) NSArray *videoList;

- (instancetype)initWithDict:(NSDictionary *)dict;
- (instancetype)dailyGroupWithDict:(NSDictionary *)dict;

@end
