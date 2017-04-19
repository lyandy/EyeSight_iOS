//
//  AndySlideBar.m
//  EyeSight
//
//  Created by 李扬 on 15/11/13.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndySlideBar.h"
#import "AndySlideBarButton.h"
#import "AndySlideView.h"

#define AndyBottomLineMargin 20;

@interface AndySlideBar ()<AndyslideViewDelegate>

@property (nonatomic, strong) NSMutableArray *slideBarButtons;

@property (nonatomic, weak) AndySlideBarButton *selectedButton;

@property (nonatomic, weak) UIToolbar *toolBar;

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) UIView *bottomLineView;

@property (nonatomic, assign) CGFloat itemWith;

@end

@implementation AndySlideBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupSubViews];
    }
    return self;
}

- (NSMutableArray *)slideBarButtons
{
    if (_slideBarButtons == nil)
    {
        _slideBarButtons = [NSMutableArray array];
    }
    return _slideBarButtons;
}

- (void)setupSubViews
{
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.barStyle = UIBarStyleDefault;
    toolbar.backgroundColor = AndyColor(255, 255, 255, 0.96);
    self.toolBar = toolbar;
    [self addSubview:toolbar];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.bounds;
    scrollView.scrollsToTop = NO;
    scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView = scrollView;
    [self addSubview:self.scrollView];
    
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = [UIColor blackColor];
    self.bottomLineView = bottomLineView;
    [self addSubview:self.bottomLineView];
}

- (void)setupSlideBarButtonsArray:(NSArray *)titleArr
{
//    AndyLog(@"x:%f, y:%f, w:%f, h:%f", self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.scrollView.frame.size.width ,self.scrollView.frame.size.height);
//    
//    CGFloat slideBarButtonY = 0;
//    CGFloat slideBarButtonW = self.frame.size.width / titleArr.count;
//    CGFloat slideBarButtonH = self.frame.size.height;
    
    for (int i = 0; i < titleArr.count; i++)
    {
        //CGFloat slideBarButtonX = i * slideBarButtonW;
        
        AndySlideBarButton *slideBarButton = [[AndySlideBarButton alloc] init];
        //slideBarButton.frame = CGRectMake(slideBarButtonX, slideBarButtonY, slideBarButtonW, slideBarButtonH);
        //slideBarButton.backgroundColor = [UIColor redColor];
        [slideBarButton setTitle:[titleArr objectAtIndex:i] forState:UIControlStateNormal];
        [slideBarButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
//        AndyLog(@"x:%f, y:%f, w:%f, h:%f", slideBarButton.frame.origin.x, slideBarButton.frame.origin.y, slideBarButton.frame.size.width ,slideBarButton.frame.size.height);
//        
//        AndyLog(@"%@", slideBarButton.titleLabel.text);
//        
//        [self.scrollView addSubview:slideBarButton];
        
        [self.slideBarButtons addObject:slideBarButton];
        
        if (self.slideBarButtons.count == 1)
        {
            [self buttonClick:slideBarButton];
        }
    }
    
//    CGFloat contentW = self.slideBarButtons.count * slideBarButtonW;
//    self.scrollView.contentSize = CGSizeMake(contentW, 0);

}

- (void)buttonClick:(AndySlideBarButton *)button
{
    if ([self.delegate respondsToSelector:@selector(slideBar:didSelectedButtonFrom:to:)])
    {
        [self.delegate slideBar:self didSelectedButtonFrom:self.selectedButton.tag to:button.tag];
    }
    
    self.selectedButton.selected = NO;
    
    button.selected = YES;
    self.selectedButton = button;

    [self animateBottomLine:(int)button.tag];
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.toolBar.frame = self.bounds;
    
    CGFloat slideBarButtonY = 0;
    CGFloat slideBarButtonW = self.frame.size.width / self.slideBarButtons.count;
    CGFloat slideBarButtonH = self.frame.size.height;
    
    self.itemWith = slideBarButtonW;
    
    for (int index = 0; index < self.slideBarButtons.count; index++)
    {
        CGFloat slideBarButtonX = index * slideBarButtonW;
        
        AndySlideBarButton *slideBarButton = self.slideBarButtons[index];
        
        slideBarButton.frame = CGRectMake(slideBarButtonX, slideBarButtonY, slideBarButtonW, slideBarButtonH);
        
        slideBarButton.tag = index;
        
        [self.scrollView addSubview:slideBarButton];
    }
    
    CGFloat contentW = self.slideBarButtons.count * slideBarButtonW;
    self.scrollView.contentSize = CGSizeMake(contentW, 0);
    
    CGFloat bottomLineViewX = self.slideBarButtons.count == 3 ? 25 : 55;
    CGFloat bottomLineViewY = self.frame.size.height - 5;
    CGFloat bottomLineViewW = slideBarButtonW - 2 * (self.slideBarButtons.count == 3 ? 25 : 55);
    CGFloat bottomLineViewH = 1;
    self.bottomLineView.frame = CGRectMake(bottomLineViewX, bottomLineViewY, bottomLineViewW, bottomLineViewH);
    
    self.slideView.delagate = self;
    
    //[self buttonClick:[self.slideBarButtons firstObject]];
}

- (void)slideView:(AndySlideView *)slideView didScrollViewTo:(int)to
{
    self.selectedButton.selected = NO;
    
    ((AndySlideBarButton *)self.slideBarButtons[to]).selected = YES;
    self.selectedButton = self.slideBarButtons[to];
    
    [self animateBottomLine:to];
}

- (void)animateBottomLine:(int)to
{
    [UIView animateWithDuration:0.2 animations:^{
        self.bottomLineView.frame = (CGRect){{to * self.itemWith + (self.slideBarButtons.count == 3 ? 25 : 55), self.bottomLineView.frame.origin.y}, self.bottomLineView.frame.size};
    }];
}















@end
