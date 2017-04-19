//
//  AndyFMDBTool.m
//  EyeSight
//
//  Created by 李扬 on 15/11/18.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyFMDBTool.h"
#import "FMDB.h"
#import "AndyVideoListBaseModel.h"
#import "AndyPlayInfoModel.h"
#import "AndyConsumptionModel.h"
#import "AndyProviderModel.h"

@implementation AndyFMDBTool

static FMDatabaseQueue *_queue;

+ (void)setupFavoriteFMDB:(BOOL)isFavorite
{
    NSString *path = [[AndyCommonFunction applicationDocumentsFMDBDirectory] stringByAppendingPathComponent: isFavorite ? @"EyeSightFavorite.sqlite" : @"EyeSightDownload.sqlite"];
    
    _queue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists VideoInfo (id real primary key, date real, title text, description text, category text, duration real, coverForFeed text, coverForDetail text, coverForBlurred text, coverForSharing text, playUrl text, webUrl text, rawWebUrl text);"];
        [db executeUpdate:@"create table if not exists PlayInfo (uniqueId text primary key, parentId real, name text, type text, url text);"];
        [db executeUpdate:@"create table if not exists Provider (parentId real primary key, name text, alias text, icon text);"];
        [db executeUpdate:@"create table if not exists Consumption (parentId real primary key, collectionCount real, shareCount real, playCount real, replyCount real);"];
    }];
}

+ (void)insertBySingle:(AndyVideoListBaseModel *)videoModel isFavorite:(BOOL)isFavorite success:(void (^)())success failure:(void (^)())failure
{
    [self setupFavoriteFMDB:isFavorite];
    
    __block BOOL isSuccess = NO;
    
    [_queue inDatabase:^(FMDatabase *db) {
        isSuccess = [db executeUpdate:@"insert into VideoInfo (id, date, title, description, category, duration, coverForFeed, coverForDetail, coverForBlurred, coverForSharing, playUrl, webUrl, rawWebUrl) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);", [NSNumber numberWithInteger:videoModel.videoId], [NSNumber numberWithInteger:videoModel.date], videoModel.title, videoModel.videoDescription, videoModel.category, [NSNumber numberWithInteger:videoModel.duration], videoModel.coverForFeed, videoModel.coverForDetail, videoModel.coverBlurred, videoModel.coverForSharing, videoModel.playUrl, videoModel.webUrl, videoModel.rawWebUrl];
        
        [videoModel.playInfo enumerateObjectsUsingBlock:^(AndyPlayInfoModel *  _Nonnull playInfo, NSUInteger idx, BOOL * _Nonnull stop) {
            playInfo.parentId = videoModel.videoId;
            BOOL s = [db executeUpdate:@"insert into PlayInfo (uniqueId, parentId, name, type, url) values (?, ?, ?, ?, ?);", playInfo.uniqueId, [NSNumber numberWithInteger:playInfo.parentId], playInfo.name, playInfo.type, playInfo.url];
            
            AndyLog(@"%d", s);
        }];
        
        AndyProviderModel *provider = videoModel.provider;
        provider.parentId = videoModel.videoId;
        BOOL ss = [db executeUpdate:@"insert into Provider (parentId, name, alias, icon) values (?, ?, ?, ?)", [NSNumber numberWithInteger:provider.parentId], provider.name, provider.alias, provider.icon];
        
         AndyLog(@"%d", ss);
        
        AndyConsumptionModel *consumptionModel = videoModel.consumption;
        consumptionModel.parentId = videoModel.videoId;
        BOOL sss= [db executeUpdate:@"insert into Consumption (parentId, collectionCount, shareCount, playCount, replyCount) values (?, ?, ?, ?, ?)", [NSNumber numberWithInteger:consumptionModel.parentId], [NSNumber numberWithInteger:consumptionModel.collectionCount], [NSNumber numberWithInteger:consumptionModel.shareCount], [NSNumber numberWithInteger:consumptionModel.playCount], [NSNumber numberWithInteger:consumptionModel.replyCount]];
        
         AndyLog(@"%d", sss);
    }];
    
    [_queue close];
    
    if (isSuccess == YES)
    {
        if(success)
        {
            success();
        }
    }
    else
    {
        if (failure)
        {
            failure();
        }
    }
}

+ (void)deleteBySingle:(AndyVideoListBaseModel *)videoModel isFavorite:(BOOL)isFavorite success:(void (^)())success failure:(void (^)())failure
{
    [self setupFavoriteFMDB:isFavorite];
    
    __block BOOL isSuccess = NO;
    
    [_queue inDatabase:^(FMDatabase *db) {
        
        isSuccess = [db executeUpdate:@"delete from VideoInfo where id= ?;", [NSNumber numberWithInteger:videoModel.videoId]];
        
        [videoModel.playInfo enumerateObjectsUsingBlock:^(AndyPlayInfoModel *  _Nonnull playInfo, NSUInteger idx, BOOL * _Nonnull stop) {
            BOOL s = [db executeUpdate:@"delete from PlayInfo where parentId= ?;", [NSNumber numberWithInteger:videoModel.videoId]];
            
            AndyLog(@"%d", s);
        }];
        
        BOOL ss = [db executeUpdate:@"delete from Provider where parentId= ?;", [NSNumber numberWithInteger:videoModel.videoId]];
        
        AndyLog(@"%d", ss);

        BOOL sss= [db executeUpdate:@"delete from Consumption where parentId= ?;", [NSNumber numberWithInteger:videoModel.videoId]];
        
        AndyLog(@"%d", sss);
    }];
    
    [_queue close];
    
    if (isSuccess == YES)
    {
        if(success)
        {
            success();
        }
    }
    else
    {
        if (failure)
        {
            failure();
        }
    }
}

+ (NSMutableArray *)queryFavoriteCollection:(BOOL)isFavorite
{
    [self setupFavoriteFMDB:isFavorite];
    
    __block NSMutableArray *videoModelArrayM = nil;
    
    __block AndyVideoListBaseModel *videoModel = nil;
    
    [_queue inDatabase:^(FMDatabase *db) {
        
        videoModelArrayM = [NSMutableArray array];

        FMResultSet *videoModelRS = [db executeQuery:@"select * from VideoInfo;"];
        while (videoModelRS.next)
        {
            videoModel = [[AndyVideoListBaseModel alloc] init];
            
            videoModel.videoId = [videoModelRS doubleForColumn:@"id"];
            videoModel.date = [videoModelRS doubleForColumn:@"date"];
            videoModel.title = [videoModelRS stringForColumn:@"title"];
            videoModel.videoDescription = [videoModelRS stringForColumn:@"description"];
            videoModel.category = [videoModelRS stringForColumn:@"category"];
            videoModel.duration = [videoModelRS doubleForColumn:@"duration"];
            videoModel.coverForFeed = [videoModelRS stringForColumn:@"coverForFeed"];
            videoModel.coverForDetail = [videoModelRS stringForColumn:@"coverForDetail"];
            videoModel.coverBlurred = [videoModelRS stringForColumn:@"coverForBlurred"];
            videoModel.coverForSharing = [videoModelRS stringForColumn:@"coverForSharing"];
            videoModel.playUrl = [videoModelRS stringForColumn:@"playUrl"];
            videoModel.webUrl = [videoModelRS stringForColumn:@"webUrl"];
            videoModel.rawWebUrl = [videoModelRS stringForColumn:@"rawWebUrl"];
        
            
            FMResultSet *playInfoRS = [db executeQuery:@"select * from PlayInfo where parentId = ?;", [NSNumber numberWithInteger:videoModel.videoId]];
            
            NSMutableArray *playInfoM = [NSMutableArray array];
            while (playInfoRS.next)
            {
                AndyPlayInfoModel *playInfoModel = [AndyPlayInfoModel alloc];
                //playInfoModel.parentId = [playInfoRS doubleForColumn:@"parentId"];
                playInfoModel.name = [playInfoRS stringForColumn:@"name"];
                playInfoModel.type = [playInfoRS stringForColumn:@"type"];
                playInfoModel.url = [playInfoRS stringForColumn:@"url"];
                
                [playInfoM addObject:playInfoModel];
            }
            videoModel.playInfo = [playInfoM copy];
            [playInfoRS close];
            
            
            FMResultSet *providerRS = [db executeQuery:@"select * from Provider where parentId = ?;", [NSNumber numberWithInteger:videoModel.videoId]];
            
            AndyProviderModel *providerModel = [[AndyProviderModel alloc] init];
            while (providerRS.next)
            {
                providerModel.name = [providerRS stringForColumn:@"name"];
                providerModel.alias = [providerRS stringForColumn:@"alias"];
                providerModel.icon = [providerRS stringForColumn:@"icon"];
                videoModel.provider = providerModel;
            }
            [providerRS close];

            FMResultSet *consumptionRS = [db executeQuery:@"select * from Consumption where parentId = ?;", [NSNumber numberWithInteger:videoModel.videoId]];
            
            AndyConsumptionModel *consumptionModel = [[AndyConsumptionModel alloc] init];
            while (consumptionRS.next)
            {
                consumptionModel.collectionCount = [consumptionRS doubleForColumn:@"collectionCount"];
                consumptionModel.shareCount = [consumptionRS doubleForColumn:@"shareCount"];
                consumptionModel.playCount = [consumptionRS doubleForColumn:@"playCount"];
                consumptionModel.replyCount = [consumptionRS doubleForColumn:@"replyCount"];
                videoModel.consumption = consumptionModel;
            }
            [consumptionRS close];
            
            [videoModelArrayM addObject:videoModel];
        }
        [videoModelRS close];
    }];
    
    [_queue close];
    
    return videoModelArrayM;
}

























@end
