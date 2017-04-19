//
//  AndyVideoAlbumScrollTool.m
//  EyeSight
//
//  Created by 李扬 on 15/12/8.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyVideoAlbumScrollTool.h"

@implementation AndyVideoAlbumScrollTool

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static AndyVideoAlbumScrollTool *instance;
    
    static dispatch_once_t oneToken;
    
    dispatch_once(&oneToken, ^{
        instance = [super allocWithZone:zone];
    });
    
    return instance;
}

+ (instancetype)sharedVideoAlbumScrollTool
{
    return [[self alloc] init];
}

@end
