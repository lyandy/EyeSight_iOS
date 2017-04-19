//
//  AndyCommonVideoPlayViewController.h
//  EyeSight
//
//  Created by 李扬 on 15/11/5.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AndyVideoListBaseModel.h"

@protocol AndyCommonVideoPlayViewControllerDelegate<NSObject>

@required
- (void)moviePlayerDidFinished;

@end

@interface AndyCommonVideoPlayViewController : UIViewController

@property (nonatomic, strong) AndyVideoListBaseModel *videoModel;

@property (nonatomic, weak) id<AndyCommonVideoPlayViewControllerDelegate> delegate;

@end
