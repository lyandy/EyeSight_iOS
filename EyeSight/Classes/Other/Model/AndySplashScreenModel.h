//
//  AndySplashScreenModel.h
//  EyeSight
//
//  Created by 李扬 on 15/12/5.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AndyStartPageModel;
@class AndyCampaignModel;

@interface AndySplashScreenModel : NSObject

@property(nonatomic, strong) AndyStartPageModel *startPage;

@property (nonatomic, strong) AndyCampaignModel *campaignInFeed;

@end
