//
//  AndyDailyHeaderView.m
//  EyeSight
//
//  Created by 李扬 on 15/10/23.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyDailyHeaderView.h"
#import "AndyDailyListModel.h"

@interface AndyDailyHeaderView ()

@property (nonatomic, weak) UILabel *dateLabel;

@end

@implementation AndyDailyHeaderView

+ (instancetype)viewWithTableView:(UITableView *)tableView
{
    static NSString *Id = @"sectionHeader";
    AndyDailyHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:Id];
    if (headerView == nil)
    {
        headerView = [[AndyDailyHeaderView alloc] initWithReuseIdentifier:Id];
        
        UIToolbar *toolbar = [[UIToolbar alloc] init];
        toolbar.barStyle = UIBarStyleDefault;
        toolbar.backgroundColor = AndyColor(255, 255, 255, 0.96);
        headerView.backgroundView = toolbar;
    }
    
    return headerView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        UILabel *dateLabel = [[UILabel alloc] init];
        dateLabel.font = [UIFont fontWithName:@"Lobster1.4" size:15];
        dateLabel.textAlignment = NSTextAlignmentCenter;

        [self.contentView addSubview:dateLabel];
        self.dateLabel = dateLabel;
        
//        AndyLog(@"%ld", [[UIFont familyNames] count]);
//        for (NSString *fontFamilyName in [UIFont familyNames]) {
//            AndyLog(@"-----------------");
//            for (NSString *fontName in [UIFont fontNamesForFamilyName:fontFamilyName]) {
//                NSLog(@"Family: %@    Font: %@", fontFamilyName, fontName);
//            }
//        }
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

//    CGSize dateLableSize = [self.dateLabel.text sizeWithFont:[UIFont systemFontOfSize:15]];
//    CGFloat dateLabelX = (self.frame.size.width - dateLableSize.width) / 2;
//    CGFloat dateLabelY = (self.frame.size.height - dateLableSize.height) / 2;
//
//    self.dateLabel.frame = (CGRect){{dateLabelX, dateLabelY}, dateLableSize};
    
    self.dateLabel.frame = self.bounds;
}

- (void)setDailyListModel:(AndyDailyListModel *)dailyListModel
{
    self.dateLabel.text = dailyListModel.realDate;
}

@end
