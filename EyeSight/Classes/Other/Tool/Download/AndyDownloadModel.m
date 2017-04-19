//
//  AndyDownloadTool.m
//  EyeSight
//
//  Created by 李扬 on 15/11/21.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyDownloadModel.h"
#import "AndyDownloadCallBack.h"

@implementation AndyDownloadModel

- (NSMutableArray *)videoDownloadCallBackArrayM
{
    if (_videoDownloadCallBackArrayM == nil)
    {
        _videoDownloadCallBackArrayM = [NSMutableArray array];
    }
    return _videoDownloadCallBackArrayM;
}

- (void)startDownload
{
    NSArray *array = [self.downloadUrl componentsSeparatedByString:@"/"];
    
    NSString *fileName = (NSString *)[array lastObject];
    
    [AndyHttpTool downloadWithURL:self.downloadUrl fileName:fileName localPath:[AndyCommonFunction applicationDocumentsVideoDownloadDirectory] progress:^(double p) {
        
        [self.videoDownloadCallBackArrayM enumerateObjectsUsingBlock:^(AndyDownloadCallBack *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([obj.delegate respondsToSelector:@selector(downloadProgress:downloadId:)])
                {
                    [obj.delegate downloadProgress:p downloadId:self.downloadId];
                }
            });
        }];
        
    } success:^{
        [self.videoDownloadCallBackArrayM enumerateObjectsUsingBlock:^(AndyDownloadCallBack *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([obj.delegate respondsToSelector:@selector(downloadCompleteWithDownloadId:)])
                {
                    [obj.delegate downloadCompleteWithDownloadId:self.downloadId];
                }
            });
        }];
    } failure:^{
        [self.videoDownloadCallBackArrayM enumerateObjectsUsingBlock:^(AndyDownloadCallBack *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([obj.delegate respondsToSelector:@selector(downloadErrorWithDownloadId:)])
                {
                    [obj.delegate downloadErrorWithDownloadId:self.downloadId];
                }
            });
        }];
    }];
}

@end
