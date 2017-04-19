//
//  AppDelegate.m
//  EyeSight
//
//  Created by 李扬 on 15/10/21.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AppDelegate.h"
#import "AndyTabBarViewController.h"
#import "AndyFavoriteTableViewController.h"
#import "AndyDownloadTableViewController.h"
#import "AndyVideoListBaseModel.h"
#import "MBProgressHUD+MJ.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "AndyWelcomeView+Andy.h"
#import "AndySplashScreenModel.h"
#import "AndyStartPageModel.h"
#import "MJExtension.h"
#import "AndyCampaignModel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)shouldAutorotate {
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [AndyCommonFunction initUserDefaults];
    
    NSData *imageData = (NSData *)[self initSplahScreenImageData];
    
    [self initFavoritesAndDowloads];
    
//    [self initSinaWeiboShareSDK];
//    
//    [self initTencentShareSDK];
//    
//    [self initWXShareSDK];
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    
    AndyTabBarViewController *vc = [[AndyTabBarViewController alloc] init];
    self.window.rootViewController = vc;
    
    [self.window makeKeyAndVisible];
    
    [self initSplashScreenWithImageData:imageData];
    
    return YES;
}

- (NSObject *)initSplahScreenImageData
{
    NSData *imageData = [NSData dataWithContentsOfFile:[AndyCommonFunction getSplashScreenMobileImageLocalPath]];
    
    //检查是否要去网络下载新的SplashScreen图片
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *saveDate = (NSDate *)[defaults objectForKey:SplashScreenImageDateKey];
    
    NSDate *today = [NSDate date];

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlags = NSDayCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:saveDate  toDate:today  options:0];
    AndyLog(@"%ld", comps.day);
    if (comps.day >= 1)
    {
        AndyLog(@"相差%ld天", comps.day);
        
        if ([AndyCommonFunction isNetworkConnected])
        {
            //开启一个线程去下载新的SplashScreen图片
            NSString *uuid = [[NSUUID UUID] UUIDString];
            AndyLog(@"%@", uuid);
            
            const char *cuuid = [uuid UTF8String];
            
            dispatch_queue_t network_queue = dispatch_queue_create(cuuid, nil);
            dispatch_async(network_queue, ^{
                [AndyHttpTool getWithURL:@"http://baobab.wandoujia.com/api/v1/configs" params:nil success:^(id json) {
                    AndySplashScreenModel *splashScreenModel = [AndySplashScreenModel objectWithKeyValues:json];
                    if (splashScreenModel.startPage != nil)
                    {
                        [AndyHttpTool downloadWithURL:splashScreenModel.startPage.imageUrl fileName:@"phone.jpg" localPath:[AndyCommonFunction applicationDocumentsSplashScreenMobileImageDirectory] progress:nil success:^{
                            [defaults setValue:today forKey:SplashScreenImageDateKey];
                            [defaults synchronize];
                            } failure:nil];
                    }
                    
                    if (splashScreenModel.campaignInFeed != nil)
                    {
                        [defaults setBool:splashScreenModel.campaignInFeed.available forKey:CampaignIsAvailableKey];
                        [defaults setObject:splashScreenModel.campaignInFeed.imageUrl forKey:CampaignImageUrlKey];
                        [defaults setObject:splashScreenModel.campaignInFeed.actionUrl forKey:CampaignActionUrlKey];
                        [defaults synchronize];
                    }
                    
                } failure:nil];
            });
        }
    }
    
    return (NSObject *)imageData;
}

- (void)initSplashScreenWithImageData:(NSData *)imageData
{
    AndyLog(@"%lu", imageData.length);
    
    [AndyWelcomeView showWelcomeViewWithImageData:imageData];
}

- (void)initFavoritesAndDowloads
{
    self.favoriteVideoList = [AndyFMDBTool queryFavoriteCollection:YES];
    
    self.downloadVideoList = [AndyFMDBTool queryFavoriteCollection:NO];
    
    NSString *uuid = [[NSUUID UUID] UUIDString];
    AndyLog(@"%@", uuid);
    
    const char *cuuid = [uuid UTF8String];
    
    //开启一个线程做循环遍历
    dispatch_queue_t network_queue = dispatch_queue_create(cuuid, nil);
    dispatch_async(network_queue, ^{
        [self.favoriteVideoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull objFavorite, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.downloadVideoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull objDownload, NSUInteger idx, BOOL * _Nonnull stop) {
                if (objDownload.videoId == objFavorite.videoId)
                {
                    objDownload.isAlreadyFavorite = true;
                }
            }];
            objFavorite.isAlreadyFavorite = true;
        }];
        
        [self.downloadVideoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull objDownload, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.favoriteVideoList enumerateObjectsUsingBlock:^(AndyVideoListBaseModel *  _Nonnull objFavorite, NSUInteger idx, BOOL * _Nonnull stop) {
                if (objDownload.videoId == objFavorite.videoId)
                {
                    objFavorite.isAlreadyDownload = true;
                }
            }];
            objDownload.isAlreadyDownload = true;
        }];
        
        AndyLog(@"我遍历完成了");
    });
    
    AndyLog(@"%lu", (unsigned long)self.favoriteVideoList.count);
}

- (void)initWXShareSDK
{
    [WXApi registerApp:wxAppId];
}

- (void)initTencentShareSDK
{
    TencentOAuth *tencentOauth = [[TencentOAuth alloc] initWithAppId:qqAppId andDelegate:nil];
    tencentOauth.redirectURI = @"http://www.cnblogs.com/lyandy";
}

- (void)initSinaWeiboShareSDK
{
    [WeiboSDK enableDebugMode:YES];
    BOOL isSuccess = [WeiboSDK registerApp:sinaWeiboAppKey];
    
    AndyLog(@"%d", isSuccess);
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WeiboSDK handleOpenURL:url delegate:self] || [TencentOAuth HandleOpenURL:url] || [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WeiboSDK handleOpenURL:url delegate:self ] || [TencentOAuth HandleOpenURL:url] || [WXApi handleOpenURL:url delegate:self];
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
//    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
//    {
//        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess)
//        {
//            [MBProgressHUD showSuccess:@"分享成功"];
//        }
//    }
//    else if ([response isKindOfClass:WBAuthorizeResponse.class])
//    {
//        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
//        self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
//        self.wbRefreshToken = [(WBAuthorizeResponse *)response refreshToken];
//    }
}

- (void)responseDidReceived:(APIResponse*)response forMessage:(NSString *)message
{
    //AndyLog(@"%d, %@", response.retCode, message);
}

- (void)tencentDidLogin
{
    //AndyLog(@"sdf");
}

- (void)onReq:(BaseReq *)req
{
    
}

- (void)onResp:(BaseResp *)resp
{
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
