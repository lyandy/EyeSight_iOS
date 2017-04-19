//
//  AndySlideBar.h
//  EyeSight
//
//  Created by 李扬 on 15/11/13.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AndySlideView.h"

@class AndySlideBar;

@protocol AndySlideBarDelegate <NSObject>

@optional
- (void)slideBar:(AndySlideBar *)slideBar didSelectedButtonFrom:(long)from to:(long)to;

@end

@interface AndySlideBar : UIView

@property(nonatomic, strong) AndySlideView *slideView;

- (void)setupSlideBarButtonsArray:(NSArray*)titleArr;

@property (nonatomic, weak) id<AndySlideBarDelegate> delegate;

@end
