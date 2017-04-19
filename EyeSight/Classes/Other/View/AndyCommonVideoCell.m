//
//  AndyCommonVideoCell.m
//  EyeSight
//
//  Created by 李扬 on 15/10/22.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyCommonVideoCell.h"
#import "AndyCommonVideoFrame.h"
#import "AndyVideoListBaseModel.h"
#import "UIImageView+WebCache.h"
#import "AndyTabBarViewController.h"
#import "AndyDailyTableViewController.h"
#import "AndyNavigationController.h"
#import "AndyCommonVideoDetailViewController.h"
#import "AndyFavoriteTableViewController.h"
#import "AndyDownloadTableViewController.h"
#import "AndyPastTimeDetailTableViewController.h"
#import "AndyPastShareDetailTableViewController.h"
#import "AndyVideoAlbumScrollTool.h"
#import "AndyCampaignViewController.h"

@interface AndyCommonVideoCell ()<AndyVideoAlbumScrollCallBackDelegate>

@property (nonatomic, weak) UIImageView *bgView;

@property (nonatomic, weak) UIView *coverView;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UILabel *categoryAndDurationLabel;

@property (nonatomic, weak) UIButton *editButton;

@property (nonatomic, assign) BOOL isCampaign;

@end

@implementation AndyCommonVideoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *Id = @"videoCell";
    AndyCommonVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (cell == nil)
    {
        cell = [[AndyCommonVideoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Id];
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

- (void)myHolding
{
    [super myNavigate];
    AndyLog(@"myHolding");
}

- (void)myRelease
{
    [super myRelease];
    AndyLog(@"myRelease");
}

- (void)myNavigate
{
    [super myNavigate];
    AndyLog(@"myNaviagte");
}

- (void)cellViewDidHolding:(AndyCommonVideoBaseCell *)andyCommonVideoBaseCell
{
    [UIView animateWithDuration:0.2 animations:^{
        if (self.isCampaign)
        {
            self.coverView.alpha = 1.0;
        }
        else
        {
            self.coverView.alpha = 0.0;
        }
    }];
}

- (void)cellViewDidReleaseHolding:(AndyCommonVideoBaseCell *)andyCommonVideoBaseCell
{
    [UIView animateWithDuration:0.2 animations:^{
        if (self.isCampaign)
        {
            self.coverView.alpha = 0.0;
        }
        else
        {
            self.coverView.alpha = 1.0;
        }
    } completion:^(BOOL finished) {
        
        AndyVideoAlbumScrollTool *videoAlbumScrollTool = [AndyVideoAlbumScrollTool sharedVideoAlbumScrollTool];
        
        videoAlbumScrollTool.videoAlbumScrollCallBack = self.commonVideoFrame.videoListBaseModel.videoAlbumScrollCallBack;
        
    }];
}

- (void)cellViewNeedNavigate:(AndyCommonVideoBaseCell *)andyCommonVideoBaseCell
{
    AndyLog(@"我要跳转了");
    
    AndyCommonTableViewController *uivc = (AndyCommonTableViewController *)[AndyCommonFunction getCurrentPerformanceUIViewContorller];
    
    if (self.isCampaign)
    {
        if ([AndyCommonFunction isNetworkConnected])
        {
            AndyCampaignViewController *campVC = [[AndyCampaignViewController alloc] init];
            campVC.url = self.commonVideoFrame.videoListBaseModel.webUrl;
            AndyNavigationController *nav = [[AndyNavigationController alloc] initWithRootViewController:campVC];
            if (uivc != nil)
            {
                [uivc presentViewController:nav animated:YES completion:nil];
            }
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"网络提示" message:@"网络已断开，请检查您的网络连接。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    else
    {
        AndyCommonVideoDetailViewController *commonVideoDetailVC = [[AndyCommonVideoDetailViewController alloc] init];
        commonVideoDetailVC.title = @"详情";
        commonVideoDetailVC.view.backgroundColor = [UIColor whiteColor];
        
        //传递数据
        commonVideoDetailVC.videoList = uivc.videoList;
        
        commonVideoDetailVC.currentVideoModel = self.commonVideoFrame.videoListBaseModel;
        
        if (uivc != nil)
        {
            [uivc.navigationController pushViewController:commonVideoDetailVC animated:YES];
        }
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
    if (self.isCampaign)
    {
        self.coverView.alpha = 0.0;
    }
    else
    {
        self.coverView.alpha = 1.0;
    }
    
    AndyLog(@"我被调用了");
}

- (void)setCommonVideoFrame:(AndyCommonVideoFrame *)commonVideoFrame
{
    _commonVideoFrame = commonVideoFrame;
    
    if (self.isCampaign)
    {
        self.coverView.alpha = 0.0;
    }
    else
    {
        self.coverView.alpha = 1.0;
    }
    
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
    
    if (self.isCampaign)
    {
        self.categoryAndDurationLabel.text = nil;
    }
    else
    {
        self.categoryAndDurationLabel.text = [NSString stringWithFormat:@"#%@  /  %@", videoListBaseModel.category, videoListBaseModel.videoDurtion];
    }
    
    [self.categoryAndDurationLabel setTextColor:[UIColor whiteColor]];
    self.categoryAndDurationLabel.font = AndyVideoListBaseModelCategoryAndDurationFont;
    self.categoryAndDurationLabel.frame = self.commonVideoFrame.categoryAndDurationLabelF;
    
    CGSize editButtonSize = self.editButton.currentBackgroundImage.size;
    CGFloat editBUttonX = (AndyMainScreenSize.width - editButtonSize.width) / 2;
    CGFloat editButtonY = self.commonVideoFrame.cellHeight - 60;
    self.editButton.frame = (CGRect){{editBUttonX, editButtonY}, {editButtonSize.width * 1.4, editButtonSize.height * 1.4}};
}

- (BOOL)isCampaign
{
    if (self.commonVideoFrame != nil)
    {
        AndyVideoListBaseModel *model = self.commonVideoFrame.videoListBaseModel;
        if (model.duration == 0 && model.category == nil)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return NO;
    }
}

@end
