//
//  AndyHttpTool.m
//  EyeSight
//
//  Created by 李扬 on 15/10/22.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AndyHttpTool.h"
#import "AFNetworking.h"

@implementation AndyHttpTool

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.发送请求
    [mgr POST:url parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          if (success) {
              success(responseObject);
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure) {
              failure(error);
          }
      }];
}

+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.发送请求
    [mgr GET:url parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (success) {
             success(responseObject);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (failure) {
             failure(error);
         }
     }];
}

+ (void)downloadWithURL:(NSString *)url fileName:(NSString *)fileName localPath:(NSString *)localPath progress:(void (^)(double))progress success:(void (^)())success failure:(void (^)())failure
{
    //初始化队列
    NSOperationQueue *queue = [[NSOperationQueue alloc ]init];
    //下载地址
    NSURL *downloadUrl = [NSURL URLWithString:url];

    NSString *downloadPath = [localPath stringByAppendingPathComponent:fileName];
    
    // 1.创建请求管理对象
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:downloadUrl]];
    
    op.outputStream = [NSOutputStream outputStreamToFileAtPath:downloadPath append:NO];
    // 根据下载量设置进度条的百分比
    [op setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        CGFloat percent = (CGFloat)totalBytesRead * 100 / totalBytesExpectedToRead;
        if (progress)
        {
            progress(percent);
        }
    }];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success)
        {
            success();
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure)
        {
            failure();
        }
    }];
    //开始下载
    [queue addOperation:op];
}
@end
