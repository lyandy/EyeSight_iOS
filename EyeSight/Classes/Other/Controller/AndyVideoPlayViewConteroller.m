//
//  AndyVideoPlayViewConteroller.m
//  EyeSight
//
//  Created by 李扬 on 15/12/10.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyVideoPlayViewConteroller.h"
#import "AndyTabBarViewController.h"
#import "KRVideoPlayerController.h"
#import "AndyVideoListBaseModel.h"
#import "AndyPlayInfoModel.h"

@interface AndyVideoPlayViewConteroller ()

@property (nonatomic, strong) KRVideoPlayerController *videoController;

@property (nonatomic, assign) double currentBrightness;

@end

@implementation AndyVideoPlayViewConteroller

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    AndyTabBarViewController *tabVC = (AndyTabBarViewController *)[UIApplication sharedApplication].windows.firstObject.rootViewController;
    [tabVC roateLandscapeLeft];
    
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
    self.currentBrightness = [UIScreen mainScreen].brightness;
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    NSArray *qualityArray = [self combineQualityArray:self.videoModel];
    
    //GCD延时
    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self playVideoWithURL:self.playNSURL withTitle:self.videoTitle withQualityArray:qualityArray];
    //});
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft;
}

- (void)playVideoWithURL:(NSURL *)url withTitle:(NSString *)title withQualityArray:(NSArray *)qualityArray
{
    if (!self.videoController) {
        //        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        //        self.videoController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, width, width*(9.0/16.0))];
        self.videoController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, AndyMainScreenSize.width, AndyMainScreenSize.height)];
        __weak typeof(self)weakSelf = self;
        [self.videoController setDimissCompleteBlock:^{
            weakSelf.videoController = nil;
            
            [weakSelf.navigationController setNavigationBarHidden:NO animated:NO];
            
            [UIScreen mainScreen].brightness = weakSelf.currentBrightness;
            
            [weakSelf.navigationController popViewControllerAnimated:NO];
            //[weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
        [self.videoController showInWindow];
    }
    self.videoController.contentURL = url;
    self.videoController.videoTitle = title;
    self.videoController.qualityArray = qualityArray;
}

- (NSArray *)combineQualityArray:(AndyVideoListBaseModel *)videoModel
{
    NSMutableArray *arrayM = [NSMutableArray array];
    NSMutableArray *arrarTempM = [NSMutableArray array];
    
    if (videoModel.playInfo.count == 0)
    {
        NSDictionary *dic = [NSDictionary dictionaryWithObject:videoModel.playUrl forKey:@"高清"];
        [arrayM addObject:dic];
    }
    else
    {
        [videoModel.playInfo enumerateObjectsUsingBlock:^(AndyPlayInfoModel *playInfo, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = [NSDictionary dictionaryWithObject:playInfo.url forKey:playInfo.name];
            
            AndyLog(@"%@", self.playNSURL.description);
            
            NSArray *array = [self.playNSURL.description componentsSeparatedByString:@"/"];
            NSString *videoName = (NSString *)[array lastObject];
            
            if ([playInfo.url containsString:videoName])
            {
                [arrayM addObject:dic];
            }
            else
            {
                [arrarTempM addObject:dic];
            }
        }];
        
        [arrarTempM enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
            [arrayM addObject:dic];
        }];
    }

    return [arrayM copy];
}

- (void)dealloc
{
    AndyLog(@"播放控制器已销毁");
}

















@end
