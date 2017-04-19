//
//  AppDelegate.h
//  EyeSight
//
//  Created by 李扬 on 15/10/21.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AndyDailyTableViewController.h"
#import "AndyRankWeekTableViewController.h"
#import "AndyRankMonthTableViewController.h"
#import "AndyRankAllTableViewController.h"
#import "AndyRankViewController.h"
#import "WeiboSDK.h"
#import "TencentOpenAPI/TencentOAuth.h"
#import "WXApi.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, WeiboSDKDelegate, TencentSessionDelegate, WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) NSMutableArray *favoriteVideoList;

@property (nonatomic, strong) NSMutableArray *downloadVideoList;

@property(nonatomic, weak) NSMutableArray *categoryTimeVideoList;

@property(nonatomic, weak) NSMutableArray *categoryShareVideoList;

@property(nonatomic, strong) AndyDailyTableViewController *dailyTableViewController;

@property(nonatomic, strong) AndyRankViewController *rankViewController;

@property(nonatomic, strong) AndyRankWeekTableViewController *rankWeekTableViewController;

@property(nonatomic, strong) AndyRankMonthTableViewController *rankMonthTableViewController;

@property(nonatomic, strong) AndyRankAllTableViewController *rankAllTableViewController;

@property (nonatomic, assign) BOOL isCanCapture;

@end

