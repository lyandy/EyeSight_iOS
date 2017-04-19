//
//  AndyDownloadTool.h
//  EyeSight
//
//  Created by 李扬 on 15/11/21.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AndyDownloadModel : NSObject

@property (nonatomic, assign) NSInteger downloadId;

@property (nonatomic, copy) NSString *downloadUrl;

@property(nonatomic, strong) NSMutableArray *videoDownloadCallBackArrayM;

- (void)startDownload;

@end
