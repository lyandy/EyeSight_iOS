//
//  AndyCommonVideoPlayViewController.m
//  EyeSight
//
//  Created by 李扬 on 15/11/5.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyCommonVideoPlayViewController.h"
#import <MediaPlayer/MediaPlayer.h>

#define AndyNoticeLabelFont [UIFont systemFontOfSize:15]

@interface AndyCommonVideoPlayViewController ()

@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property(nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, weak) UIButton *closeButton;
@property (nonatomic, weak) UILabel *noticeLabel;

@end

@implementation AndyCommonVideoPlayViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

//隐藏状态条
//-(BOOL)prefersStatusBarHidden
//{
//    return YES;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addNotification];
    [self setupSubViews];

}

- (void)setupSubViews
{
    self.view.backgroundColor = [UIColor blackColor];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
    self.view.bounds = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
    self.view.center = CGPointMake(self.view.frame.origin.x+(self.view.frame.size.width/2),self.view.frame.origin.y+(self.view.frame.size.height/2));
    self.view.transform = CGAffineTransformMakeRotation(M_PI / 2);
    
    BOOL isLocalExist = NO;
    MPMoviePlayerController *moviePlayer = nil;
    NSString *playUrl = nil;
    if (self.videoModel.isAlreadyDownload)
    {
        playUrl = [AndyCommonFunction getVideoDownloadLocalPath:self.videoModel];
        NSFileManager *file_manager = [NSFileManager defaultManager];
        if ([file_manager fileExistsAtPath:playUrl])   //如果文件存在
        {
            AndyLog(@"文件存在");
            isLocalExist = YES;
            moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:playUrl]];
        }
        else
        {
            playUrl = [AndyCommonFunction getOnLineVideoPlayUrl:self.videoModel];
            moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:[playUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        }
    }
    else
    {
        playUrl = [AndyCommonFunction getOnLineVideoPlayUrl:self.videoModel];
        moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:[playUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
    
    moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
    moviePlayer.fullscreen = YES;
    moviePlayer.view.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
    self.moviePlayer = moviePlayer;
    [self.view addSubview:self.moviePlayer.view];
    
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] init];
    loadingView.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
    loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.loadingView = loadingView;
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimating];
    
    if (isLocalExist)
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self.view addGestureRecognizer:tap];
        
        [self.moviePlayer play];
    }
    else
    {
        if ([AndyCommonFunction isNetworkConnected] == YES)
        {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
            [self.view addGestureRecognizer:tap];
        
            [self.moviePlayer play];
        }
        else
        {
            [self setupCloseButton];
            [self setupNoticeLabel];
        
            [self.loadingView stopAnimating];
            [self.loadingView removeFromSuperview];
        }
    }
}

- (void)tap:(UIGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded && self.closeButton == nil)
    {
        [self setupCloseButton];
        
        [UIView animateWithDuration:0.2 animations:^{
            self.closeButton.imageView.alpha = 1.0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 delay:3.0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.closeButton.imageView.alpha = 0.0;
            } completion:^(BOOL finished) {
                [self.closeButton removeFromSuperview];
            }];
        }];
    }
}

- (void)setupCloseButton
{
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"CloseNormal"] forState:UIControlStateNormal];
    [closeButton setImage:[UIImage imageNamed:@"CloseHighLight"] forState:UIControlStateHighlighted];
    closeButton.frame = CGRectMake(20, 20, 23, 23);
    closeButton.highlighted = NO;
    closeButton.imageView.alpha = 0.0;
    [closeButton addTarget:self action:@selector(finished) forControlEvents:UIControlEventTouchUpInside];
    self.closeButton = closeButton;
    [self.view addSubview:self.closeButton];
}

- (void)setupNoticeLabel
{
    UILabel *noticeLabel = [[UILabel alloc] init];
    noticeLabel.textColor = [UIColor whiteColor];
    noticeLabel.font = AndyNoticeLabelFont;
    noticeLabel.text = @"视频加载失败，请检查网络连接。";
    NSMutableDictionary *noticeLabelMD = [NSMutableDictionary dictionary];
    noticeLabelMD[NSFontAttributeName] = AndyNoticeLabelFont;
    CGSize noticeLabelSize = [noticeLabel.text sizeWithAttributes:noticeLabelMD];
    noticeLabel.bounds = (CGRect){{ 0, 0 },noticeLabelSize};
    noticeLabel.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
    self.noticeLabel = noticeLabel;
    [self.view addSubview:self.noticeLabel];
}

- (void)addNotification
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

    [nc addObserver:self selector:@selector(finished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [nc addObserver:self selector:@selector(moviePlayerLoadStateChanged:)name:MPMoviePlayerLoadStateDidChangeNotification object:nil];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    AndyLog(@"视频播放页内存已释放");
}

- (void)moviePlayerLoadStateChanged:(NSNotification *)notification
{
    if (self.moviePlayer.loadState != MPMovieLoadStateUnknown)
    {
        [self.loadingView stopAnimating];
        [self.loadingView removeFromSuperview];
        [self.closeButton removeFromSuperview];
    }
}

- (void)finished
{
    if ([self.delegate respondsToSelector:@selector(moviePlayerDidFinished)])
    {
        [self.delegate moviePlayerDidFinished];
    }
}















@end
