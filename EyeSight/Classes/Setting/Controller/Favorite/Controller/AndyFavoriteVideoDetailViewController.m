//
//  AndyFavoriteVideoDetailViewController.m
//  EyeSight
//
//  Created by 李扬 on 15/11/30.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyFavoriteVideoDetailViewController.h"

#import "UIImageView+WebCache.h"
#import "AndyVideoListBaseModel.h"
#import "AndyFavoriteVideoDetailViewCell.h"

@interface AndyFavoriteVideoDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

//@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation AndyFavoriteVideoDetailViewController

- (NSMutableArray *)videoList
{
    if (_videoList == nil)
    {
        _videoList = [NSMutableArray array];
    }
    
    return _videoList;
}

- (void)dealloc
{
    AndyLog(@"分类详情页内存已释放");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //这里要酌情写啊，好坑的
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    AndyLog(@"%f", self.view.frame.size.height);
    
    [self setupSubViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.currentVideoModel != nil)
    {
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:[self.videoList indexOfObject:self.currentVideoModel] inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionNone animated:NO];
        
        //        CGFloat contentOffsetX = [self.videoList indexOfObject:self.currentVideoModel] * self.tableView.frame.size.width;
        //        CGPoint offset = CGPointMake(0, contentOffsetX);
        //        [self.tableView setContentOffset:offset animated:NO];
    }
    
    self.currentVideoModel = nil;
    
    self.commonVideoPlayerVC.delegate = self;
    
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)setupSubViews
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, AndyMainScreenSize.width, AndyMainScreenSize.height) style:UITableViewStylePlain];
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate  = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.pagingEnabled = YES;
    
    //self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.tableView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    
    self.tableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    
    self.tableView.frame = CGRectMake(0, 64, AndyMainScreenSize.width , AndyMainScreenSize.height);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.videoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AndyFavoriteVideoDetailViewCell *cell = [AndyFavoriteVideoDetailViewCell cellWithTableView:tableView];
    
    AndyVideoListBaseModel *detailModel = self.videoList[indexPath.row];
    
    cell.favoriteButton.selected = detailModel.isAlreadyFavorite;
    
    cell.downloadButton.selected = detailModel.isAlreadyDownload;
    
    cell.videoModel = detailModel;
    
    AndyLog(@"%d", cell.favoriteButton.selected);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIScreen mainScreen].bounds.size.width;
}

- (void)moviePlayerDidFinished
{
    if (self.commonVideoPlayerVC != nil)
    {
        [self dismissViewControllerAnimated:NO completion:nil];
        self.commonVideoPlayerVC = nil;
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

//-(void)viewDidLoad
//{
//    [super viewDidLoad];
//    [self setupSubViews];
//
//    self.commonVideoPlayerVC.delegate = self;
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//
//    if (self.currentVideoModel != nil)
//    {
//        [self setupData];
//    }
//}
//
//- (void)setupSubViews
//{
//    UIScrollView *scrollView = [[UIScrollView alloc] init];
//    scrollView.frame = self.view.bounds;
//    self.scrollView = scrollView;
//    [self.view addSubview:self.scrollView];
//}
//
//- (void)setupData
//{
////    CGFloat videoDetailW = self.scrollView.frame.size.width;
////    CGFloat videoDetailH = self.scrollView.frame.size.height;
////    CGFloat videoDetailY = 0;
////
////    for (int i = 0; i < self.videoList.count; i++)
////    {
////        CGFloat videoDetailX = i * videoDetailW;
////
////        AndyVideoDetailView *videoDetailView = [[AndyVideoDetailView alloc] init];
////
////        videoDetailView.frame = CGRectMake(videoDetailX, videoDetailY, videoDetailW, videoDetailH);
////
////        AndyVideoListBaseModel *videoModel = (AndyVideoListBaseModel *)[self.videoList objectAtIndex:i];
////
////        videoDetailView.videoModel = videoModel;
////
////        [self.scrollView addSubview:videoDetailView];
////    }
//
//    //CGFloat contentW = self.videoList.count * videoDetailW;
//
//    //self.scrollView.contentSize = CGSizeMake(contentW, 0);
//
//    self.scrollView.showsHorizontalScrollIndicator = NO;
//
//    self.scrollView.pagingEnabled = YES;
//
//    if (self.currentVideoModel != nil)
//    {
//        CGFloat contentOffsetX = [self.videoList indexOfObject:self.currentVideoModel] * self.scrollView.frame.size.width;
//        CGPoint offset = CGPointMake(contentOffsetX, 0);
//        [self.scrollView setContentOffset:offset animated:NO];
//    }
//
//    self.currentVideoModel = nil;
//
//}
//
//- (void)moviePlayerDidFinished
//{
//    if (self.commonVideoPlayerVC != nil)
//    {
//        [self dismissViewControllerAnimated:NO completion:nil];
//        self.commonVideoPlayerVC = nil;
//    }
//}

@end

