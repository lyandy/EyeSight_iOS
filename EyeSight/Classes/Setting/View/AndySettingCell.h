//
//  AndySettingCell.h
//  EyeSight
//
//  Created by 李扬 on 15/11/20.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AndySettingItem;

@interface AndySettingCell : UITableViewCell

@property(nonatomic, strong) AndySettingItem *item;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
