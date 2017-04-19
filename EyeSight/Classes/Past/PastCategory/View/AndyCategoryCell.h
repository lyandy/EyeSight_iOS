//
//  AndyCategoryCell.h
//  EyeSight
//
//  Created by 李扬 on 15/11/12.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AndyCateogryModel.h"

@interface AndyCategoryCell : UICollectionViewCell

@property (nonatomic, weak) UIView *coverView;
@property (nonatomic, weak) UIImageView *bgImageView;

@property (nonatomic, strong) AndyCateogryModel *categoryModel;

@end
