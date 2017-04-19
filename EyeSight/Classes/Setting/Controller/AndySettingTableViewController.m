//
//  AndySettingTableViewController.m
//  EyeSight
//
//  Created by 李扬 on 15/11/20.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndySettingTableViewController.h"
#import "AndySettingGroup.h"
#import "AndySettingItem.h"
#import "AndySettingLabelItem.h"
#import "AndySettingSwitchItem.h"
#import "AndySettingArrowItem.h"
#import "AndyAboutTableViewController.h"
#import "AndyFavoriteTableViewController.h"
#import "AndyDownloadTableViewController.h"
#import "AndySettingCacheArrowItem.h"

@implementation AndySettingTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"设置";
    
    [self setupGroup0];
    [self setupGroup1];
    [self setupGroup2];
    [self setupGroup3];
    
    //[self.tableView reloadData];
}

- (void)setupGroup0
{
    AndySettingItem *favorite = [AndySettingArrowItem itemWithTitle:@"我的收藏" destVcClass:[AndyFavoriteTableViewController class]];
    AndySettingItem *download = [AndySettingArrowItem itemWithTitle:@"我的下载" destVcClass:[AndyDownloadTableViewController class]];
    
    AndySettingGroup *group = [[AndySettingGroup alloc] init];
    group.items = @[favorite, download];
    [self.data addObject:group];
}

- (void)setupGroup1
{
    AndySettingItem *wifiPlayHighQualitySwitch = [AndySettingSwitchItem itemWithTitle:@"WiFi下自动播放高清" forKey:SettingWiFiKey forDefaultValue:YES];
    AndySettingItem *videoAutoBackSwitch = [AndySettingSwitchItem itemWithTitle:@"视频播放完毕自动返回" forKey:SettingIsVideoAutoBack forDefaultValue:YES];
    //AndySettingItem *wifiIsPlaySwitch = [AndySettingSwitchItem itemWithTitle:@"允许非WiFi网络播放视频" forKey:SettingWiFiIsPlayKey forDefaultValue:NO];
    AndySettingItem *downloadSwitch = [AndySettingSwitchItem itemWithTitle:@"视频下载自动选择高清" forKey:SettingDownloadKey forDefaultValue:YES];
    AndySettingItem *favoriteSwitch = [AndySettingSwitchItem itemWithTitle:@"收藏视频时自动下载" forKey:SettingFavoriteKey forDefaultValue:NO];
    AndySettingItem *doubleTapSwitch = [AndySettingSwitchItem itemWithTitle:@"双击视频返回列表手势" forKey:SettingDoubleTapKey forDefaultValue:NO];

    AndySettingGroup *group = [[AndySettingGroup alloc] init];
    group.items = @[wifiPlayHighQualitySwitch, videoAutoBackSwitch, downloadSwitch, favoriteSwitch, doubleTapSwitch];
    [self.data addObject:group];
}

- (void)setupGroup2
{
    AndySettingItem *clearCache = [AndySettingCacheArrowItem itemWithTitle:@"清理缓存" subTitle:@"不会清理收藏和下载"];
    
    AndySettingGroup *group = [[AndySettingGroup alloc] init];
    group.items = @[clearCache];
    [self.data addObject:group];
}

- (void)setupGroup3
{
    AndySettingItem *mark = [AndySettingArrowItem itemWithTitle:@"五星好评"];
    mark.option = ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1059327510"]];
    };
    
    AndySettingItem *about = [AndySettingArrowItem itemWithTitle:@"关于" destVcClass:[AndyAboutTableViewController class]];
    
    AndySettingGroup *group = [[AndySettingGroup alloc] init];
    group.items = @[mark, about];
    [self.data addObject:group];
}

@end
