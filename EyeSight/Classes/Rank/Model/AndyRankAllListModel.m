//
//  AndyRankAllListModel.m
//  EyeSight
//
//  Created by 李扬 on 15/11/13.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyRankAllListModel.h"
#import "MJExtension.h"
#import "AndyRankAllVideoListModel.h"

@implementation AndyRankAllListModel

- (NSDictionary *)objectClassInArray
{
    return @{@"videoList" : [AndyRankAllVideoListModel class]};
}

@end
