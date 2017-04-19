//
//  AndyCommonTableViewController.m
//  EyeSight
//
//  Created by 李扬 on 15/11/4.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyCommonTableViewController.h"
#import "AndyVideoAlbumScrollTool.h"
#import "AndyVideoAlbumScrollCallBack.h"

@implementation AndyCommonTableViewController

- (NSMutableArray *)videoList
{
    if (_videoList == nil)
    {
        _videoList = [NSMutableArray array];
    }
    return _videoList;
}

- (void)beginRefresh
{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    AndyVideoAlbumScrollTool *videoAlbumScrollTool = [AndyVideoAlbumScrollTool sharedVideoAlbumScrollTool];

    if ([videoAlbumScrollTool.videoAlbumScrollCallBack.delagete respondsToSelector:@selector(videoAlbumDidScroll)])
    {
        [videoAlbumScrollTool.videoAlbumScrollCallBack.delagete videoAlbumDidScroll];
    }
    
    //videoAlbumScrollTool.videoAlbumScrollCallBack = nil;
}

@end
