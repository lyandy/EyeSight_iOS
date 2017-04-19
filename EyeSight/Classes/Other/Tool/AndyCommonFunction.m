//
//  AndyCommonFunction.m
//  EyeSight
//
//  Created by 李扬 on 15/11/3.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyCommonFunction.h"
#import "AndyTabBarViewController.h"
#import "AndyNavigationController.h"
#import "AndyPlayInfoModel.h"
#import "AndyVideoListBaseModel.h"
#import "Reachability.h"
#import "SDImageCache.h"
#import <CommonCrypto/CommonDigest.h>

@implementation AndyCommonFunction

+ (UIViewController *)getCurrentPerformanceUIViewContorller
{
    AndyTabBarViewController *andyTabBarVC =(AndyTabBarViewController *)[UIApplication sharedApplication].windows.firstObject.rootViewController;
    
    //AndyLog(@"%@", andyTabBarVC.childViewControllers);
    
    AndyNavigationController *andyNavigationVC = (AndyNavigationController *)andyTabBarVC.childViewControllers[andyTabBarVC.selectedIndex];
    UIViewController *vc = (UIViewController *)andyNavigationVC.childViewControllers.lastObject;
    
    return vc;
}

+ (NSString *)getOnLineVideoPlayUrl:(AndyVideoListBaseModel *)videoModel
{
    __block NSString *playUrl = nil;
    

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    __block BOOL isWiFiHighQuality = [defaults boolForKey:SettingWiFiKey];
    
    NSArray *playInfoModelArrary = videoModel.playInfo;

    [playInfoModelArrary enumerateObjectsUsingBlock:^(AndyPlayInfoModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (isWiFiHighQuality)
        {
            if ([AndyCommonFunction isWiFiEnabled])
            {
                if ([obj.name containsString:@"高清"])
                {
                    playUrl = obj.url;
                    *stop = true;
                }
            }
            else
            {
                if ([obj.name containsString:@"标清"])
                {
                    playUrl = obj.url;
                    *stop = true;
                }
            }
        }
        else
        {
            if ([obj.name containsString:@"标清"])
            {
                playUrl = obj.url;
                *stop = true;
            }
        }
    }];
    
    if (playUrl == nil)
    {
        playUrl = videoModel.playUrl;
    }
    
    return playUrl;
}

+ (NSString *)getVideoDownloadUrl:(AndyVideoListBaseModel *)videoModel
{
    __block NSString *playUrl = nil;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    __block BOOL isDownloadHighQuality = [defaults boolForKey:SettingDownloadKey];
    
    NSArray *playInfoModelArrary = videoModel.playInfo;
    
    [playInfoModelArrary enumerateObjectsUsingBlock:^(AndyPlayInfoModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (isDownloadHighQuality)
        {
            if ([obj.name containsString:@"高清"])
            {
                playUrl = obj.url;
                *stop = true;
            }
        }
        else
        {
            if ([obj.name containsString:@"标清"])
            {
                playUrl = obj.url;
                *stop = true;
            }
        }
    }];
    
    if (playUrl == nil)
    {
        playUrl = videoModel.playUrl;
    }
    
    return playUrl;
}


+ (BOOL)isNetworkConnected
{
    return ([[Reachability reachabilityWithHostName:@"http://www.baidu.com"] currentReachabilityStatus] != NotReachable);

}

+ (BOOL)isWiFiEnabled
{
    if (self.isNetworkConnected)
    {
        return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == ReachableViaWiFi);
    }
    else
    {
        return NO;
    }
}

+ (NSString *)applicationDocumentsCacheDirectory
{
    NSURL *documentDirectoryUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
    NSString *path = [documentDirectoryUrl.path stringByAppendingPathComponent:@"cache"];
    
    if(![[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    return path;
}

+ (NSString *)applicationDocumentsFMDBDirectory
{
    NSURL *documentDirectoryUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                          inDomains:NSUserDomainMask] lastObject];
    NSString *path = [documentDirectoryUrl.path stringByAppendingPathComponent:@"fmdb"];
    
    if(![[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    return path;
}

+ (NSString *)getCacheFilePathWithFileName:(NSString *)fileName
{
    NSString *cachePath = [self applicationDocumentsCacheDirectory];
    
    NSString *cacheFilePath = [NSString stringWithFormat:@"%@/%@",cachePath, fileName];
    
    return cacheFilePath;
}

+ (NSString *)applicationDocumentsVideoDownloadDirectory
{
    NSURL *documentDirectoryUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                          inDomains:NSUserDomainMask] lastObject];
    NSString *path = [documentDirectoryUrl.path stringByAppendingPathComponent:@"download"];
    
    if(![[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    return path;
}

+ (NSString *)getVideoDownloadFilePathWithFileName:(NSString *)fileName
{
    NSString *downloadPath = [self applicationDocumentsVideoDownloadDirectory];
    
    NSString *downloadFilePath = [NSString stringWithFormat:@"%@/%@",downloadPath, fileName];
    
    return downloadFilePath;
}

+ (NSString *)getVideoDownloadLocalPath:(AndyVideoListBaseModel *)videoModel
{
    __block NSString *path = nil;
    
    [videoModel.playInfo enumerateObjectsUsingBlock:^(AndyPlayInfoModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *url = obj.url;
        
        NSArray *array = [url componentsSeparatedByString:@"/"];
        NSString *videoName = (NSString *)[array lastObject];
        
        path = [self getVideoDownloadFilePathWithFileName:videoName];
        
        if([self checkFileIfExist:path])
        {
            *stop = true;
        }
    }];
    
    if (path == nil)
    {
        NSArray *array = [videoModel.playUrl componentsSeparatedByString:@"/"];
        NSString *videoName = (NSString *)[array lastObject];
        
        path = [self getVideoDownloadFilePathWithFileName:videoName];
        
        if([self checkFileIfExist:path])
        {
        }
    }
    
    return path;
}

+ (NSString *)getVideoDownloadLocalFileName:(AndyVideoListBaseModel *)videoModel
{
    __block NSString *videoName = nil;
    
    [videoModel.playInfo enumerateObjectsUsingBlock:^(AndyPlayInfoModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *url = obj.url;
        
        NSArray *array = [url componentsSeparatedByString:@"/"];
        videoName = (NSString *)[array lastObject];
        
        NSString *path = [self getVideoDownloadFilePathWithFileName:videoName];
        
        if([self checkFileIfExist:path])
        {
            *stop = true;
        }
    }];
    
    return videoName;
}

+ (BOOL)deleteDownloadVideo:(NSString *)downloadVideoLocalPath
{
    BOOL isDeleteSuccess = [[NSFileManager defaultManager] removeItemAtPath:downloadVideoLocalPath error:nil];
    AndyLog(@"删除视频是否成功：%lu", isDeleteSuccess);
    return isDeleteSuccess;
}

+ (NSString *)applicationDocumentsSplashScreenMobileImageDirectory
{
    NSURL *documentDirectoryUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                          inDomains:NSUserDomainMask] lastObject];
    NSString *path = [documentDirectoryUrl.path stringByAppendingPathComponent:@"splashScreen/mobile"];
    
    if(![[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return path;
}

+ (NSString *)getSplashScreenMobileImagePathWithFileName:(NSString *)fileName
{
    NSString *imagePath = [self applicationDocumentsSplashScreenMobileImageDirectory];
    
    NSString *imageFilePath = [NSString stringWithFormat:@"%@/%@",imagePath, fileName];
    
    return imageFilePath;
}

+ (NSString *)getSplashScreenMobileImageLocalPath
{
    NSString *path = [self getSplashScreenMobileImagePathWithFileName:@"phone.jpg"];
    
    if(![self checkFileIfExist:path])
    {
        path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"jpg"];
    }
    
    return path;
}


+ (BOOL)checkFileIfExist:(NSString *)filePath
{
    NSFileManager *file_manager = [NSFileManager defaultManager];
    if ([file_manager fileExistsAtPath:filePath])   //如果文件存在
    {
        return true;
    }
    else
    {
        return false;
    }
}
+ (NSString *)computeMD5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)countCacheSize
{
    unsigned long long int cacheFolderSize = [self getCacheFilesSize] * 45;
    
    NSString* strCacheSize;
    
    if( cacheFolderSize >= 1073741824)//GB
    {
        double value = (double)cacheFolderSize /1073741824;
        strCacheSize = [NSString stringWithFormat:@"%.2f GB",value];
    }
    else if( cacheFolderSize >= 1048576 )//MB
    {
        double value = (double)cacheFolderSize / 1048576;
        strCacheSize = [NSString stringWithFormat:@"%.2f MB",value];
    }
    else if( cacheFolderSize >= 1024 )//KB
    {
        double value = (double)cacheFolderSize / 1024;
        strCacheSize = [NSString stringWithFormat:@"%.2f KB",value];
    }
    else
    {
        strCacheSize = [NSString stringWithFormat:@"%lld Byte",cacheFolderSize];
    }
    
    return strCacheSize;
}

+ (unsigned long long int)getCacheFilesSize
{
    NSMutableArray *cacheFileList = [self getCacheFilePath];
    unsigned long long int cacheFolderSize = 0;
    NSFileManager  *manager = [NSFileManager defaultManager];
    
    //清理CACHE目录
    for(NSString* cacheFilePath in cacheFileList)
    {
        NSDictionary *cacheFileAttributes = [manager attributesOfItemAtPath:cacheFilePath error:nil];
        cacheFolderSize += [cacheFileAttributes fileSize];
    }
    return cacheFolderSize;
}

+ (NSMutableArray*)getCacheFilePath
{
    NSFileManager  *manager = [NSFileManager defaultManager];
    NSString* cacheDir = [self applicationDocumentsCacheDirectory];
    
    //显示所有子目录
    NSArray *cacheFileList = [manager subpathsAtPath:cacheDir];
    NSMutableArray *fullPathArray = [[NSMutableArray alloc] initWithCapacity:20];
    
    for(NSString* cacheFilePath in cacheFileList)
    {
        NSString* fileFullPath = [cacheDir stringByAppendingPathComponent:cacheFilePath];
        [fullPathArray addObject:fileFullPath];
    }
    
    return fullPathArray;
}

+ (void)clearCache
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSFileManager  *manager = [NSFileManager defaultManager];
    NSMutableArray *cacheFileList = [self getCacheFilePath];

    for(NSString* cacheFilePath in cacheFileList)
    {
        NSError *error;
        
        if(![manager removeItemAtPath:cacheFilePath error:&error])
        {
            //NSLog(@"%@: %@", cacheFilePath, [error localizedDescription]);
        }
    }
    
    [[SDImageCache sharedImageCache] clearDisk];
    
    [[SDImageCache sharedImageCache] clearMemory];
}

+ (void)initUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *firstInstallMark = [defaults stringForKey:@"firstInstallMark"];
    if (firstInstallMark == nil)
    {
        [defaults setBool:true forKey:SettingWiFiKey];
        [defaults setBool:true forKey:SettingIsVideoAutoBack];
        [defaults setBool:false forKey:SettingWiFiIsDownloadKey];
        [defaults setBool:true forKey:SettingDownloadKey];
        [defaults setBool:false forKey:SettingFavoriteKey];
        [defaults setBool:false forKey:SettingDoubleTapKey];
        
        [defaults setValue:@"OK" forKey:@"firstInstallMark"];
        
        NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow: -(60.0f*60.0f*24.0f)];
        [defaults setValue:yesterday forKey:SplashScreenImageDateKey];
    }
    [defaults synchronize];
}




@end
