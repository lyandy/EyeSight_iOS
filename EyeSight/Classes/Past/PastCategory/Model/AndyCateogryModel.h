//
//  AndyCateogryModel.h
//  EyeSight
//
//  Created by 李扬 on 15/11/12.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AndyVideoAlbumScrollCallBack;

@interface AndyCateogryModel : NSObject

@property (nonatomic, assign) NSInteger categoryId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *alias;

@property (nonatomic, copy) NSString *bgPicture;

@property (nonatomic, copy) NSString *bgColor;

@property(nonatomic, strong) AndyVideoAlbumScrollCallBack *videoAlbumScrollCallBack;

@end
