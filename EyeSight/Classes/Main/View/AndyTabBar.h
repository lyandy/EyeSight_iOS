//
//  AndyTabBar.h
//  EyeSight
//
//  Created by 李扬 on 15/10/21.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AndyTabBar;

@protocol AndyTabBarDelegate <NSObject>

@optional
- (void)tabBar:(AndyTabBar *)tabBar didSelectedButtonFrom:(int)from to:(int)to;

@end

@interface AndyTabBar : UIView

- (void)addTabBarButtonWithItem:(UITabBarItem *)item;

@property (nonatomic, weak) id<AndyTabBarDelegate> delegate;

@end
