//
//  AndyDailyPlayListParams.h
//  EyeSight
//
//  Created by 李扬 on 15/10/21.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AndyDailyPlayListParams : NSObject

@property (nonatomic, copy) NSString *date;

@property (nonatomic, assign) NSInteger num;

+ (instancetype)params;

@end
