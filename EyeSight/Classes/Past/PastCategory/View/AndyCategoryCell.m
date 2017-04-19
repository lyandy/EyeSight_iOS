//
//  AndyCategoryCell.m
//  EyeSight
//
//  Created by 李扬 on 15/11/12.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyCategoryCell.h"
#import "UIImageView+WebCache.h"
#import "AndyNavigationController.h"
#import "AndyPastCategoryCollectionViewController.h"
#import "AndyPastDetailTableViewController.h"
#import "AndyPastDetailViewController.h"
#import "AndyVideoAlbumScrollCallBack.h"
#import "AndyVideoAlbumScrollTool.h"

@interface AndyCategoryCell () <AndyVideoAlbumScrollCallBackDelegate>

@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) int count;

@property (nonatomic, assign) BOOL isPressed;

@property (nonatomic, assign) BOOL isMoved;

@end

@implementation AndyCategoryCell

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self)
//    {
//        [self setupSubViews];
//    }
//    return self;
//}

- (void)awakeFromNib
{
    [self setupSubViews];
}

- (void)setupSubViews
{
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.alpha = 0.0;
    self.bgImageView = bgImageView;
    [self.contentView addSubview:self.bgImageView];
    
    UIView *coverView = [[UIView alloc] init];
    coverView.backgroundColor = AndyColor(0, 0, 0, 0.3);
    coverView.alpha = 1.0;
    self.coverView = coverView;
    [self.contentView addSubview:self.coverView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = AndyCategoryNameFont;
    nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel = nameLabel;
    [self.coverView addSubview:self.nameLabel];
}

- (void)videoAlbumDidScroll
{
    self.coverView.alpha = 1.0;
    
    AndyLog(@"分类页面UICollectionViewCell调用了");
}

- (void)setCategoryModel:(AndyCateogryModel *)categoryModel
{
    _categoryModel = categoryModel;
    
    _categoryModel.videoAlbumScrollCallBack.delagete = self;
    
    [self.bgImageView setImageWithURL: [NSURL URLWithString:categoryModel.bgPicture] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
        [UIView animateWithDuration:0.3 animations:^{
            self.bgImageView.alpha = 1.0;
        }];
    }];
    
    //[self.bgImageView setImageWithURL:[NSURL URLWithString:categoryModel.bgPicture] placeholderImage:nil];
    self.bgImageView.frame = self.bounds;
    
    self.coverView.frame = self.bgImageView.frame;
    
    self.nameLabel.text = [NSString stringWithFormat:@"#%@", categoryModel.name];
    NSMutableDictionary *nameLabelDM = [NSMutableDictionary dictionary];
    nameLabelDM[NSFontAttributeName] = AndyCategoryNameFont;
    CGSize nameLabelSize = [self.nameLabel.text sizeWithAttributes:nameLabelDM];
    CGFloat nameLabelX = (self.frame.size.width - nameLabelSize.width) / 2;
    CGFloat nameLabelY = (self.frame.size.height - nameLabelSize.height) / 2;
    self.nameLabel.frame = (CGRect){{nameLabelX, nameLabelY}, nameLabelSize};
}

- (void)viewDidHolding
{
    AndyLog(@"真正触摸");
    
    [UIView animateWithDuration:0.2 animations:^{
        self.coverView.alpha = 0.0;
    } completion:^(BOOL finished) {
        
        AndyVideoAlbumScrollTool *videoAlbumScrollTool = [AndyVideoAlbumScrollTool sharedVideoAlbumScrollTool];
        
        videoAlbumScrollTool.videoAlbumScrollCallBack = self.categoryModel.videoAlbumScrollCallBack;
    }];
}

- (void)viewDidReleaseHolding
{
    AndyLog(@"触摸释放");
    
    [UIView animateWithDuration:0.2 animations:^{
        self.coverView.alpha = 1.0;
    }];
}

- (void)viewNeedNavigate
{
    AndyLog(@"我要导航了");

//    AndyPastDetailTableViewController *pastDetailVideoListVC = [[AndyPastDetailTableViewController alloc] init];
//    pastDetailVideoListVC.title = self.categoryModel.name;
//    
//    NSString *urlString = [NSString stringWithFormat:@"http://baobab.wandoujia.com/api/v1/videos?num=10&strategy=date&categoryName=%@", self.categoryModel.name];
//    NSString* encodedString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    pastDetailVideoListVC.categoryDetailUrl = encodedString;
    
    AndyPastDetailViewController *pastDetailVideoListVC = [[AndyPastDetailViewController alloc] init];
    pastDetailVideoListVC.title = self.categoryModel.name;
    
    NSString *urlDateString = [NSString stringWithFormat:@"http://baobab.wandoujia.com/api/v1/videos?num=10&strategy=date&categoryName=%@", self.categoryModel.name];
    NSString* encodedDateString = [urlDateString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    pastDetailVideoListVC.categoryTimeDetailUrl = encodedDateString;
    
    NSString *urlShareString = [NSString stringWithFormat:@"http://baobab.wandoujia.com/api/v1/videos?num=10&strategy=shareCount&categoryName=%@", self.categoryModel.name];
    NSString* encodedShareString = [urlShareString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    pastDetailVideoListVC.categoryShareDetailUrl = encodedShareString;
    
    AndyPastCategoryCollectionViewController *uivc = (AndyPastCategoryCollectionViewController *)[AndyCommonFunction getCurrentPerformanceUIViewContorller];
    
    if (uivc != nil)
    {
        [uivc.navigationController pushViewController:pastDetailVideoListVC animated:YES];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.count = 0;
    
    [self removeTimer];
    
    if (self.timer == nil)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.005 target:self selector:@selector(countAutoIncrease) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)countAutoIncrease
{
    self.count++;
    
    if (self.count >= 1)
    {
        [self removeTimer];
        self.isPressed = true;
        
        //AndyLog(@"我在begin里%d", self.isPressed);
        
        [self viewDidHolding];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeTimer];
    
    self.isMoved = true;
    
    if (self.isPressed)
    {
        self.isPressed = false;
        
        //AndyLog(@"我在move里%d", self.isPressed);
        
        [self viewDidReleaseHolding];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeTimer];
    
    //AndyLog(@"我在end里%d", self.isPressed);
    
    if (self.isPressed)
    {
        self.isPressed = false;
        
        [self viewDidReleaseHolding];
    }
    
    //if (!self.isMoved)
    //{
        [self viewNeedNavigate];
    //}
    
    self.isMoved = false;
}

- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}


@end
