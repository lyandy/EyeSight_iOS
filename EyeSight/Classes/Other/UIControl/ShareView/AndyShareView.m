//
//  AndyShareView.m
//  EyeSight
//
//  Created by 李扬 on 15/12/1.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyShareView.h"
#import "AndyShareButton.h"
#import "AndyVideoListBaseModel.h"
#import <MessageUI/MessageUI.h>
#import "TencentOpenAPI/QQApiInterface.h"
#import "MBProgressHUD+MJ.h"
#import "UIImage+Andy.h"

#define shareBottomViewHeight 340
#define shareAppBottomViewHeight 253

@interface AndyShareView ()

@property (nonatomic, weak) UIView *bgCoverView;

@property (nonatomic, weak) UIView *bottomView;

@property (nonatomic, weak) AndyShareButton *weiXinFriendButton;

@property (nonatomic, weak) AndyShareButton *weiXinTimeLineButton;

@property (nonatomic, weak) AndyShareButton *weiXinFavoriteButton;

@property (nonatomic, weak) AndyShareButton *sinaWeiboButton;

@property (nonatomic, weak) AndyShareButton *QQFriendButton;

@property (nonatomic, weak) AndyShareButton *QQZoneButton;

@property (nonatomic, weak) AndyShareButton *messageButton;

@property (nonatomic, weak) AndyShareButton *mailButton;

@property (nonatomic, weak) AndyShareButton *urlCopyButton;

@property (nonatomic, weak) AndyShareButton *safariButton;

@property (nonatomic, weak) UIView *bottomLineView;

@property (nonatomic, weak) UIButton *cancelButton;

@property(nonatomic, strong) NSMutableArray *shareButtonsM;

@end

@implementation AndyShareView

- (NSMutableArray *)shareButtonsM
{
    if (_shareButtonsM == nil)
    {
        _shareButtonsM = [NSMutableArray array];
    }
    return _shareButtonsM;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    UIView *bgCoverView = [[UIView alloc] init];
    bgCoverView.backgroundColor = AndyColor(0, 0, 0, 0.5);
    bgCoverView.alpha = 0.0;
    self.bgCoverView = bgCoverView;
    [self addSubview:self.bgCoverView];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView = bottomView;
    [self addSubview:self.bottomView];
    
    AndyShareButton *weiXinFriendButton = [[AndyShareButton alloc] init];
    [weiXinFriendButton setTitle:@"微信朋友" forState:UIControlStateNormal];
    [weiXinFriendButton setImage:[UIImage imageNamed:@"ShareIcon_Weixin"] forState:UIControlStateNormal];
    weiXinFriendButton.mark = @"weiXinFriendButton";
    [weiXinFriendButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.weiXinFriendButton = weiXinFriendButton;
    [self.bottomView addSubview:self.weiXinFriendButton];
    [self.shareButtonsM addObject:self.weiXinFriendButton];
    
    AndyShareButton *weiXinTimeLineButton = [[AndyShareButton alloc] init];
    [weiXinTimeLineButton setTitle:@"微信朋友圈" forState:UIControlStateNormal];
    [weiXinTimeLineButton setImage:[UIImage imageNamed:@"ShareIcon_WeixinZone"] forState:UIControlStateNormal];
    weiXinTimeLineButton.mark = @"weiXinTimeLineButton";
    [weiXinTimeLineButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.weiXinTimeLineButton = weiXinTimeLineButton;
    [self.bottomView addSubview:self.weiXinTimeLineButton];
    [self.shareButtonsM addObject:self.weiXinTimeLineButton];
    
    AndyShareButton *weiXinFavoriteButton = [[AndyShareButton alloc] init];
    [weiXinFavoriteButton setTitle:@"微信收藏" forState:UIControlStateNormal];
    [weiXinFavoriteButton setImage:[UIImage imageNamed:@"ShareIcon_WeixinFav"] forState:UIControlStateNormal];
    weiXinFavoriteButton.mark = @"weiXinFavoriteButton";
    [weiXinFavoriteButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.weiXinFavoriteButton = weiXinFavoriteButton;
    [self.bottomView addSubview:self.weiXinFavoriteButton];
    [self.shareButtonsM addObject:self.weiXinFavoriteButton];
    
    AndyShareButton *sinaWeiboButton = [[AndyShareButton alloc] init];
    [sinaWeiboButton setTitle:@"新浪微博" forState:UIControlStateNormal];
    [sinaWeiboButton setImage:[UIImage imageNamed:@"ShareIcon_SinaWeibo"] forState:UIControlStateNormal];
    sinaWeiboButton.mark = @"sinaWeiboButton";
    [sinaWeiboButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.sinaWeiboButton = sinaWeiboButton;
    [self.bottomView addSubview:self.sinaWeiboButton];
    [self.shareButtonsM addObject:self.sinaWeiboButton];
    
    AndyShareButton *QQFriendButton = [[AndyShareButton alloc] init];
    [QQFriendButton setTitle:@"QQ好友" forState:UIControlStateNormal];
    [QQFriendButton setImage:[UIImage imageNamed:@"ShareIcon_QQ"] forState:UIControlStateNormal];
    QQFriendButton.mark = @"QQFriendButton";
    [QQFriendButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.QQFriendButton = QQFriendButton;
    [self.bottomView addSubview:self.QQFriendButton];
    [self.shareButtonsM addObject:self.QQFriendButton];
    
    AndyShareButton *QQZoneButton = [[AndyShareButton alloc] init];
    [QQZoneButton setTitle:@"QQ空间" forState:UIControlStateNormal];
    [QQZoneButton setImage:[UIImage imageNamed:@"ShareIcon_QZone"] forState:UIControlStateNormal];
    QQZoneButton.mark = @"QQZoneButton";
    [QQZoneButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.QQZoneButton = QQZoneButton;
    [self.bottomView addSubview:self.QQZoneButton];
    [self.shareButtonsM addObject:self.QQZoneButton];
    
    AndyShareButton *messageButton = [[AndyShareButton alloc] init];
    [messageButton setTitle:@"短信" forState:UIControlStateNormal];
    [messageButton setImage:[UIImage imageNamed:@"ShareIcon_Msg"] forState:UIControlStateNormal];
    messageButton.mark = @"messageButton";
    [messageButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.messageButton = messageButton;
    [self.bottomView addSubview:self.messageButton];
    [self.shareButtonsM addObject:self.messageButton];
    
    AndyShareButton *mailButton = [[AndyShareButton alloc] init];
    [mailButton setTitle:@"邮件" forState:UIControlStateNormal];
    [mailButton setImage:[UIImage imageNamed:@"ShareIcon_Mail"] forState:UIControlStateNormal];
    mailButton.mark = @"mailButton";
    [mailButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.mailButton = mailButton;
    [self.bottomView addSubview:self.mailButton];
    [self.shareButtonsM addObject:self.mailButton];
    
    AndyShareButton *urlCopyButton = [[AndyShareButton alloc] init];
    [urlCopyButton setTitle:@"复制链接" forState:UIControlStateNormal];
    [urlCopyButton setImage:[UIImage imageNamed:@"ShareIcon_Copy"] forState:UIControlStateNormal];
    urlCopyButton.mark = @"urlCopyButton";
    [urlCopyButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.urlCopyButton = urlCopyButton;
    [self.bottomView addSubview:self.urlCopyButton];
    [self.shareButtonsM addObject:self.urlCopyButton];
    
    AndyShareButton *safariButton = [[AndyShareButton alloc] init];
    [safariButton setTitle:@"Safari打开" forState:UIControlStateNormal];
    [safariButton setImage:[UIImage imageNamed:@"ShareIcon_Safari"] forState:UIControlStateNormal];
    safariButton.mark = @"safariButton";
    [safariButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.safariButton = safariButton;
    [self.bottomView addSubview:self.safariButton];
    [self.shareButtonsM addObject:self.safariButton];
    
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = AndyColor(196, 196, 196, 1.0);
    self.bottomLineView = bottomLineView;
    [self.bottomView addSubview:self.bottomLineView];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [cancelButton setTitleColor:AndyColor(146, 146, 146, 1.0) forState:UIControlStateNormal];
    [cancelButton setTitleColor:AndyColor(175, 175, 175, 1.0) forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelButton = cancelButton;
    [self.bottomView addSubview:self.cancelButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.videoModel == nil)
    {
        [self.shareButtonsM removeObjectsInRange:(NSRange){8, 2}];
    }
    
    CGFloat bottomViewHeight = self.videoModel == nil ? shareAppBottomViewHeight : shareBottomViewHeight;
    
    self.bgCoverView.frame = self.bounds;
    self.bottomView.frame = CGRectMake(0, AndyMainScreenSize.height, AndyMainScreenSize.width, bottomViewHeight);
    
    int totalColumns = 4;
    
    CGFloat shareButtonW = 70;
    CGFloat shareButtonH = 87;
    
    CGFloat marginX = (self.frame.size.width - totalColumns * shareButtonW) / (totalColumns + 1);
    CGFloat marginY = 5;
    
    CGFloat bottomLineViewY = 0;
    
    for (int i = 0; i < self.shareButtonsM.count; i++)
    {
        AndyShareButton *shareButton = (AndyShareButton *)self.shareButtonsM[i];
        
        int row = i / totalColumns;
        int col = i % totalColumns;
        
        CGFloat shareButtonX = marginX + col * (shareButtonW + marginX);
        
        CGFloat shareButtonY = 15 + row * (shareButtonH + marginY);
        
        shareButton.frame = CGRectMake(shareButtonX, shareButtonY, shareButtonW, shareButtonH);
        
        bottomLineViewY = shareButtonY + shareButtonH + 5;
    }
    
    CGFloat bottomLineViewX = 0;
    CGFloat bottomLineViewW = self.frame.size.width;
    CGFloat bottomLineViewH = 0.5;
    self.bottomLineView.frame = CGRectMake(bottomLineViewX, bottomLineViewY, bottomLineViewW, bottomLineViewH);

    CGFloat cancelButtonX = 0;
    CGFloat cancelButtonY = CGRectGetMaxY(self.bottomLineView.frame);
    CGFloat cancelButtonW = self.frame.size.width;
    CGFloat cancelButtonH = self.bottomView.frame.size.height - cancelButtonY;
    self.cancelButton.frame = CGRectMake(cancelButtonX, cancelButtonY, cancelButtonW, cancelButtonH);

    [UIView animateWithDuration:0.2 animations:^{
        self.bgCoverView.alpha = 1.0;
        self.bottomView.frame = CGRectMake(0, AndyMainScreenSize.height - bottomViewHeight, AndyMainScreenSize.width, bottomViewHeight);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self.bgCoverView addGestureRecognizer:tap];
        
        AndyLog(@"%f, %f, %f, %f", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    }];
    
}

- (void)tap:(UIGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        [self hideWithCompleted:nil];
    }
}

- (void)cancelButtonClick:(UIButton *)button
{
    [self hideWithCompleted:nil];
}

- (void)hideWithCompleted:(void (^)())Completed
{
    [UIView animateWithDuration:0.2 animations:^{
        self.bgCoverView.alpha = 0.0;
        self.bottomView.frame = CGRectMake(0, AndyMainScreenSize.height, AndyMainScreenSize.width, self.videoModel == nil ? 253 : 340);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        if (Completed)
        {
            Completed();
        }
    }];
}

- (void)shareButtonClick:(AndyShareButton *)button
{
    [self hideWithCompleted:nil];
    //这种写法可以通用弱指针
    UIViewController *uivc = (UIViewController *)[AndyCommonFunction getCurrentPerformanceUIViewContorller];
    
    NSString *mark = button.mark;
    
    if ([mark isEqualToString:@"weiXinFriendButton"])
    {
        WXMediaMessage *message = [WXMediaMessage message];
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        if (self.videoModel != nil)
        {
            message.title = [NSString stringWithFormat:@"【%@】", self.videoModel.title];
            message.description = self.videoModel.videoDescription;
            
            //            UIImageView *midImageView = [[UIImageView alloc] init];
            //            [midImageView setImageWithURL:[NSURL URLWithString:self.videoModel.coverForDetail] placeholderImage:nil completed:nil];
            
            //NSData *imageData = UIImageJPEGRepresentation([UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.videoModel.coverForSharing]]]
            //, 0.001);
            //图片按0.75的质量压缩－》转换为NSData
            
            //AndyLog(@"%lu", imageData.length);
            
            [message setThumbImage:[UIImage normalResImageWithUrl:[NSURL URLWithString:self.videoModel.coverForSharing] WithinSize:400.0f]];
            
            WXWebpageObject *ext = [WXWebpageObject object];
            ext.webpageUrl = self.videoModel.webUrl;
            
            message.mediaObject = ext;
            
            
            req.bText = NO;
            req.message = message;
        }
        else
        {
            message.title = @"《视窗》应用分享";
            message.description = @"视窗 - 睁开双眼，认识不一样的世界，从此开始。在这里你可以欣赏不同的视频内容，它可能是美丽的风景，可能是异国风情、可能是各种美食，也可能是新奇的想法。世界再大，给你一扇视窗，即刻掌握。";
            
            [message setThumbImage:[UIImage normalResImageWithUrl:[NSURL URLWithString:@"http://a4.mzstatic.com/us/r30/Purple69/v4/27/29/70/27297090-068b-e7e0-cbcf-df0d8661812e/icon175x175.png"] WithinSize:400.0f]];
            
            WXWebpageObject *ext = [WXWebpageObject object];
            ext.webpageUrl = @"https://itunes.apple.com/us/app/shi-chuang/id1059327510?l=zh&ls=1&mt=8";
            
            message.mediaObject = ext;
            
            
            req.bText = NO;
            req.message = message;
            
        }
        
        req.scene = WXSceneSession;
        
        [WXApi sendReq:req];
        
    }
    else if ([mark isEqualToString:@"weiXinTimeLineButton"])
    {
        WXMediaMessage *message = [WXMediaMessage message];
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        if (self.videoModel != nil)
        {
            message.title = [NSString stringWithFormat:@"【%@】", self.videoModel.title];
            message.description = self.videoModel.videoDescription;
            
            //            UIImageView *midImageView = [[UIImageView alloc] init];
            //            [midImageView setImageWithURL:[NSURL URLWithString:self.videoModel.coverForDetail] placeholderImage:nil completed:nil];
            
            //NSData *imageData = UIImageJPEGRepresentation([UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.videoModel.coverForSharing]]]
            //, 0.001);
            //图片按0.75的质量压缩－》转换为NSData
            
            //AndyLog(@"%lu", imageData.length);
            
            [message setThumbImage:[UIImage normalResImageWithUrl:[NSURL URLWithString:self.videoModel.coverForSharing] WithinSize:400.0f]];
            
            WXWebpageObject *ext = [WXWebpageObject object];
            ext.webpageUrl = self.videoModel.webUrl;
            
            message.mediaObject = ext;
            
            
            req.bText = NO;
            req.message = message;
        }
        else
        {
            message.title = @"《视窗》应用分享";
            message.description = @"视窗 - 睁开双眼，认识不一样的世界，从此开始。在这里你可以欣赏不同的视频内容，它可能是美丽的风景，可能是异国风情、可能是各种美食，也可能是新奇的想法。世界再大，给你一扇视窗，即刻掌握。";
            
            [message setThumbImage:[UIImage normalResImageWithUrl:[NSURL URLWithString:@"http://a4.mzstatic.com/us/r30/Purple69/v4/27/29/70/27297090-068b-e7e0-cbcf-df0d8661812e/icon175x175.png"] WithinSize:400.0f]];
            
            WXWebpageObject *ext = [WXWebpageObject object];
            ext.webpageUrl = @"https://itunes.apple.com/us/app/shi-chuang/id1059327510?l=zh&ls=1&mt=8";
            
            message.mediaObject = ext;
            
            
            req.bText = NO;
            req.message = message;
            
        }
        
        req.scene = WXSceneTimeline;
        
        [WXApi sendReq:req];
        
    }
    else if ([mark isEqualToString:@"weiXinFavoriteButton"])
    {
        WXMediaMessage *message = [WXMediaMessage message];
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        if (self.videoModel != nil)
        {
            message.title = [NSString stringWithFormat:@"【%@】", self.videoModel.title];
            message.description = self.videoModel.videoDescription;
            
            //            UIImageView *midImageView = [[UIImageView alloc] init];
            //            [midImageView setImageWithURL:[NSURL URLWithString:self.videoModel.coverForDetail] placeholderImage:nil completed:nil];
            
            //NSData *imageData = UIImageJPEGRepresentation([UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.videoModel.coverForSharing]]]
            //, 0.001);
            //图片按0.75的质量压缩－》转换为NSData
            
            //AndyLog(@"%lu", imageData.length);
            
            [message setThumbImage:[UIImage normalResImageWithUrl:[NSURL URLWithString:self.videoModel.coverForSharing] WithinSize:400.0f]];
            
            WXWebpageObject *ext = [WXWebpageObject object];
            ext.webpageUrl = self.videoModel.webUrl;
            
            message.mediaObject = ext;
            
            
            req.bText = NO;
            req.message = message;
        }
        else
        {
            message.title = @"《视窗》应用分享";
            message.description = @"视窗 - 睁开双眼，认识不一样的世界，从此开始。在这里你可以欣赏不同的视频内容，它可能是美丽的风景，可能是异国风情、可能是各种美食，也可能是新奇的想法。世界再大，给你一扇视窗，即刻掌握。";
            
            [message setThumbImage:[UIImage normalResImageWithUrl:[NSURL URLWithString:@"http://a4.mzstatic.com/us/r30/Purple69/v4/27/29/70/27297090-068b-e7e0-cbcf-df0d8661812e/icon175x175.png"] WithinSize:400.0f]];
            
            WXWebpageObject *ext = [WXWebpageObject object];
            ext.webpageUrl = @"https://itunes.apple.com/us/app/shi-chuang/id1059327510?l=zh&ls=1&mt=8";
            
            message.mediaObject = ext;
            
            
            req.bText = NO;
            req.message = message;
            
        }
        
        req.scene = WXSceneFavorite;
        
        [WXApi sendReq:req];
    }
    else if ([mark isEqualToString:@"sinaWeiboButton"])
    {
        WBMessageObject *message = [WBMessageObject message];
        WBImageObject *image = [WBImageObject object];
        if (self.videoModel != nil)
        {
            message.text = [NSString stringWithFormat:@"【%@】%@。......链接地址:%@", self.videoModel.title, self.videoModel.videoDescription, self.videoModel.webUrl];
            
            image.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.videoModel.coverForSharing]];
        }
        else
        {
            message.text =@"视窗 - 睁开双眼，认识不一样的世界，从此开始。在这里你可以欣赏不同的视频内容，它可能是美丽的风景，可能是异国风情、可能是各种美食，也可能是新奇的想法。世界再大，给你一扇视窗，即刻掌握。应用下载地址:https://itunes.apple.com/us/app/shi-chuang/id1059327510?l=zh&ls=1&mt=8";
            image.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://a4.mzstatic.com/us/r30/Purple69/v4/27/29/70/27297090-068b-e7e0-cbcf-df0d8661812e/icon175x175.png"]];
        }
        message.imageObject = image;
        
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
        [WeiboSDK sendRequest:request];
    }
    else if ([mark isEqualToString:@"QQFriendButton"])
    {
        QQApiNewsObject *img = nil;
        
        if (self.videoModel != nil)
        {
            img = [QQApiNewsObject objectWithURL:[NSURL URLWithString:self.videoModel.webUrl] title:[NSString stringWithFormat:@"【%@】", self.videoModel.title] description:self.videoModel.videoDescription previewImageURL:[NSURL URLWithString:self.videoModel.coverForSharing]];
        }
        else
        {
            img = [QQApiNewsObject objectWithURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/shi-chuang/id1059327510?l=zh&ls=1&mt=8"] title:@"【视窗】应用分享" description:@"视窗 - 睁开双眼，认识不一样的世界，从此开始。在这里你可以欣赏不同的视频内容，它可能是美丽的风景，可能是异国风情、可能是各种美食，也可能是新奇的想法。世界再大，给你一扇视窗，即刻掌握。" previewImageURL:[NSURL URLWithString:@"http://a4.mzstatic.com/us/r30/Purple69/v4/27/29/70/27297090-068b-e7e0-cbcf-df0d8661812e/icon175x175.png"]];
        }
        
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:img];
        
        [QQApiInterface sendReq:req];
    }
    else if ([mark isEqualToString:@"QQZoneButton"])
    {
        //QQ空间分享的代码部分  qzone分享不支持text,image类型分享
        
        //创建分享内容
        
        QQApiURLObject *urlObj = nil;
        if (self.videoModel != nil)
        {
            urlObj = [[QQApiURLObject alloc] initWithURL:[NSURL URLWithString:self.videoModel.webUrl] title:[NSString stringWithFormat:@"【%@】", self.videoModel.title] description:self.videoModel.videoDescription previewImageURL:[NSURL URLWithString:self.videoModel.coverForSharing] targetContentType:QQApiURLTargetTypeNews];
        }
        else
        {
            urlObj = [[QQApiURLObject alloc] initWithURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/shi-chuang/id1059327510?l=zh&ls=1&mt=8"] title:@"【视窗】应用分享" description:@"视窗 - 睁开双眼，认识不一样的世界，从此开始。在这里你可以欣赏不同的视频内容，它可能是美丽的风景，可能是异国风情、可能是各种美食，也可能是新奇的想法。世界再大，给你一扇视窗，即刻掌握。" previewImageURL:[NSURL URLWithString:@"http://a4.mzstatic.com/us/r30/Purple69/v4/27/29/70/27297090-068b-e7e0-cbcf-df0d8661812e/icon175x175.png"] targetContentType:QQApiURLTargetTypeNews];
        }
        //创建响应
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:urlObj];
        
        [QQApiInterface SendReqToQZone:req];
    }
    else if ([mark isEqualToString:@"messageButton"])
    {
        if(![MFMessageComposeViewController canSendText])
        {
            return;
        }
        else
        {
            MFMessageComposeViewController *vc = [[MFMessageComposeViewController alloc] init];
            
            [vc.navigationBar setTintColor: [UIColor blackColor]];
            
            if (self.videoModel != nil)
            {
                vc.body = [NSString stringWithFormat:@"【%@】%@。......链接地址:%@    --来自《视窗》应用", self.videoModel.title, self.videoModel.videoDescription, self.videoModel.webUrl];
            }
            else
            {
                vc.body = @"视窗 - 睁开双眼，认识不一样的世界，从此开始。在这里你可以欣赏不同的视频内容，它可能是美丽的风景，可能是异国风情、可能是各种美食，也可能是新奇的想法。世界再大，给你一扇视窗，即刻掌握。应用下载地址:https://itunes.apple.com/us/app/shi-chuang/id1059327510?l=zh&ls=1&mt=8";
            }
            
            vc.messageComposeDelegate = uivc;
            
            [uivc presentViewController:vc animated:YES completion:^{
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            }];
        }
    }
    else if ([mark isEqualToString:@"mailButton"])
    {
        if(![MFMailComposeViewController canSendMail])
        {
            return;
        }
        else
        {
            MFMailComposeViewController *vc = [[MFMailComposeViewController alloc] init];
            
            [vc.navigationBar setTintColor: [UIColor blackColor]];
            
            if (self.videoModel != nil)
            {
                [vc setSubject:self.videoModel.title];
                [vc setMessageBody:[NSString stringWithFormat:@"【%@】%@。......链接地址:%@    --来自<a href='https://itunes.apple.com/us/app/shi-chuang/id1059327510?l=zh&ls=1&mt=8'>《视窗》</a>应用  <br/><br/><img src='%@' width=%f height=%f>", self.videoModel.title, self.videoModel.videoDescription, self.videoModel.webUrl, self.videoModel.coverForSharing, AndyMainScreenSize.width - 40, AndyMainScreenSize.width * 0.62] isHTML:YES];
            }
            else
            {
                [vc setSubject:@"《视窗》应用分享"];
                [vc setMessageBody:[NSString stringWithFormat:@"视窗 - 睁开双眼，认识不一样的世界，从此开始。在这里你可以欣赏不同的视频内容，它可能是美丽的风景，可能是异国风情、可能是各种美食，也可能是新奇的想法。世界再大，给你一扇视窗，即刻掌握。<a href='https://itunes.apple.com/us/app/shi-chuang/id1059327510?l=zh&ls=1&mt=8'>点击下载</a>  <br/><br/><img src='http://a4.mzstatic.com/us/r30/Purple69/v4/27/29/70/27297090-068b-e7e0-cbcf-df0d8661812e/icon175x175.png'>"] isHTML:YES];
            }
            
            vc.mailComposeDelegate = uivc;
            
            [uivc presentViewController:vc animated:YES completion:^{
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            }];
        }
    }
    else if ([mark isEqualToString:@"urlCopyButton"])
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.videoModel.webUrl;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"链接已复制:%@", self.videoModel.webUrl] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else if ([mark isEqualToString:@"safariButton"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.videoModel.webUrl]];
    }
}


















@end
