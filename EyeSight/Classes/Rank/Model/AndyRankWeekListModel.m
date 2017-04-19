//
//  AndyRankWeekListModel.m
//  EyeSight
//
//  Created by 李扬 on 15/11/13.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyRankWeekListModel.h"
#import "MJExtension.h"
#import "AndyRankWeekVideoListModel.h"

@implementation AndyRankWeekListModel

- (NSDictionary *)objectClassInArray
{
    return @{@"videoList" : [AndyRankWeekVideoListModel class]};
}

@end
