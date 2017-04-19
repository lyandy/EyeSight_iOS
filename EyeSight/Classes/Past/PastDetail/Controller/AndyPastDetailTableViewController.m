//
//  AndyPastDetailTableViewController.m
//  EyeSight
//
//  Created by 李扬 on 15/11/12.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyPastDetailTableViewController.h"
#import "AndyHttpTool.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "AndyPastDetailListModel.h"
#import "AndyPastDetailVideoListModel.h"
#import "AndyCommonVideoFrame.h"
#import "AndyCommonVideoCell.h"
#import "AndyDownloadModel.h"

@interface AndyPastDetailTableViewController ()<MJRefreshBaseViewDelegate>

@property (nonatomic, weak) MJRefreshHeaderView *header;
@property (nonatomic, weak) MJRefreshFooterView *footer;
@property (nonatomic, copy) NSString *nextPageUrl;
@property (nonatomic, strong) NSMutableArray *videoListFrame;

@end

@implementation AndyPastDetailTableViewController

- (NSMutableArray *)videoListFrame
{
    if (_videoListFrame == nil)
    {
        _videoListFrame = [NSMutableArray array];
    }
    return _videoListFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //初始化下拉刷新和上拉加载更多
    [self setupRefreshView];
}


- (void)dealloc
{
    [self.header free];
    [self.footer free];
}

- (void)setupRefreshView
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.delegate = self;
    
    [header beginRefreshing];
    self.header = header;
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.delegate = self;
    self.footer = footer;
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshFooterView class]])
    {
        if (self.nextPageUrl != nil)
        {
            [self loadMoreData];
        }
    }
    else
    {
        [self loadNewData];
    }
}

- (void)refresh
{
    [self.header beginRefreshing];
}

- (void)loadMoreData
{
    [AndyHttpTool getWithURL:self.nextPageUrl params:nil success:^(id json) {
        
        AndyPastDetailListModel  *listModel = [AndyPastDetailListModel objectWithKeyValues:json];
        
        self.nextPageUrl = listModel.nextPageUrl;
        
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
        
        [self.tableView reloadData];
        
        [self.footer endRefreshing];
        
    } failure:^(NSError *error) {
        [self.footer endRefreshing];
        
        if ([AndyCommonFunction isNetworkConnected] == NO)
        {
            [MBProgressHUD showError:NetworkOfflineAndCacheIsNull toView:self.navigationController.view];
        }
        else
        {
            [MBProgressHUD showError:LoadingError toView:self.navigationController.view];
        }
    }];
}

- (void)loadNewData
{
    [AndyHttpTool getWithURL:self.categoryDetailUrl params:nil success:^(id json) {
        
        AndyPastDetailListModel  *listModel = [AndyPastDetailListModel objectWithKeyValues:json];
        
        self.nextPageUrl = listModel.nextPageUrl;
        
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

        [self.tableView reloadData];
        
        [self.header endRefreshing];
        
    } failure:^(NSError *error) {
        [self.header endRefreshing];
        
        if ([AndyCommonFunction isNetworkConnected] == NO)
        {
            [MBProgressHUD showError:NetworkOfflineAndCacheIsNull toView:self.navigationController.view];
        }
        else
        {
            [MBProgressHUD showError:LoadingError toView:self.navigationController.view];
        }

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
