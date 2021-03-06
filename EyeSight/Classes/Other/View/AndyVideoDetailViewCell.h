//
//  AndyVideoDetailView.h
//  EyeSight
//
//  Created by 李扬 on 15/11/4.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AndyVideoListBaseModel.h"
#import "AndyVideoDetailOperateButton.h"

@interface AndyVideoDetailViewCell : UITableViewCell

@property (nonatomic, strong) AndyVideoListBaseModel *videoModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) AndyVideoDetailOperateButton *favoriteButton;

@property (nonatomic, weak) AndyVideoDetailOperateButton *downloadButton;

@end
