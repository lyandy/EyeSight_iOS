//
//  AndyDailyListModel.h
//  EyeSight
//
//  Created by 李扬 on 15/10/21.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AndyDailyListModel : NSObject

@property (nonatomic, copy) NSString *today;

@property (nonatomic, assign) long date;

@property (nonatomic, copy) NSString *realDate;

@property(nonatomic, strong) NSArray *videoList;

@end
