//
//  AndyPastCategoryCollectionViewController.m
//  EyeSight
//
//  Created by 李扬 on 15/11/12.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyPastCategoryCollectionViewController.h"
#import "AndyHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "AndyCategoryCell.h"
#import "MJExtension.h"
#import "NSString+Andy.h"
#import "AndyVideoAlbumScrollTool.h"
#import "AndyVideoAlbumScrollCallBack.h"

#define AndyCategoryId @"CategoryId"

#define ReusableViewITestId @"ReusableViewITestId"

@interface AndyPastCategoryCollectionViewController ()
@property (nonatomic, strong) NSArray *categorys;

@end

@implementation AndyPastCategoryCollectionViewController

- (NSArray *)categorys
{
    if (_categorys == nil)
    {
        _categorys = [NSArray array];
    }
    return _categorys;
}

- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    AndyLog(@"%f, %f", AndyMainScreenSize.width, AndyMainScreenSize.height);
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait)
    {
        layout.itemSize = CGSizeMake(AndyMainScreenSize.width / 2 - 1.2, AndyMainScreenSize.width / 2 - 1.2);
    }
    else
    {
        //解决当应用在横向状态下启动的时候，此页面初始化init屏幕宽高互换导致UICollectionViewCell大小计算出错的问题
        layout.itemSize = CGSizeMake(AndyMainScreenSize.height / 2 - 1.2, AndyMainScreenSize.height / 2 - 1.2);
    }
    
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 2.4;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, layout.minimumLineSpacing, 0);
    return [super initWithCollectionViewLayout:layout];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    AndyVideoAlbumScrollTool *videoAlbumScrollTool = [AndyVideoAlbumScrollTool sharedVideoAlbumScrollTool];
    
    if ([videoAlbumScrollTool.videoAlbumScrollCallBack.delagete respondsToSelector:@selector(videoAlbumDidScroll)])
    {
        [videoAlbumScrollTool.videoAlbumScrollCallBack.delagete videoAlbumDidScroll];
    }
    
    //videoAlbumScrollTool.videoAlbumScrollCallBack = nil;
}

- (void)loadCategoryData
{
    [MBProgressHUD showMessage:LoadingInfo toView:self.navigationController.view];
    
    [AndyHttpTool getWithURL:@"http://baobab.wandoujia.com/api/v1/categories?test=1" params:nil success:^(id json) {
        
        //AndyLog(@"%@", json);
        
        [self CommbineNewData:json];
        
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        
        [[NSString stringWithFormat:@"%@", json] saveContentToFile:PastCategoryCacheFileName atomically:YES];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        NSString *cacheFilePath = [AndyCommonFunction getCacheFilePathWithFileName:PastCategoryCacheFileName];
        
        if ([AndyCommonFunction isNetworkConnected] == NO)
        {
            if ([AndyCommonFunction checkFileIfExist:cacheFilePath])
            {
                NSArray *jsonArr = [NSArray arrayWithContentsOfFile:cacheFilePath];
                [self CommbineNewData:jsonArr];
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
                NSArray *jsonArr = [NSArray arrayWithContentsOfFile:cacheFilePath];
                [self CommbineNewData:jsonArr];
            }
            else
            {
                [MBProgressHUD showError:LoadingError toView:self.navigationController.view];
            }
        }

    }];
}

- (void)CommbineNewData:(id)json
{
    self.categorys = [AndyCateogryModel objectArrayWithKeyValuesArray:json];
    
    [self.collectionView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"AndyCategoryCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:AndyCategoryId];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    UINib *headerNib = [UINib nibWithNibName:@"ReusableViewTest" bundle:nil];
    [self.collectionView registerNib:headerNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ReusableViewITestId];
    
    [self loadCategoryData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.categorys.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AndyCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:AndyCategoryId forIndexPath:indexPath];
    
    cell.coverView.alpha = 1.0;
    
    cell.bgImageView.alpha = 0.0;
    
    cell.categoryModel = self.categorys[indexPath.item];
    
    return cell;
}

@end
