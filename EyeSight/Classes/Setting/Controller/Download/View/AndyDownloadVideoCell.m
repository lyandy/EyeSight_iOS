//
//  AndyDownloadVideoCell.m
//  EyeSight
//
//  Created by 李扬 on 15/11/30.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyDownloadVideoCell.h"
#import "AndyCommonVideoFrame.h"
#import "AndyVideoListBaseModel.h"
#import "UIImageView+WebCache.h"
#import "AndyTabBarViewController.h"
#import "AndyDailyTableViewController.h"
#import "AndyNavigationController.h"
#import "AndyDownloadVideoDetailViewController.h"
#import "AndyFavoriteTableViewController.h"
#import "AndyDownloadTableViewController.h"
#import "AndyVideoAlbumScrollTool.h"

@interface AndyDownloadVideoCell ()<AndyVideoAlbumScrollCallBackDelegate>

@property (nonatomic, weak) UIImageView *bgView;

@property (nonatomic, weak) UIView *coverView;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UILabel *categoryAndDurationLabel;

@property (nonatomic, weak) UIButton *editButton;

@end

@implementation AndyDownloadVideoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *Id = @"videoDownloadCell";
    AndyDownloadVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (cell == nil)
    {
        cell = [[AndyDownloadVideoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Id];
    }
    cell.bgView.alpha = 0.0;
    cell.coverView.alpha = 1.0;
    
    //cell.contentView.backgroundColor = [UIColor redColor];
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.delegate = self;
        
        [self setupSubViews];
    }
    return self;
}

- (void)cellViewDidHolding:(AndyCommonVideoBaseCell *)andyCommonVideoBaseCell
{
    if (self.commonVideoFrame.videoListBaseModel.isEditing == NO)
    {
        [UIView animateWithDuration:0.2 animations:^{
            self.coverView.alpha = 0;
        }];
    }
    else
    {
        self.coverView.alpha = 1.0;
    }
}

- (void)cellViewDidReleaseHolding:(AndyCommonVideoBaseCell *)andyCommonVideoBaseCell
{
    if (self.commonVideoFrame.videoListBaseModel.isEditing == NO)
    {
        [UIView animateWithDuration:0.2 animations:^{
            self.coverView.alpha = 1;
        } completion:^(BOOL finished) {
            
            AndyVideoAlbumScrollTool *videoAlbumScrollTool = [AndyVideoAlbumScrollTool sharedVideoAlbumScrollTool];
            
            videoAlbumScrollTool.videoAlbumScrollCallBack = self.commonVideoFrame.videoListBaseModel.videoAlbumScrollCallBack;
        }];
    }
    else
    {
        self.coverView.alpha = 1.0;
    }
}

- (void)cellViewNeedNavigate:(AndyCommonVideoBaseCell *)andyCommonVideoBaseCell
{
    if (self.commonVideoFrame.videoListBaseModel.isEditing == NO)
    {
        AndyLog(@"我要跳转了");
        
        AndyDownloadVideoDetailViewController *commonVideoDetailVC = [[AndyDownloadVideoDetailViewController alloc] init];
        commonVideoDetailVC.title = @"详情";
        commonVideoDetailVC.view.backgroundColor = [UIColor whiteColor];
        
        AndyCommonTableViewController *uivc = (AndyCommonTableViewController *)[AndyCommonFunction getCurrentPerformanceUIViewContorller];
        
        //传递数据
        commonVideoDetailVC.videoList = uivc.videoList;
        
        commonVideoDetailVC.currentVideoModel = self.commonVideoFrame.videoListBaseModel;
        
        if (uivc != nil)
        {
            [uivc.navigationController pushViewController:commonVideoDetailVC animated:YES];
        }
    }
    else
    {
        self.coverView.alpha = 1.0;
    }
}

- (void)setupSubViews
{
    UIImageView *bgView = [[UIImageView alloc] init];
    [self.contentView addSubview:bgView];
    bgView.alpha = 0.0;
    self.bgView = bgView;
    
    UIView *coverView = [[UIView alloc] init];
    coverView.backgroundColor = AndyColor(0, 0, 0, 0.3);
    [self.contentView addSubview:coverView];
    self.coverView = coverView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [self.coverView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *categoryAndDurationLabel = [[UILabel alloc] init];
    [self.coverView addSubview:categoryAndDurationLabel];
    self.categoryAndDurationLabel = categoryAndDurationLabel;
    
    UIButton *editButton = [[UIButton alloc] init];
    [editButton setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    editButton.alpha = 0.0;
    self.editButton = editButton;
    [self.contentView addSubview:self.editButton];
}

- (void)videoAlbumDidScroll
{
    self.coverView.alpha = 1.0;
    
    AndyLog(@"我被调用了");
}

- (void)setCommonVideoFrame:(AndyCommonVideoFrame *)commonVideoFrame
{
    _commonVideoFrame = commonVideoFrame;
    
    AndyVideoListBaseModel *videoListBaseModel = self.commonVideoFrame.videoListBaseModel;
    
    self.commonVideoFrame.videoListBaseModel.videoAlbumScrollCallBack.delagete = self;
    
    [self.bgView setImageWithURL:[NSURL URLWithString:videoListBaseModel.coverForDetail] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        [UIView animateWithDuration:0.3 animations:^{
            self.bgView.alpha = 1.0;
        }];
    }];
    
    //[self.bgView setImageWithURL:[NSURL URLWithString:videoListBaseModel.coverForDetail] placeholderImage:nil];
    self.bgView.frame = self.commonVideoFrame.bgViewF;
    
    self.coverView.frame = self.commonVideoFrame.coverViewF;
    
    self.titleLabel.text = videoListBaseModel.title;
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    self.titleLabel.font = AndyVideoListBaseModelTitleFont;
    self.titleLabel.frame = self.commonVideoFrame.titleLabelF;
    
    self.categoryAndDurationLabel.text = [NSString stringWithFormat:@"#%@  /  %@", videoListBaseModel.category, videoListBaseModel.videoDurtion];
    [self.categoryAndDurationLabel setTextColor:[UIColor whiteColor]];
    self.categoryAndDurationLabel.font = AndyVideoListBaseModelCategoryAndDurationFont;
    self.categoryAndDurationLabel.frame = self.commonVideoFrame.categoryAndDurationLabelF;
    
    CGSize editButtonSize = self.editButton.currentBackgroundImage.size;
    CGFloat editBUttonX = (AndyMainScreenSize.width - editButtonSize.width) / 2;
    CGFloat editButtonY = self.commonVideoFrame.cellHeight - 60;
    self.editButton.frame = (CGRect){{editBUttonX, editButtonY}, {editButtonSize.width * 1.4, editButtonSize.height * 1.4}};
    
    //以下两段代码组合起来就能完成“我的下载”和“我的收藏”编辑的时候不闪一下就能直接编辑的效果
    if (videoListBaseModel.isEditing)
    {
        self.editButton.alpha = 1.0;
        [self.editButton addTarget:self action:@selector(removeItemAndCell) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        self.editButton.alpha = 0.0;
        [self.editButton removeTarget:self action:@selector(removeItemAndCell) forControlEvents:UIControlEventTouchUpInside];
    }
    
    videoListBaseModel.editOption = ^(BOOL isEdit)
    {
        if (isEdit == YES)
        {
            self.editButton.alpha = 1.0;
            [self.editButton addTarget:self action:@selector(removeItemAndCell) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            self.editButton.alpha = 0.0;
            [self.editButton removeTarget:self action:@selector(removeItemAndCell) forControlEvents:UIControlEventTouchUpInside];
        }
    };
}

- (void)removeItemAndCell
{
    AndyVideoListBaseModel *videoModel = self.commonVideoFrame.videoListBaseModel;
    
    [AndyFMDBTool deleteBySingle:videoModel isFavorite:NO  success:^{
        
        //删除视频文件
        NSString *videoDownloadLocalPath = [AndyCommonFunction getVideoDownloadLocalPath:videoModel];
        if (videoDownloadLocalPath != nil)
        {
            [AndyCommonFunction deleteDownloadVideo:videoDownloadLocalPath];
        }
        
        AndyDownloadTableViewController *downloadVc = (AndyDownloadTableViewController *)[AndyCommonFunction getCurrentPerformanceUIViewContorller];
        
        AndyLog(@"%lu", (unsigned long)downloadVc.videoListFrame.count);
        
        NSInteger downloadIndex = [downloadVc.videoListFrame indexOfObject:self.commonVideoFrame];
        NSIndexPath *downloadIndexPath = [NSIndexPath indexPathForRow:downloadIndex inSection:0];
        
        [downloadVc.videoListFrame removeObjectAtIndex:downloadIndex];
        [downloadVc.tableView deleteRowsAtIndexPaths:@[downloadIndexPath] withRowAnimation:UITableViewRowAnimationTop];
        
        AndyLog(@"%lu", (unsigned long)downloadVc.videoListFrame.count);
        
        [downloadVc.videoList removeObjectAtIndex:downloadIndex];
        

        [XAppDelegate.favoriteVideoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.videoId == videoModel.videoId)
            {
                obj.isAlreadyDownload = NO;
            }
            }];
        
        
        [XAppDelegate.dailyTableViewController.videoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.videoId == videoModel.videoId)
            {
                obj.isAlreadyDownload = NO;
            }
        }];
        
        [XAppDelegate.rankWeekTableViewController.videoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.videoId == videoModel.videoId)
            {
                obj.isAlreadyDownload = NO;
            }
        }];
        
        
        [XAppDelegate.rankMonthTableViewController.videoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.videoId == videoModel.videoId)
            {
                obj.isAlreadyDownload = NO;
            }
            
        }];
        
        [XAppDelegate.rankAllTableViewController.videoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.videoId == videoModel.videoId)
            {
                obj.isAlreadyDownload = NO;
            }
        }];
        
    } failure:^{
        
    }];
    
}

@end

