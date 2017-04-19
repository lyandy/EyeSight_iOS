//
//  AndyFavoriteVideoCell.h
//  EyeSight
//
//  Created by 李扬 on 15/11/30.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AndyCommonVideoBaseCell.h"

@class AndyCommonVideoFrame;

@interface AndyFavoriteVideoCell : AndyCommonVideoBaseCell<AndyCommonVideoBaseCellDelegate>

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic, strong) AndyCommonVideoFrame *commonVideoFrame;

@end
