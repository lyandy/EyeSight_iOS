//
//  AndyDailyTableViewController.m
//  EyeSight
//
//  Created by 李扬 on 15/10/21.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyDailyTableViewController.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "UIImageView+WebCache.h"
#import "AndyDailyListRootModel.h"
#import "AndyDailyListModel.h"
#import "AndyDailyVideoListModel.h"
#import "AndyDailyPlayListParams.h"
#import "AndyCommonVideoCell.h"
#import "AndyCommonVideoFrame.h"
#import "AndyDailyHeaderView.h"
#import "AndyCommonTableViewController.h"
#import "NSString+Andy.h"
#import "AndyDownloadModel.h"

@interface AndyDailyTableViewController () <MJRefreshBaseViewDelegate>

@property (nonatomic, weak) MJRefreshHeaderView *header;
@property (nonatomic, weak) MJRefreshFooterView *footer;
@property (nonatomic, copy) NSString *nextPageUrl;
@property (nonatomic, strong) NSMutableArray *videoListGroups;

@end

@implementation AndyDailyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //初始化下拉刷新和上拉加载更多
    [self setupRefreshView];

    [MBProgressHUD showMessage:LoadingInfo toView:self.navigationController.view];
    [self loadNewData];
    //self.tableView.backgroundColor = [UIColor redColor];
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
    
    //[header beginRefreshing];
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
        
        AndyDailyListRootModel *rootModel = [AndyDailyListRootModel objectWithKeyValues:json];
        
        self.nextPageUrl = rootModel.nextPageUrl;
        
        NSMutableArray *arraryM = [NSMutableArray array];
        
        [rootModel.dailyList enumerateObjectsUsingBlock:^(AndyDailyListModel  * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableArray *arrM = [NSMutableArray array];
            [obj.videoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel  * _Nonnull baseObj, NSUInteger idx, BOOL * _Nonnull stop) {
                AndyCommonVideoFrame *videoFrame = [[AndyCommonVideoFrame alloc] init];
                
                [XAppDelegate.favoriteVideoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stopTravel) {
                    if (obj.videoId == baseObj.videoId)
                    {
                        baseObj.isAlreadyFavorite = YES;
                        AndyLog(@"已找到收藏");
                        *stopTravel = YES;
                    }
                }];
                
                [XAppDelegate.downloadVideoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stopTravel) {
                    if (obj.videoId == baseObj.videoId)
                    {
                        baseObj.isAlreadyDownload = YES;
                        baseObj.isDownloading = NO;
                        AndyLog(@"已找到下载");
                        *stopTravel = YES;
                    }
                }];
                
                [[AndyDownloadTool sharedDownloadTool].downloadArrayM enumerateObjectsUsingBlock:^(AndyDownloadModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.downloadId == baseObj.videoId)
                    {
                        baseObj.isDownloading = true;
                        baseObj.isAlreadyDownload = false;
                        *stop = true;
                    }
                }];
                
                videoFrame.videoListBaseModel = baseObj;
                [arrM addObject:videoFrame];
                
                [self.videoList addObject:baseObj];
            }];
            
            obj.videoList = arrM;
            [arraryM addObject:obj];
        }];

        [self.videoListGroups addObjectsFromArray:arraryM];
        
        [self.tableView reloadData];
        
        [self.footer endRefreshing];

    } failure:^(NSError *error) {
        [self.footer endRefreshing];
    }];
}

- (void)loadNewData
{
    [AndyHttpTool getWithURL:@"http://baobab.wandoujia.com/api/v1/feed" params:[AndyDailyPlayListParams params].keyValues success:^(id json) {

        [self CommbineNewData:json];
        // 缓存
        [[NSString stringWithFormat:@"%@", json] saveContentToFile:DailyCacheFileName atomically:YES];
        
    } failure:^(NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.navigationController.view];
         
         NSString *cacheFilePath = [AndyCommonFunction getCacheFilePathWithFileName:DailyCacheFileName];
         
         if ([AndyCommonFunction isNetworkConnected] == NO)
         {
             if ([AndyCommonFunction checkFileIfExist:cacheFilePath])
             {
                 NSDictionary *jsonDic = [NSDictionary dictionaryWithContentsOfFile:cacheFilePath];
                 //NSString *jsonStr = [NSString stringWithContentsOfFile:cacheFilePath encoding:NSUTF8StringEncoding error:nil];
                 [self CommbineNewData:jsonDic];
             }
             else
             {
                 [MBProgressHUD showError:NetworkOfflineAndCacheIsNull toView:self.navigationController.view];
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
                 [MBProgressHUD showError:LoadingError toView:self.navigationController.view];
             }
         }
         
         [self.header endRefreshing];
    }];
}

- (void)CommbineNewData:(id)json
{
    AndyDailyListRootModel *rootModel = [AndyDailyListRootModel objectWithKeyValues:json];
    
    self.nextPageUrl = rootModel.nextPageUrl;
    
    NSMutableArray *arraryM = [NSMutableArray array];
    
    __block int videoListCount = 0;
    
    [self.videoList removeAllObjects];

    [rootModel.dailyList enumerateObjectsUsingBlock:^(AndyDailyListModel  * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *arrM = [NSMutableArray array];
        
        //添加Cmapaign专题栏目
        if (self.videoList.count == 0)
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            BOOL isCampaignAvailable = [defaults boolForKey:CampaignIsAvailableKey];
            NSString *campaignImageUrl = [defaults stringForKey:CampaignImageUrlKey];
            NSString *campaignActionUrl = [defaults stringForKey:CampaignActionUrlKey];
            
            if (isCampaignAvailable == YES && campaignImageUrl != nil && campaignActionUrl != nil)
            {
                AndyVideoListBaseModel *campBaseObj = [[AndyVideoListBaseModel alloc] init];
                campBaseObj.coverForDetail = campaignImageUrl;
                campBaseObj.webUrl = campaignActionUrl;
                
                AndyCommonVideoFrame *campFrame = [[AndyCommonVideoFrame alloc] init];
                campFrame.videoListBaseModel = campBaseObj;
                [arrM addObject:campFrame];
                videoListCount++;
            }
        }
        
        [obj.videoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel  * _Nonnull baseObj, NSUInteger idx, BOOL * _Nonnull stop) {
            AndyCommonVideoFrame *videoFrame = [[AndyCommonVideoFrame alloc] init];
            
            [XAppDelegate.favoriteVideoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stopTravel) {
                if (obj.videoId == baseObj.videoId)
                {
                    baseObj.isAlreadyFavorite = YES;
                    AndyLog(@"已找到收藏");
                    *stopTravel = YES;
                }
            }];
            
            [XAppDelegate.downloadVideoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stopTravel) {
                if (obj.videoId == baseObj.videoId)
                {
                    baseObj.isAlreadyDownload = YES;
                    baseObj.isDownloading = NO;
                    AndyLog(@"已找到下载");
                    *stopTravel = YES;
                }
            }];
            
            [[AndyDownloadTool sharedDownloadTool].downloadArrayM enumerateObjectsUsingBlock:^(AndyDownloadModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.downloadId == baseObj.videoId)
                {
                    baseObj.isDownloading = true;
                    baseObj.isAlreadyDownload = false;
                    *stop = true;
                }
            }];

            videoFrame.videoListBaseModel = baseObj;
            [arrM addObject:videoFrame];
            videoListCount++;
            
            [self.videoList addObject:baseObj];
        }];
        
        obj.videoList = arrM;
        [arraryM addObject:obj];
    }];
    
    BOOL isShouldNoticeCount = false;
    if (self.videoListGroups.count == 0)
    {
        isShouldNoticeCount = true;
    }
    
    self.videoListGroups = arraryM;
    
    [self.tableView reloadData];
    
    [self.header endRefreshing];
    
    [MBProgressHUD hideHUDForView:self.navigationController.view];
    
    if (isShouldNoticeCount)
    {
        //[self showVideoListCount:videoListCount];
    }
    else
    {
        //[self showVideoListCount:0];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.videoListGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AndyDailyListModel *dailyModel = self.videoListGroups[section];
    return dailyModel.videoList.count;
}

//- (void)commonCellViewNeedNavigate:(AndyCommonVideoCell *)andyCommonViewCell
//{
//    UIViewController *vc = [[AndyDailyViewController alloc] init];
//    vc.title = @"哈哈哈";
//    vc.view.backgroundColor = [UIColor whiteColor];
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AndyCommonVideoCell *cell = [AndyCommonVideoCell cellWithTableView:tableView];
    
    //cell.commonDelegate = self;
    
    AndyDailyListModel *dailyModel = self.videoListGroups[indexPath.section];
    
    cell.commonVideoFrame = (AndyCommonVideoFrame *)dailyModel.videoList[indexPath.row];

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return nil;
    }
    else
    {
        AndyDailyHeaderView *headerView = [AndyDailyHeaderView viewWithTableView:tableView];
        headerView.dailyListModel = self.videoListGroups[section];
        return headerView;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //隐藏遮罩层和标题介绍
    
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    return 45;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    //第一条数据不显示日期
//    if (section == 0)
//    {
//        return nil;
//    }
//    
//    AndyDailyListModel *dailyModel = self.dailyListGroups[section];
//    return dailyModel.realDate;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AndyDailyListModel *dailyModel = self.videoListGroups[indexPath.section];
    
    return ((AndyCommonVideoFrame *)dailyModel.videoList[indexPath.row]).cellHeight;
}

- (void)showVideoListCount:(int)count
{
    UIButton *btn = [[UIButton alloc] init];
    
    [self.navigationController.view insertSubview:btn belowSubview:self.navigationController.navigationBar];
    
    btn.userInteractionEnabled = NO;
    [btn setBackgroundColor:AndyColor(245, 146, 46, 1.0)];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    if (count)
    {
        NSString *title = [NSString stringWithFormat:@"已为您加载%d条视频信息", count];
        [btn setTitle:title forState:UIControlStateNormal];
    }
    else
    {
        [btn setTitle:@"暂无新的视频信息" forState:UIControlStateNormal];
    }
    
    CGFloat btnX= 0;
    CGFloat btnH = 30;
    CGFloat btnY = 64 - btnH;
    CGFloat btnW = [UIScreen mainScreen].bounds.size.width;
    btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    
    [UIView animateWithDuration:0.7 animations:^{
        btn.transform = CGAffineTransformMakeTranslation(0, btnH);
    } completion:^(BOOL finished) {
       [UIView animateWithDuration:0.7 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
           btn.transform = CGAffineTransformIdentity;
       } completion:^(BOOL finished) {
           [btn removeFromSuperview];
       }];
    }];
}

@end
