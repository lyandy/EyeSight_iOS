//
//  AndyCommonVideoFrame.h
//  EyeSight
//
//  Created by 李扬 on 15/10/22.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AndyVideoListBaseModel;

@interface AndyCommonVideoFrame : NSObject

@property (nonatomic, strong) AndyVideoListBaseModel *videoListBaseModel;

@property (nonatomic, assign, readonly) CGRect bgViewF;

@property (nonatomic, assign, readonly) CGRect coverViewF;

@property (nonatomic, assign, readonly) CGRect titleLabelF;

@property (nonatomic, assign, readonly) CGRect categoryAndDurationLabelF;

@property (nonatomic, assign, readonly) CGFloat cellHeight;

@end
