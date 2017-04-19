//
//  AndyFMDBTool.h
//  EyeSight
//
//  Created by 李扬 on 15/11/18.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <Foundation/Foundation.h>
@class  AndyVideoListBaseModel;

@interface AndyFMDBTool : NSObject

+ (void)insertBySingle:(AndyVideoListBaseModel *)videoModel isFavorite:(BOOL)isFavorite success:(void(^)())success failure:(void(^)())failure;

+ (void)deleteBySingle:(AndyVideoListBaseModel *)videoModel isFavorite:(BOOL)isFavorite success:(void(^)())success failure:(void(^)())failure;

+ (NSMutableArray *)queryFavoriteCollection:(BOOL)isFavorite;

@end
