//
//  AndyTabBar.m
//  EyeSight
//
//  Created by 李扬 on 15/10/21.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyTabBar.h"
#import "AndyTabBarButton.h"

@interface AndyTabBar()

@property (nonatomic, strong) NSMutableArray *tabBarButtons;

@property (nonatomic, weak) AndyTabBarButton *selectedButton;

@end

@implementation AndyTabBar

- (NSMutableArray *)tabBarButtons
{
    if (_tabBarButtons == nil)
    {
        _tabBarButtons = [NSMutableArray array];
    }
    
    return _tabBarButtons;
}

- (void)addTabBarButtonWithItem:(UITabBarItem *)item
{
    AndyTabBarButton *button = [[AndyTabBarButton alloc] init];
    [self addSubview:button];
    
    [self.tabBarButtons addObject:button];
    
    button.item = item;
    
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
    if (self.tabBarButtons.count == 1)
    {
        [self buttonClick:button];
    }
}

- (void)buttonClick:(AndyTabBarButton *)button
{
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedButtonFrom:to:)])
    {
        [self.delegate tabBar:self didSelectedButtonFrom:(int)self.selectedButton.tag to:(int)button.tag];
    }
    
    self.selectedButton.selected= NO;
    button.selected = YES;
    self.selectedButton = button;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat h =self.frame.size.height;
    CGFloat w = self.frame.size.width;
    
    CGFloat buttonH = h;
    CGFloat buttonW = w / self.subviews.count;
    CGFloat buttonY = 0;
    
    for (int index = 0; index < self.tabBarButtons.count; index++)
    {
        AndyTabBarButton *button = self.tabBarButtons[index];
        
        CGFloat buttonX = index * buttonW;
        
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        button.tag = index;
    }
}










@end
