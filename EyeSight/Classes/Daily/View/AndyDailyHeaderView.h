//
//  AndyDailyHeaderView.h
//  EyeSight
//
//  Created by 李扬 on 15/10/23.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AndyDailyListModel;

@interface AndyDailyHeaderView : UITableViewHeaderFooterView

+ (instancetype)viewWithTableView:(UITableView *)tableView;

@property(nonatomic, strong) AndyDailyListModel *dailyListModel;

@end
