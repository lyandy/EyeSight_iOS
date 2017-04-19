//
//  AndyVideoAlbumScrollTool.h
//  EyeSight
//
//  Created by 李扬 on 15/12/8.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AndyVideoAlbumScrollCallBack;

@interface AndyVideoAlbumScrollTool : NSObject

@property (nonatomic, strong) AndyVideoAlbumScrollCallBack *videoAlbumScrollCallBack;

+ (instancetype)sharedVideoAlbumScrollTool;

@end
