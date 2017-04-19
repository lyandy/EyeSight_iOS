//
//  AndyDownloadCallBack.h
//  EyeSight
//
//  Created by 李扬 on 15/11/24.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AndyDownloadCallBack;

@protocol AndyDownloadCallBackDelegate <NSObject>

@optional
- (void)downloadProgress:(unsigned long)value downloadId:(NSInteger)downloadId;

- (void)downloadCompleteWithDownloadId:(NSInteger)downloadId;

- (void)downloadErrorWithDownloadId:(NSInteger)downloadId;

@end

@interface AndyDownloadCallBack : NSObject

@property (nonatomic, weak) id<AndyDownloadCallBackDelegate> delegate;

@end
