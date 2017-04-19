//
//  AndyCateogryModel.m
//  EyeSight
//
//  Created by 李扬 on 15/11/12.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyCateogryModel.h"
#import "MJExtension.h"
#import "AndyVideoAlbumScrollCallBack.h"

@implementation AndyCateogryModel

-(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"cateogryId" : @"id"};
}

- (AndyVideoAlbumScrollCallBack *)videoAlbumScrollCallBack
{
    if (_videoAlbumScrollCallBack == nil)
    {
        _videoAlbumScrollCallBack = [[AndyVideoAlbumScrollCallBack alloc] init];
    }
    
    return _videoAlbumScrollCallBack;
}

@end
