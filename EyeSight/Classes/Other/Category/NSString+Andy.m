//
//  NSString+Andy.m
//  EyeSight
//
//  Created by 李扬 on 15/11/5.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "NSString+Andy.h"

@implementation NSString (Andy)
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (void)saveContentToFile:(NSString *)fileName atomically:(BOOL)useAuxiliaryFile
{
    NSString *uuid = [[NSUUID UUID] UUIDString];
    AndyLog(@"%@", uuid);
    
    const char *cuuid = [uuid UTF8String];
    
    //开启一个线程去存储文件
    //nil 这里实际上开启了一个串行队列，async开启一个新的线程 #define DISPATCH_QUEUE_SERIAL NULL
    
    //1、定制队列
    dispatch_queue_t network_queue = dispatch_queue_create(cuuid, nil);
    //2、定制是否开线程
    dispatch_async(network_queue, ^{
        
        //3、定制任务
        NSString *cacheFilePath = [AndyCommonFunction getCacheFilePathWithFileName:fileName];
        
        [self writeToFile:cacheFilePath atomically:useAuxiliaryFile encoding:NSUTF8StringEncoding error:nil];
    });
}

@end
