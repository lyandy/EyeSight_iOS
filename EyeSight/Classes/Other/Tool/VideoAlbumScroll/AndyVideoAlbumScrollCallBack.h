//
//  AndyVideoAlbumScrollCallBack.h
//  EyeSight
//
//  Created by 李扬 on 15/12/8.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AndyVideoAlbumScrollCallBack;

@protocol AndyVideoAlbumScrollCallBackDelegate <NSObject>

@optional
- (void)videoAlbumDidScroll;

@end


@interface AndyVideoAlbumScrollCallBack : NSObject

@property (nonatomic, weak) id<AndyVideoAlbumScrollCallBackDelegate> delagete;

@end
