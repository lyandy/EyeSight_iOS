//
//  AndyPastDetailListModel.m
//  EyeSight
//
//  Created by 李扬 on 15/11/12.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyPastDetailListModel.h"
#import "MJExtension.h"
#import "AndyPastDetailVideoListModel.h"

@implementation AndyPastDetailListModel

- (NSDictionary *)objectClassInArray
{
    return @{@"videoList" : [AndyPastDetailVideoListModel class]};
}

@end
