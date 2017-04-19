//
//  AndyCommonVideoCell.h
//  EyeSight
//
//  Created by 李扬 on 15/10/22.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AndyCommonVideoBaseCell.h"

@class AndyCommonVideoFrame;
@class AndyCommonVideoCell;


//@protocol AndyCommonVideoCellDelegate <NSObject>
//
//@optional
//- (void)commonCellViewNeedNavigate:(AndyCommonVideoCell *)andyCommonViewCell;
//
//@end


@interface AndyCommonVideoCell : AndyCommonVideoBaseCell<AndyCommonVideoBaseCellDelegate>

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic, strong) AndyCommonVideoFrame *commonVideoFrame;

//@property (nonatomic, weak) id<AndyCommonVideoCellDelegate> commonDelegate;

@end
