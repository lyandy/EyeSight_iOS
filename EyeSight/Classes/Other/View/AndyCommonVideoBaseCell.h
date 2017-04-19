//
//  AndyCommonVideoBaseCell.h
//  EyeSight
//
//  Created by 李扬 on 15/10/23.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AndyCommonVideoBaseCell;

@protocol AndyCommonVideoBaseCellDelegate <NSObject>

@optional
- (void)cellViewDidHolding:(AndyCommonVideoBaseCell *)andyCommonVideoBaseCell;
- (void)cellViewDidReleaseHolding:(AndyCommonVideoBaseCell *)andyCommonVideoBaseCell;
- (void)cellViewNeedNavigate:(AndyCommonVideoBaseCell *)andyCommonVideoBaseCell;
@end

@interface AndyCommonVideoBaseCell : UITableViewCell

@property (nonatomic, weak) id<AndyCommonVideoBaseCellDelegate> delegate;

- (void)myHolding;

- (void)myRelease;

- (void)myNavigate;

@end
