//
//  AndyCommonVideoDetailTableViewController.h
//  EyeSight
//
//  Created by 李扬 on 15/11/6.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyCommonTableViewController.h"
#import "AndyCommonVideoPlayViewController.h"

@interface AndyCommonVideoDetailTableViewController : UIViewController<AndyCommonVideoPlayViewControllerDelegate>

@property (nonatomic, strong) AndyCommonVideoPlayViewController *commonVideoPlayerVC;

@property (nonatomic, strong) NSMutableArray *videoList;

@end
