//
//  AndyDownloadTool.m
//  EyeSight
//
//  Created by 李扬 on 15/11/22.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyDownloadTool.h"
#import "AndyDownloadModel.h"

@implementation AndyDownloadTool

- (NSMutableArray *)downloadArrayM
{
    if (_downloadArrayM == nil)
    {
        _downloadArrayM = [NSMutableArray array];
    }
    return _downloadArrayM;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static AndyDownloadTool *instance;
    
    static dispatch_once_t oneToken;
    
    dispatch_once(&oneToken, ^{
        instance = [super allocWithZone:zone];
    });
    
    return instance;
}

+ (instancetype)sharedDownloadTool
{
    return [[self alloc] init];
}

@end
