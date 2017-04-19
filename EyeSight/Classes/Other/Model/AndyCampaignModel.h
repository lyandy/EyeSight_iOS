//
//  AndyCampaignModel.h
//  EyeSight
//
//  Created by 李扬 on 15/12/24.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AndyCampaignModel : NSObject

@property (nonatomic, copy) NSString *imageUrl;

@property (nonatomic, copy) NSString *version;

@property (nonatomic, copy) NSString *actionUrl;

@property (nonatomic, assign) BOOL available;

@end
