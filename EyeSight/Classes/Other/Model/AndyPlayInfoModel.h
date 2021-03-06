//
//  AndyPlayInfoModel.h
//  EyeSight
//
//  Created by 李扬 on 15/10/21.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AndyPlayInfoModel : NSObject

@property (nonatomic, copy) NSString *uniqueId;

@property (nonatomic, assign) NSInteger parentId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *url;

@end
