//
//  AndyDailyListRootModel.m
//  EyeSight
//
//  Created by 李扬 on 15/10/21.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyDailyListRootModel.h"
#import "MJExtension.h"
#import "AndyDailyListModel.h"

@implementation AndyDailyListRootModel

- (NSDictionary *)objectClassInArray
{
    return @{@"dailyList" : [AndyDailyListModel class]};
}

@end
