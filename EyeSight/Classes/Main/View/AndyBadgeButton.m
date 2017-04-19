//
//  AndyBadgeButton.m
//  EyeSight
//
//  Created by 李扬 on 15/10/21.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyBadgeButton.h"
#import "UIImage+Andy.h"

@implementation AndyBadgeButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.hidden = YES;
        self.userInteractionEnabled = NO;
        [self setBackgroundImage:[UIImage resizedImageWithName:@"main_badge"] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:11];
    }
    
    return self;
}

- (void)setBadgeValue:(NSString *)badgeValue
{
    _badgeValue = [badgeValue copy];
    
    if (badgeValue != nil && [badgeValue intValue] != 0)
    {
        self.hidden = NO;
        [self setTitle:[badgeValue intValue] > 99 ? @"99+" : badgeValue forState:UIControlStateNormal];
        
        CGRect frame = self.frame;
        CGFloat badgeH = self.currentBackgroundImage.size.height;
        CGFloat badgeW = self.currentBackgroundImage.size.width;
        if (badgeValue.length > 1)
        {
            CGSize badgeSize = [badgeValue sizeWithFont:self.titleLabel.font];
            badgeW = badgeSize.width + 10;
        }
        
        frame.size.width = badgeW;
        frame.size.height = badgeH;
        self.frame = frame;
    }
    else
    {
        self.hidden = YES;
    }
}

@end
