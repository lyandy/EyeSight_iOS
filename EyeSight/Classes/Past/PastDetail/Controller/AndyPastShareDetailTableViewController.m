//
//  AndyPastShareDetailTableViewController.m
//  EyeSight
//
//  Created by 李扬 on 15/12/7.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyPastShareDetailTableViewController.h"
#import "MBProgressHUD+MJ.h"
#import "AndyHttpTool.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "AndyPastDetailListModel.h"
#import "AndyCommonVideoFrame.h"
#import "AndyVideoListBaseModel.h"
#import "AndyDownloadModel.h"
#import "AndyCommonVideoCell.h"

@interface AndyPastShareDetailTableViewController ()<MJRefreshBaseViewDelegate>

@property (nonatomic, weak) MJRefreshHeaderView *header;
@property (nonatomic, weak) MJRefreshFooterView *footer;
@property (nonatomic, copy) NSString *nextPageUrl;
@property (nonatomic, strong) NSMutableArray *videoListFrame;

@end

@implementation AndyPastShareDetailTableViewController

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
    
    self.tableView.contentInset = UIEdgeInsetsMake(104, 0, 0, 0);
    
    XAppDelegate.categoryShareVideoList = self.videoList;
    
    //初始化下拉刷新和上拉加载更多
    [self setupRefreshView];
}

- (void)beginRefresh
{
    [super beginRefresh];
    //[self.header beginRefreshing];
    
    [MBProgressHUD showMessage:LoadingInfo toView:self.pastDetailViewController.navigationController.view];
    [self loadNewData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [MBProgressHUD hideHUDForView:self.pastDetailViewController.navigationController.view];
    
    [super viewDidDisappear:animated];
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
        
        self.pastDetailViewController.videoList = [self.videoList copy];
        
        [self.tableView reloadData];
        
        [self.footer endRefreshing];
        
    } failure:^(NSError *error) {
        [self.footer endRefreshing];
    }];
}

- (void)loadNewData
{
    [AndyHttpTool getWithURL:self.categoryShareDetailUrl params:nil success:^(id json) {
        
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
        
        self.pastDetailViewController.videoList = [self.videoList copy];
        
        [self.tableView reloadData];
        
        [self.header endRefreshing];
        
        [MBProgressHUD hideHUDForView:self.pastDetailViewController.navigationController.view];
        
    } failure:^(NSError *error) {
        [self.header endRefreshing];
        
        [MBProgressHUD hideHUDForView:self.pastDetailViewController.navigationController.view];
        
        if ([AndyCommonFunction isNetworkConnected] == NO)
        {
            [MBProgressHUD showError:NetworkOfflineAndCacheIsNull toView:self.pastDetailViewController.navigationController.view];
        }
        else
        {
            [MBProgressHUD showError:LoadingError toView:self.pastDetailViewController.navigationController.view];
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
