//
//  AndyCategoryModelFrame.h
//  EyeSight
//
//  Created by 李扬 on 15/11/12.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AndyCateogryModel.h"

@interface AndyCategoryModelFrame : NSObject

@property (nonatomic, strong) AndyCateogryModel *categoryModel;

@property (nonatomic, assign, readonly) CGRect nameViewF;

@property (nonatomic, assign, readonly) CGRect bgPictureViewF;

@property (nonatomic, assign, readonly) CGRect coverViewF;

@end
