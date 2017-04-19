//
//  AndyVideoListBaseModel.h
//  EyeSight
//
//  Created by 李扬 on 15/10/21.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AndyProviderModel.h"
#import "AndyConsumptionModel.h"
#import "AndyDownloadCallBack.h"
#import "AndyVideoAlbumScrollCallBack.h"

typedef void (^AndyVideoListBaseModelEditOption)(BOOL isEdit);

typedef void (^AndyVideoListBaseModelDownloadOption)();

@interface AndyVideoListBaseModel : NSObject

@property(nonatomic, assign) NSInteger videoId;

@property (nonatomic, assign) long long date;

@property (nonatomic, copy) NSString *today;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *videoDescription;

@property (nonatomic, copy) NSString *category;

@property(nonatomic, strong) AndyProviderModel *provider;

@property (nonatomic, copy) NSString *videoDurtion;

@property (nonatomic, assign) long duration;

@property (nonatomic, copy) NSString *coverForFeed;

@property (nonatomic, copy) NSString *coverForDetail;

@property (nonatomic, copy) NSString *coverBlurred;

@property (nonatomic, copy) NSString *coverForSharing;

@property (nonatomic, copy) NSString *playUrl;

@property(nonatomic, strong) NSArray *playInfo;

@property (nonatomic, copy) NSString *webUrl;

@property (nonatomic, copy) NSString *rawWebUrl;

@property(nonatomic, strong) AndyConsumptionModel *consumption;

@property (nonatomic, assign) BOOL isAlreadyFavorite;

@property (nonatomic, assign) BOOL isAlreadyDownload;

@property (nonatomic, assign) BOOL isEditing;

@property (nonatomic, assign) BOOL isDownloading;

@property(nonatomic, copy) AndyVideoListBaseModelEditOption editOption;

//定义block为成员变量时要注意使用copy,为的就是把它放在堆里，以免block被随时释放而不可用
/**
 *  block本质是一个指向结构体的指针
 *  block可能存在于栈中，也可能存在于堆中，默认任何block都在在栈中。如果对block做一次copy操作就可以把block放在堆里面。因为这是深复制。
 *  block要注意循环强引用。只有block在堆里面才可能引起循环强引用。怎么才能把block放在堆里面呢？一个方法是定义的时候用copy，第二个方法是对block主动深复制copy，如[p.block copy]
 *  block定义为成员变量时要注意使用copy修饰
 *  block在使用外部的变量的时候会先把要使用变量做一次内存拷贝，然后再去修改变量的值。用运行时runtime来解释就是会新建一个结构体，在这个结构体中声明一个变量a来接收要改变值的外部成员变量。
 */
@property(nonatomic, copy) AndyVideoListBaseModelDownloadOption downloadOption;

@property (nonatomic, strong) AndyDownloadCallBack *downloadCallBack;

@property(nonatomic, strong) AndyVideoAlbumScrollCallBack *videoAlbumScrollCallBack;

@end
