//
//  AndyVideoPlayViewConteroller.h
//  EyeSight
//
//  Created by 李扬 on 15/12/10.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AndyVideoListBaseModel;

@interface AndyVideoPlayViewConteroller : UIViewController

@property(nonatomic, strong) NSURL *playNSURL;

@property (nonatomic, copy) NSString *videoTitle;

@property(nonatomic, strong) AndyVideoListBaseModel *videoModel;

@end
