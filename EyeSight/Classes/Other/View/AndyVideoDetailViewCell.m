//
//  AndyVideoDetailView.m
//  EyeSight
//
//  Created by 李扬 on 15/11/4.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyVideoDetailViewCell.h"
#import "AndyCommonVideoBaseCell.h"
#import "UIImageView+WebCache.h"
#import "AndyVideoDetailTopUIImageView.h"
#import "NSString+Andy.h"
#import "AndyVideoDetailPlayUIView.h"
#import "AndyVideoDetailTopImageCoverUIView.h"
#import "AndyVideoDetailOperateButton.h"
#import "AndyDownloadModel.h"
#import "AndyDownloadCallBack.h"
#import "AndyDownloadModel.h"
#import "AndyShareView+Andy.h"
#import "AndyPastDetailViewController.h"
#import "AndyPastTimeDetailTableViewController.h"
#import "AndyPastShareDetailTableViewController.h"

#define LeftMargin 10

@interface AndyVideoDetailViewCell ()<AndyDownloadCallBackDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) AndyVideoDetailTopUIImageView *topImageView;

@property(nonatomic, strong) AndyVideoDetailPlayUIView *playUIView;

@property (nonatomic, strong) AndyVideoDetailTopImageCoverUIView *topImageCoverView;

@property (nonatomic, weak) UIImageView *bottomImageView;

@property (nonatomic, weak) UIView *bottomImageCoverUIView;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UIView *lineView;

@property (nonatomic, weak) UILabel *categoryAndDurationLabel;

@property (nonatomic, weak) UILabel *descriptionLabel;

@property (nonatomic, weak) AndyVideoDetailOperateButton *shareButton;

@end

@implementation AndyVideoDetailViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *Id = @"videoDetailCell";
    AndyVideoDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    
    if (cell == nil)
    {
        cell = [[AndyVideoDetailViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Id];
    }
    
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    //因为topImageView有放大动画，需要设定cell边框剪切，不然放大的图片会超出屏幕
    cell.clipsToBounds = YES;
    //设为灰色消除白色闪屏
    cell.contentView.backgroundColor = [UIColor grayColor];
    
    cell.topImageView.alpha = 0.0;
    
    return cell;
}

- (void)downloadProgress:(unsigned long)value downloadId:(NSInteger)downloadId
{
    if (self.videoModel.isDownloading && self.videoModel.videoId == downloadId)
    {
        self.downloadButton.titleLabel.text = [NSString stringWithFormat:@"%lu%%", value];
    }
}

- (void)downloadCompleteWithDownloadId:(NSInteger)downloadId
{
    self.videoModel.downloadCallBack.delegate = nil;
    [AndyFMDBTool insertBySingle:self.videoModel isFavorite:NO success:^{
        
        self.downloadButton.selected = YES;
        
        self.videoModel.isAlreadyDownload = true;
        self.videoModel.isDownloading = false;
        
        self.downloadButton.titleLabel.text = @"已下载";
        self.downloadButton.imageView.image = [UIImage imageNamed:@"AlreadyDownload"];
        
        AndyLog(@"下载移除前个数：%lu", [AndyDownloadTool sharedDownloadTool].downloadArrayM.count);
        
        [self removeDownloadModel];
        
        AndyLog(@"下载移除后个数：%lu", [AndyDownloadTool sharedDownloadTool].downloadArrayM.count);

        //寻找收藏的集合里面有没有当前要下载的videoModel，以便在展示收藏的时候能够正确展示
        [XAppDelegate.favoriteVideoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.videoId == downloadId)
            {
                obj.isEditing = NO;
                obj.isDownloading = false;
                obj.isAlreadyDownload = true;
                self.videoModel.isAlreadyFavorite = YES;
                *stop = true;
            }
        }];
        
        //将下载的实体Model加入到下载的集合中 上中下顺序不可调换
        [XAppDelegate.downloadVideoList addObject:self.videoModel];
        
        [XAppDelegate.categoryTimeVideoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.videoId == self.videoModel.videoId)
            {
                obj.isDownloading = false;
                obj.isAlreadyDownload = true;
                *stop = YES;
            }
        }];
        
        [XAppDelegate.categoryShareVideoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.videoId == self.videoModel.videoId)
            {
                obj.isDownloading = false;
                obj.isAlreadyDownload = true;
                *stop = YES;
            }
        }];
        
        //接下来寻找可能已经加载到界面上的数据集合的情况
        [XAppDelegate.dailyTableViewController.videoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.videoId == downloadId)
            {
                obj.isDownloading = false;
                obj.isAlreadyDownload = true;
                *stop = YES;
            }
        }];
        
        [XAppDelegate.rankWeekTableViewController.videoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.videoId == downloadId)
            {
                obj.isDownloading = false;
                obj.isAlreadyDownload = true;
                *stop = YES;
            }
        }];
        
        [XAppDelegate.rankMonthTableViewController.videoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.videoId == downloadId)
            {
                obj.isDownloading = false;
                obj.isAlreadyDownload = true;
                *stop = YES;
            }
        }];
        
        [XAppDelegate.rankAllTableViewController.videoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.videoId == downloadId)
            {
                obj.isDownloading = false;
                obj.isAlreadyDownload = true;
                *stop = YES;
            }
        }];
    } failure:^{
        [self downloadErrorWithDownloadId:downloadId];
    }];
}

- (void)downloadErrorWithDownloadId:(NSInteger)downloadId
{
    AndyLog(@"下载出错");
    
    self.downloadButton.selected = NO;
    
    self.videoModel.isAlreadyDownload = false;
    self.videoModel.isDownloading = false;
    
    self.downloadButton.titleLabel.text = @"下载出错";
    self.downloadButton.imageView.image = [UIImage imageNamed:@"Download"];
    
    [self removeDownloadModel];
    
    //删除视频文件
    NSString *videoDownloadLocalPath = [AndyCommonFunction getVideoDownloadLocalPath:self.videoModel];
    if (videoDownloadLocalPath != nil)
    {
        [AndyCommonFunction deleteDownloadVideo:videoDownloadLocalPath];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setupSubViews];
    }
    return self;
}


- (void)setupSubViews
{
    AndyVideoDetailTopUIImageView *topImageView = [[AndyVideoDetailTopUIImageView alloc] init];
    topImageView.contentMode = UIViewContentModeScaleAspectFill;
    topImageView.alpha = 0.0;
    self.topImageView = topImageView;
    [self.contentView addSubview:self.topImageView];
    
    AndyVideoDetailTopImageCoverUIView *topImageCoverView = [[AndyVideoDetailTopImageCoverUIView alloc] init];
    topImageCoverView.backgroundColor = [UIColor clearColor];
    self.topImageCoverView = topImageCoverView;
    [self.contentView addSubview:topImageCoverView];
    
    AndyVideoDetailPlayUIView *playUIView = [[AndyVideoDetailPlayUIView alloc] init];
    playUIView.backgroundColor = [UIColor clearColor];
    self.playUIView = playUIView;
    [self.contentView addSubview:playUIView];
    
    UIImageView *bottomImageView = [[UIImageView alloc] init];
    bottomImageView.contentMode = UIViewContentModeScaleAspectFill;
    bottomImageView.clipsToBounds = YES;
    bottomImageView.userInteractionEnabled = true;
    self.bottomImageView = bottomImageView;
    [self.contentView addSubview:self.bottomImageView];
    
    UIView *bottomImageCoverUIView = [[UIView alloc] init];
    bottomImageCoverUIView.backgroundColor = AndyColor(0, 0, 0, 0.35);
    self.bottomImageCoverUIView = bottomImageCoverUIView;
    [self.bottomImageView addSubview:self.bottomImageCoverUIView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font =AndyVideoDetailViewTitleFont;
    titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel = titleLabel;
    [self.bottomImageView addSubview:self.titleLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = AndyColor(255, 255, 255, 0.95);
    self.lineView = lineView;
    [self.bottomImageView addSubview:self.lineView];
    
    UILabel *categoryAndDurationLabel = [[UILabel alloc] init];
    categoryAndDurationLabel.font = AndyVideoListBaseModelCategoryAndDurationFont;
    categoryAndDurationLabel.textColor = AndyColor(255, 255, 255, 0.95);
    self.categoryAndDurationLabel = categoryAndDurationLabel;
    [self.bottomImageView addSubview:categoryAndDurationLabel];
    
    UILabel *descriptionLabel = [[UILabel alloc] init];
    descriptionLabel.font = AndyVideoDetailViewDescriptionFont;
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.textColor = AndyColor(255, 255, 255, 0.9);
    self.descriptionLabel = descriptionLabel;
    [self.bottomImageView addSubview:self.descriptionLabel];
    
    AndyVideoDetailOperateButton *shareButton = [[AndyVideoDetailOperateButton alloc] init];
    shareButton.titleLabel.font = AndyVideoDetailViewCategoryAndDurationFont;
    [shareButton setImage:[UIImage imageNamed:@"Share"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonClikc:) forControlEvents:UIControlEventTouchUpInside];
    self.shareButton = shareButton;
    [self.bottomImageView addSubview:self.shareButton];
    
    AndyVideoDetailOperateButton *favoriteButton = [[AndyVideoDetailOperateButton alloc] init];
    favoriteButton.titleLabel.font = AndyVideoDetailViewCategoryAndDurationFont;
    [favoriteButton setTitle:@"收藏" forState:UIControlStateNormal];
    [favoriteButton setTitle:@"已收藏" forState:UIControlStateSelected];
    [favoriteButton setImage:[UIImage imageNamed:@"Favorite"] forState:UIControlStateNormal];
    [favoriteButton setImage:[UIImage imageNamed:@"AlreadyFavorite"] forState:UIControlStateSelected];
    [favoriteButton addTarget:self action:@selector(favoriteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.favoriteButton = favoriteButton;
    [self.bottomImageView addSubview:self.favoriteButton];
    
    AndyVideoDetailOperateButton *downloadButton = [[AndyVideoDetailOperateButton alloc] init];
    downloadButton.titleLabel.font = AndyVideoDetailViewCategoryAndDurationFont;
    [downloadButton setTitle:@"下载" forState:UIControlStateNormal];
    [downloadButton setTitle:@"已下载" forState:UIControlStateSelected];
    [downloadButton setImage:[UIImage imageNamed:@"Download"] forState:UIControlStateNormal];
    [downloadButton setImage:[UIImage imageNamed:@"AlreadyDownload"] forState:UIControlStateSelected];
    [downloadButton addTarget:self action:@selector(downloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.downloadButton = downloadButton;
    [self.bottomImageView addSubview:self.downloadButton];
}

- (void)setVideoModel:(AndyVideoListBaseModel *)videoModel
{
    _videoModel = videoModel;
    
    videoModel.downloadCallBack.delegate = self;
    
    CGFloat bottomImageViewHeight = AndyMainScreenSize.height * 0.45;
    if (bottomImageViewHeight < 256)
    {
        bottomImageViewHeight = 256;
    }
    
    CGFloat bottomImageViewH = bottomImageViewHeight;
    CGFloat bottomImageViewW = AndyMainScreenSize.width;

    CGFloat topImageViewX = 0;
    CGFloat topImageViewY = 0;

    CGFloat topImageViewW = bottomImageViewW;
    CGFloat topImageViewH = AndyMainScreenSize.height - bottomImageViewH;
    self.topImageView.frame = CGRectMake(topImageViewX, topImageViewY, topImageViewW, topImageViewH);
    self.topImageView.imageUrl = [NSString stringWithFormat:@"%@", videoModel.coverForDetail];
    
    self.topImageCoverView.videoModel = videoModel;
    self.topImageCoverView.frame = self.topImageView.frame;
    
    CGFloat playUIViewW = 65;
    CGFloat playUIViewH = playUIViewW;
    CGFloat playUIViewX = (self.topImageCoverView.frame.size.width - playUIViewW) / 2;
    CGFloat playUIViewY = (self.topImageCoverView.frame.size.height - playUIViewH) / 2;
    self.playUIView.frame = CGRectMake(playUIViewX, playUIViewY, playUIViewW, playUIViewH);
    [self.topImageCoverView addSubview:self.playUIView];
    
    CGFloat bottomImageViewX = 0;
    CGFloat bottomImageViewY = CGRectGetMaxY(self.topImageView.frame);
    [self.bottomImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", videoModel.coverBlurred]]];
    self.bottomImageView.frame = CGRectMake(bottomImageViewX, bottomImageViewY, bottomImageViewW, bottomImageViewH);
    
    self.bottomImageCoverUIView.frame = self.bottomImageView.bounds;
    
    self.titleLabel.text = videoModel.title;
    CGFloat titleLabelX = LeftMargin;
    CGFloat titleLabelY = LeftMargin;
    NSMutableDictionary *titleLabelMD = [NSMutableDictionary dictionary];
    titleLabelMD[NSFontAttributeName] = AndyVideoDetailViewTitleFont;
    CGSize titleLabelSize = [self.titleLabel.text sizeWithAttributes:titleLabelMD];
    self.titleLabel.frame = (CGRect){{titleLabelX, titleLabelY}, titleLabelSize};
    
    CGFloat lineViewX = LeftMargin;
    CGFloat lineViewY = CGRectGetMaxY(self.titleLabel.frame) + LeftMargin;
    CGFloat lineViewW = [UIScreen mainScreen].bounds.size.width - 2 * LeftMargin;
    CGFloat lineViewH = 0.5;
    self.lineView.frame = CGRectMake(lineViewX, lineViewY, lineViewW, lineViewH);
    
    self.categoryAndDurationLabel.text = [NSString stringWithFormat:@"#%@  /  %@", videoModel.category, videoModel.videoDurtion];
    CGFloat categoryAndDurationLabelX = LeftMargin;
    CGFloat categoryAndDurationLabelY = CGRectGetMaxY(self.lineView.frame) + LeftMargin;
    NSMutableDictionary *categoryAndDurationLabelMD = [NSMutableDictionary dictionary];
    categoryAndDurationLabelMD[NSFontAttributeName] = AndyVideoDetailViewCategoryAndDurationFont;
    CGSize categoryAndDurationLabelSize = [self.categoryAndDurationLabel.text sizeWithAttributes:categoryAndDurationLabelMD];
    self.categoryAndDurationLabel.frame = (CGRect){{categoryAndDurationLabelX, categoryAndDurationLabelY}, categoryAndDurationLabelSize};
    
    self.descriptionLabel.text = videoModel.videoDescription;
    CGFloat descriptionLabelX = LeftMargin;
    CGFloat descriptionLabelY =CGRectGetMaxY(self.categoryAndDurationLabel.frame) + LeftMargin;
//    NSMutableDictionary *descriptionMD = [NSMutableDictionary dictionary];
//    descriptionMD[NSFontAttributeName] = AndyVideoDetailViewDescriptionFont;
//    CGSize descriptionLabelSize = [self.descriptionLabel sizeThatFits:CGSizeMake(self.bounds.size.width - 2 * LeftMargin, 10)];
//    self.descriptionLabel.frame = (CGRect){{descriptionLabelX, descriptionLabelY}, descriptionLabelSize};
    
    // 文字计算的最大尺寸 -- MJ方法
    CGSize textMaxSize = CGSizeMake(AndyMainScreenSize.width - 2 * LeftMargin, MAXFLOAT);
    // 文字计算出来的真实尺寸(按钮内部label的尺寸)
    CGSize textRealSize = [self.descriptionLabel.text sizeWithFont:AndyVideoDetailViewDescriptionFont maxSize:textMaxSize];
    self.descriptionLabel.frame = (CGRect){{descriptionLabelX, descriptionLabelY}, textRealSize};
    
    CGFloat operateButtonY = self.bottomImageView.frame.size.height - 100;
    CGFloat operateButtonW = 50;
    CGFloat operateButtonH = 25;
    
    CGFloat operateShareButtonX = LeftMargin;
    [self.shareButton setTitle:@"分享" forState:UIControlStateNormal];
    self.shareButton.frame = CGRectMake(operateShareButtonX, operateButtonY, operateButtonW, operateButtonH);
    

    CGFloat operateFavoriteButtonX = CGRectGetMaxX(self.shareButton.frame) + 3 * LeftMargin ;
    self.favoriteButton.frame = CGRectMake(operateFavoriteButtonX, operateButtonY, operateButtonW, operateButtonH);
    
    CGFloat operateDownloadButtonX =  CGRectGetMaxX(self.favoriteButton.frame) + 3 * LeftMargin;
    self.downloadButton.frame = CGRectMake(operateDownloadButtonX, operateButtonY, operateButtonW, operateButtonH);
    
    AndyLog(@"我哈哈哈%d", videoModel.isAlreadyDownload);
    
    if (videoModel.isAlreadyDownload == YES)
    {
        self.downloadButton.titleLabel.text = @"已下载";
        self.downloadButton.imageView.image = [UIImage imageNamed:@"AlreadyDownload"];
    }
    else
    {
        if (videoModel.isDownloading)
        {
            self.downloadButton.titleLabel.text = @"正在下载";
            self.downloadButton.imageView.image = [UIImage imageNamed:@"Download"];
            [self combineDownloadData];
        }
        else
        {
            self.downloadButton.titleLabel.text = @"下载";
            self.downloadButton.imageView.image = [UIImage imageNamed:@"Download"];
        }
    }
}

- (void)shareButtonClikc:(AndyVideoDetailOperateButton *)button
{
    [AndyShareView showShareViewWithVideoModel:self.videoModel];
}

- (void)favoriteButtonClick:(AndyVideoDetailOperateButton *)button
{
    if (button.selected == NO)
    {
        [AndyFMDBTool insertBySingle:self.videoModel isFavorite:YES success:^{
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            BOOL isFavoriteAndDownload = [defaults boolForKey:SettingFavoriteKey];
            if (isFavoriteAndDownload)
            {
                [self downloadButtonClick:self.downloadButton];
            }
            
            button.selected = YES;
            
            self.videoModel.isAlreadyFavorite = YES;
            
            [XAppDelegate.favoriteVideoList addObject:self.videoModel];

            [XAppDelegate.categoryTimeVideoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.videoId == self.videoModel.videoId)
                {
                    obj.isAlreadyFavorite = true;
                    *stop = YES;
                }
            }];
            
            [XAppDelegate.categoryShareVideoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.videoId == self.videoModel.videoId)
                {
                    obj.isAlreadyFavorite = true;
                    *stop = YES;
                }
            }];
            
            [XAppDelegate.downloadVideoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.videoId == self.videoModel.videoId)
                {
                    obj.isAlreadyFavorite = true;
                    *stop = YES;
                }
            }];
            
            [XAppDelegate.dailyTableViewController.videoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.videoId == self.videoModel.videoId)
                {
                    obj.isAlreadyFavorite = true;
                    *stop = YES;
                }
            }];

            [XAppDelegate.rankWeekTableViewController.videoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.videoId == self.videoModel.videoId)
                {
                    obj.isAlreadyFavorite = true;
                    *stop = YES;
                }
            }];
            
            [XAppDelegate.rankMonthTableViewController.videoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.videoId == self.videoModel.videoId)
                {
                    obj.isAlreadyFavorite = true;
                    *stop = YES;
                }
            }];
            
            [XAppDelegate.rankAllTableViewController.videoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.videoId == self.videoModel.videoId)
                {
                    obj.isAlreadyFavorite = true;
                    *stop = YES;
                }
            }];
            
            
        } failure:^{
        
        }];
    }
    else
    {
        [AndyFMDBTool deleteBySingle:self.videoModel isFavorite:YES  success:^{
            button.selected = NO;
            
            __block AndyVideoListBaseModel *favoriteModel = nil;
            [XAppDelegate.favoriteVideoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.videoId == self.videoModel.videoId)
                {
                    favoriteModel = obj;
                    *stop = YES;
                }
            }];
            if (favoriteModel != nil)
            {
                [XAppDelegate.favoriteVideoList removeObject:favoriteModel];
                AndyLog(@"favoriteModel已找到，移除");
            }
            

            [XAppDelegate.categoryTimeVideoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.videoId == self.videoModel.videoId)
                {
                    obj.isAlreadyFavorite = NO;
                    *stop = YES;
                }
            }];
            
            [XAppDelegate.categoryShareVideoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.videoId == self.videoModel.videoId)
                {
                    obj.isAlreadyFavorite = NO;
                    *stop = YES;
                }
            }];

            
            [XAppDelegate.downloadVideoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.videoId == self.videoModel.videoId)
                {
                    obj.isAlreadyFavorite = NO;
                    *stop = YES;
                }
            }];
            
            [XAppDelegate.dailyTableViewController.videoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.videoId == self.videoModel.videoId)
                {
                    obj.isAlreadyFavorite = NO;
                    *stop = YES;
                }
            }];
            
            [XAppDelegate.rankWeekTableViewController.videoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.videoId == self.videoModel.videoId)
                {
                    obj.isAlreadyFavorite = NO;
                    *stop = YES;
                }
            }];

            [XAppDelegate.rankMonthTableViewController.videoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.videoId == self.videoModel.videoId)
                {
                    obj.isAlreadyFavorite = NO;
                    *stop = YES;
                }
            }];
            
            [XAppDelegate.rankAllTableViewController.videoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.videoId == self.videoModel.videoId)
                {
                    obj.isAlreadyFavorite = NO;
                    *stop = YES;
                }
            }];
            
        } failure:^{
            
        }];
    }
}

- (void)downloadButtonClick:(AndyVideoDetailOperateButton *)button
{
    if (button.selected == NO && !self.videoModel.isAlreadyDownload && !self.videoModel.isDownloading)
    {
        if ([AndyCommonFunction isNetworkConnected])
        {
            if ([AndyCommonFunction isWiFiEnabled])
            {
                self.videoModel.isDownloading = true;
                
                self.downloadButton.titleLabel.text = @"开始下载";
                self.downloadButton.imageView.image = [UIImage imageNamed:@"Download"];
                
                [self combineDownloadData];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"下载提示" message:@"当前为非WiFi网络，继续下载将消耗您的手机流量。确定要下载吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
                [alertView show];
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
        AndyLog(@"虽然再次点击下载，但我忽略");
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        if (self.downloadButton.selected == NO && !self.videoModel.isAlreadyDownload && !self.videoModel.isDownloading)
        {
            self.videoModel.isDownloading = true;
            
            self.downloadButton.titleLabel.text = @"开始下载";
            self.downloadButton.imageView.image = [UIImage imageNamed:@"Download"];
            
            [self combineDownloadData];
        }
        else
        {
            AndyLog(@"虽然再次点击下载，但我忽略");
        }

    }
}

- (void)combineDownloadData
{
    self.videoModel.downloadCallBack.delegate = self;
    
    AndyDownloadTool *downloadTool = [AndyDownloadTool sharedDownloadTool];
    
    __block AndyDownloadModel *downloadModel = nil;
    
    [downloadTool.downloadArrayM enumerateObjectsUsingBlock:^(AndyDownloadModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.downloadId == self.videoModel.videoId)
        {
            downloadModel = obj;
            *stop = true;
        }
    }];
    
    if (downloadModel == nil)
    {
        downloadModel = [[AndyDownloadModel alloc] init];
        downloadModel.downloadId = self.videoModel.videoId;
        downloadModel.downloadUrl = [AndyCommonFunction getVideoDownloadUrl:self.videoModel];
        [downloadModel.videoDownloadCallBackArrayM addObject:self.videoModel.downloadCallBack];
        
        [downloadModel startDownload];
        
        [downloadTool.downloadArrayM addObject:downloadModel];
    }
    else
    {
        [downloadModel.videoDownloadCallBackArrayM addObject:self.videoModel.downloadCallBack];
    }
    
    [XAppDelegate.categoryTimeVideoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.videoId == self.videoModel.videoId)
        {
            obj.isDownloading = true;
            obj.isAlreadyDownload = false;
            *stop = true;
        }
    }];
    
    [XAppDelegate.categoryShareVideoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.videoId == self.videoModel.videoId)
        {
            obj.isDownloading = true;
            obj.isAlreadyDownload = false;
            *stop = true;
        }
    }];

    
    //寻找收藏的集合里面有没有当前要下载的videoModel，以便在展示收藏的时候能够正确展示
    [XAppDelegate.favoriteVideoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.videoId == downloadModel.downloadId)
        {
            obj.isDownloading = true;
            obj.isAlreadyDownload = false;
            *stop = true;
        }
    }];
    
    //接下来寻找可能已经加载到界面上的数据集合的情况
    [XAppDelegate.dailyTableViewController.videoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.videoId == downloadModel.downloadId)
        {
            obj.isDownloading = true;
            obj.isAlreadyDownload = false;
            *stop = YES;
        }
    }];
    
    [XAppDelegate.rankWeekTableViewController.videoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.videoId == downloadModel.downloadId)
        {
            obj.isDownloading = true;
            obj.isAlreadyDownload = false;
            *stop = YES;
        }
    }];
    
    [XAppDelegate.rankMonthTableViewController.videoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.videoId == downloadModel.downloadId)
        {
            obj.isDownloading = true;
            obj.isAlreadyDownload = false;
            *stop = YES;
        }
    }];
    
    [XAppDelegate.rankAllTableViewController.videoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.videoId == downloadModel.downloadId)
        {
            obj.isDownloading = true;
            obj.isAlreadyDownload = false;
            *stop = YES;
        }
    }];
}

- (void)removeDownloadModel
{
    AndyDownloadTool *downloadTool = [AndyDownloadTool sharedDownloadTool];
    
    __block AndyDownloadModel *downloadModel = nil;
    
    [downloadTool.downloadArrayM enumerateObjectsUsingBlock:^(AndyDownloadModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.downloadId == self.videoModel.videoId)
        {
            downloadModel = obj;
            *stop = true;
        }
    }];
    
    if (downloadModel != nil)
    {
        [downloadTool.downloadArrayM removeObject:downloadModel];
    }
}





















@end
