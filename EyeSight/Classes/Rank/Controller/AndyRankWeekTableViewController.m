//
//  AndyRankWeekTableViewController.m
//  EyeSight
//
//  Created by 李扬 on 15/11/13.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyRankWeekTableViewController.h"
#import "AndyHttpTool.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "AndyRankWeekListModel.h"
#import "AndyRankWeekVideoListModel.h"
#import "AndyCommonVideoFrame.h"
#import "AndyCommonVideoCell.h"
#import "NSString+Andy.h"
#import "AndyDownloadModel.h"

@interface AndyRankWeekTableViewController ()<MJRefreshBaseViewDelegate>

@property (nonatomic, weak) MJRefreshHeaderView *header;
@property (nonatomic, copy) NSString *nextPageUrl;

@end

@implementation AndyRankWeekTableViewController

- (NSMutableArray *)videoListFrame
{
    if (_videoListFrame == nil)
    {
        _videoListFrame = [NSMutableArray array];
    }
    return _videoListFrame;
}

- (void)beginRefresh
{
    [super beginRefresh];
    //[self.header beginRefreshing];
    
    [MBProgressHUD showMessage:LoadingInfo toView:XAppDelegate.rankViewController.navigationController.view];
    [self loadNewData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.contentInset = UIEdgeInsetsMake(104, 0, 48, 0);
    
    //初始化下拉刷新和上拉加载更多
    [self setupRefreshView];
}

- (void)dealloc
{
    [self.header free];
}

- (void)setupRefreshView
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.delegate = self;
    self.header = header;
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    [self loadNewData];
}

- (void)loadNewData
{
    [AndyHttpTool getWithURL:@"http://baobab.wandoujia.com/api/v1/ranklist?strategy=weekly" params:nil success:^(id json) {
        
        [self CommbineNewData:json];
        
        [MBProgressHUD hideHUDForView:XAppDelegate.rankViewController.navigationController.view];
        
        [[NSString stringWithFormat:@"%@", json] saveContentToFile:RankWeekCacheFileName atomically:YES];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:XAppDelegate.rankViewController.navigationController.view];
        NSString *cacheFilePath = [AndyCommonFunction getCacheFilePathWithFileName:RankWeekCacheFileName];
        
        if ([AndyCommonFunction isNetworkConnected] == NO)
        {
            if ([AndyCommonFunction checkFileIfExist:cacheFilePath])
            {
                NSDictionary *jsonDic = [NSDictionary dictionaryWithContentsOfFile:cacheFilePath];
                [self CommbineNewData:jsonDic];
            }
            else
            {
                [MBProgressHUD showError:NetworkOfflineAndCacheIsNull toView:XAppDelegate.rankViewController.navigationController.view];
            }
        }
        else
        {
            if ([AndyCommonFunction checkFileIfExist:cacheFilePath])
            {
                NSDictionary *jsonDic = [NSDictionary dictionaryWithContentsOfFile:cacheFilePath];
                [self CommbineNewData:jsonDic];
            }
            else
            {
                [MBProgressHUD showError:LoadingError toView:XAppDelegate.rankViewController.navigationController.view];
            }
        }
        
        [self.header endRefreshing];
    }];
}

- (void)CommbineNewData:(id)json
{
    AndyRankWeekListModel  *listModel = [AndyRankWeekListModel objectWithKeyValues:json];
    
    [self.videoList removeAllObjects];
    
    [self.videoListFrame removeAllObjects];
    
    [listModel.videoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel  * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AndyCommonVideoFrame *videoFrame = [[AndyCommonVideoFrame alloc] init];
        
        [XAppDelegate.favoriteVideoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull objModel, NSUInteger idx, BOOL * _Nonnull stopTravel) {
            if (obj.videoId == objModel.videoId)
            {
                obj.isAlreadyFavorite = YES;
                AndyLog(@"已找到收藏");
                *stopTravel = YES;
            }
        }];
        
        [XAppDelegate.downloadVideoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull objModel, NSUInteger idx, BOOL * _Nonnull stopTravel) {
            if (obj.videoId == objModel.videoId)
            {
                obj.isAlreadyDownload = YES;
                obj.isDownloading = NO;
                AndyLog(@"已找到下载");
                *stopTravel = YES;
            }
        }];
        
        [[AndyDownloadTool sharedDownloadTool].downloadArrayM enumerateObjectsUsingBlock:^(AndyDownloadModel *  _Nonnull objModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.videoId == objModel.downloadId)
            {
                obj.isDownloading = true;
                obj.isAlreadyDownload = false;
                *stop = true;
            }
        }];
        
        videoFrame.videoListBaseModel = obj;
        [self.videoListFrame addObject:videoFrame];
        
        [self.videoList addObject:obj];
    }];
    
    XAppDelegate.rankViewController.videoList = [self.videoList copy];
    
    [self.tableView reloadData];
    
    [self.header endRefreshing];
    
    [MBProgressHUD hideHUDForView:XAppDelegate.rankViewController.navigationController.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.videoListFrame.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AndyCommonVideoCell *cell = [AndyCommonVideoCell cellWithTableView:tableView];
    
    cell.commonVideoFrame = (AndyCommonVideoFrame *)self.videoListFrame[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ((AndyCommonVideoFrame *)self.videoListFrame[indexPath.row]).cellHeight;
}


@end
