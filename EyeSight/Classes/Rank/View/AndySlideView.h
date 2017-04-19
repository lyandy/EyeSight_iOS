//
//  AndySlideView.h
//  EyeSight
//
//  Created by 李扬 on 15/11/13.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AndySlideView;

@protocol AndyslideViewDelegate <NSObject>

@optional
- (void)slideView:(AndySlideView *)slideView didScrollViewTo:(int)to;

@end

@interface AndySlideView : UIView

- (void)setupViewControllersArray:(NSArray *)vcArr withTitleArray:(NSArray *)titleArr;

@property (nonatomic, weak) id<AndyslideViewDelegate> delagate;

@end
