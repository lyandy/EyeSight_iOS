//
//  AndyDownloadTool.h
//  EyeSight
//
//  Created by 李扬 on 15/11/22.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AndyDownloadTool : NSObject

@property(nonatomic, strong) NSMutableArray *downloadArrayM;

+ (instancetype)sharedDownloadTool;

@end
