//
//  AndyDailyPlayListParams.m
//  EyeSight
//
//  Created by 李扬 on 15/10/21.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyDailyPlayListParams.h"

@implementation AndyDailyPlayListParams

- (NSInteger)num
{
    return 10;
}

- (NSString *)date
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyyMMdd"];//设定时间格式,这里可以设置成自己需要的格式
    
    NSString *currentDateStr = [dateFormat stringFromDate:[NSDate date]];
    
    return currentDateStr;
}

+ (instancetype)params
{
    return [[self alloc] init];
}

@end
