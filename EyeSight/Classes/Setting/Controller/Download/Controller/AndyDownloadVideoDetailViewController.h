//
//  AndyDownloadVideoDetailViewController.h
//  EyeSight
//
//  Created by 李扬 on 15/11/30.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AndyCommonVideoPlayViewController.h"
#import <MessageUI/MessageUI.h>

@interface AndyDownloadVideoDetailViewController : UIViewController<AndyCommonVideoPlayViewControllerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>


@property (nonatomic, strong) NSMutableArray *videoList;

@property (nonatomic, strong) AndyVideoListBaseModel *currentVideoModel;

@property (nonatomic, strong) AndyCommonVideoPlayViewController *commonVideoPlayerVC;

@end
