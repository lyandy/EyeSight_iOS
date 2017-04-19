//
//  AndyRankMonthListModel.m
//  EyeSight
//
//  Created by 李扬 on 15/11/13.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyRankMonthListModel.h"
#import "MJExtension.h"
#import "AndyRankMonthVideoListModel.h"

@implementation AndyRankMonthListModel

- (NSDictionary *)objectClassInArray
{
    return @{@"videoList" : [AndyRankMonthVideoListModel class]};
}

@end
