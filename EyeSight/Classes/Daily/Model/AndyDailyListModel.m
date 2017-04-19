//
//  AndyDailyListModel.m
//  EyeSight
//
//  Created by 李扬 on 15/10/21.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyDailyListModel.h"
#import "MJExtension.h"
#import "AndyDailyVideoListModel.h"

@implementation AndyDailyListModel

- (NSDictionary *)objectClassInArray
{
    return @{@"videoList" : [AndyDailyVideoListModel class]};
}

- (NSString *)realDate
{
//    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:self.date / 1000];
//    
//#warning 时间NSDate格式化
//    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//#warning 真机调试下, 必须加上这段
//    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
//    NSDate *createdDate = [fmt dateFromString:[NSString stringWithFormat:@"%@", confromTimesp]];
//    
//    return [NSString stringWithFormat:@"%@", createdDate];
    
    //NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象

    //[dateFormat setDateFormat:@"- yyyyMMdd -"];//设定时间格式,这里可以设置成自己需要的格式
    //[dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*60*60]];
    
    //NSString *currentDateStr = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.date / 1000]];

    NSDate *now= [NSDate dateWithTimeIntervalSince1970:self.date / 1000];
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateStyle = kCFDateFormatterMediumStyle;//日期格式
    //fmt.timeStyle = kCFDateFormatterMediumStyle;//时间格式
    fmt.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];//zh_CN,则为简体中文输出
    NSString *dataString =[fmt stringFromDate:now];
    //NSLog(@"%@",dataString);
    
    NSArray *arr = [dataString componentsSeparatedByString:@","];
    NSArray *detailArr = [[NSString stringWithFormat:@"%@", arr[0]] componentsSeparatedByString:@" "];
    NSString *realString = [NSString stringWithFormat:@"- %@. %@ - ", detailArr[0], detailArr[1]];
    
    return realString;
}


@end
