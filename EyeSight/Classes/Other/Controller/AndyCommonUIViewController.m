//
//  AndyCommonUIViewController.m
//  EyeSight
//
//  Created by 李扬 on 15/12/7.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyCommonUIViewController.h"

@implementation AndyCommonUIViewController

- (NSMutableArray *)videoList
{
    if (_videoList == nil)
    {
        _videoList = [NSMutableArray array];
    }
    return _videoList;
}

@end
