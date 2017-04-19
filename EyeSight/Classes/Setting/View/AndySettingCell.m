//
//  AndySettingCell.m
//  EyeSight
//
//  Created by 李扬 on 15/11/20.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndySettingCell.h"
#import "AndySettingItem.h"
#import "AndySettingArrowItem.h"
#import "AndySettingSwitchItem.h"
#import "AndySettingLabelItem.h"
#import "AndySettingCacheArrowItem.h"
#import "AndySettingAlertArrowItem.h"
#import "MBProgressHUD+MJ.h"

#define ItemLabelInfoFont [UIFont systemFontOfSize:15]

@interface AndySettingCell ()

@property (nonatomic, strong) UIImageView *arrowView;

@property (nonatomic, strong) UISwitch *switchView;

@property (nonatomic, strong) UILabel *labelView;

@property(nonatomic, strong) UIView *arrowMultiView;

@end

@implementation AndySettingCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *Id = @"setting";
    AndySettingCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (cell == nil)
    {
        cell = [[AndySettingCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Id];
    }
    return cell;
}

- (UIImageView *)arrowView
{
    if (_arrowView == nil)
    {
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellArrow"]];
    }
    return _arrowView;
}

- (UIView *)arrowMultiView
{
    if (_arrowMultiView == nil)
    {
        _arrowMultiView = [[UIView alloc] init];
    }
    return _arrowMultiView;
}

- (UISwitch *)switchView
{
    if (_switchView == nil)
    {
        _switchView = [[UISwitch alloc] init];
     
        [_switchView addTarget:self action:@selector(switchStateChange) forControlEvents:UIControlEventValueChanged];
    }

    return _switchView;
}

- (void)switchStateChange
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    AndySettingSwitchItem *switchItem = (AndySettingSwitchItem *)self.item;
    
    [defaults setBool:self.switchView.isOn forKey:switchItem.key];
    
    [defaults synchronize];
}

- (UILabel *)labelView
{
    if (_labelView == nil)
    {
        _labelView = [[UILabel alloc] init];
        _labelView.font = ItemLabelInfoFont;
        //[self performSelectorInBackground:@selector(countCacheSize) withObject:nil];
    }
    return _labelView;
}

- (void)setItem:(AndySettingItem *)item
{
    _item = item;
    
    [self setupData];
    [self setupRightContent];
}

- (void)resizeArrowMultiView
{
    NSMutableDictionary *labelViewM = [NSMutableDictionary dictionary];
    labelViewM[NSFontAttributeName] = ItemLabelInfoFont;
    CGSize labelViewSize = [self.labelView.text sizeWithAttributes:labelViewM];
    self.labelView.frame = (CGRect){CGPointZero, labelViewSize};
    
    [self.arrowMultiView addSubview:self.labelView];
    
    CGFloat arrowViewX = CGRectGetMaxX(self.labelView.frame) + 10;
    CGSize arrowViewSize = self.arrowView.image.size;
    CGFloat arrowViewY = (labelViewSize.height - arrowViewSize.height) / 2;
    self.arrowView.frame = (CGRect){{arrowViewX, arrowViewY}, arrowViewSize};
    
    [self.arrowMultiView addSubview:self.arrowView];
    
    self.arrowMultiView.bounds = (CGRect){CGPointZero, {labelViewSize.width + arrowViewSize.width + 10, labelViewSize.height}};
}

- (void)setupRightContent
{
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    if ([self.item isKindOfClass:[AndySettingCacheArrowItem class]])
    {
        self.accessoryView = self.arrowMultiView;
        
        self.labelView.text = @"";
        
        [self resizeArrowMultiView];
        
        NSString *uuid = [[NSUUID UUID] UUIDString];
        const char *cuuid = [uuid UTF8String];

        dispatch_queue_t network_queue = dispatch_queue_create(cuuid, nil);
        dispatch_async(network_queue, ^{
            
            NSString *cacheSize = [AndyCommonFunction countCacheSize];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //self.labelView.text = cacheSize;
                
                [self resizeArrowMultiView];
            });
        });
        
        //这种写法可以通用弱指针，防止循环强引用防止内存泄露
        __unsafe_unretained typeof(self) selfCell = self;
        
        self.item.option = ^{
            
            selfCell.labelView.text = @"";
            
            [selfCell resizeArrowMultiView];

            dispatch_queue_t network_queue = dispatch_queue_create(cuuid, nil);
            dispatch_async(network_queue, ^{
                
                [AndyCommonFunction clearCache];
                
                //GCD延时
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    UIViewController *uivc = (UIViewController *)[AndyCommonFunction getCurrentPerformanceUIViewContorller];
                    
                    [MBProgressHUD hideHUDForView:uivc.navigationController.view];
                    
                    selfCell.labelView.text = @"";
                    
                    [selfCell resizeArrowMultiView];
                    
                    [MBProgressHUD showSuccess:@"缓存已成功清理" toView:uivc.navigationController.view];
                });
            });
        };
    }
    else if ([self.item isKindOfClass:[AndySettingAlertArrowItem class]])
    {
        AndySettingAlertArrowItem *alertItem = (AndySettingAlertArrowItem *)self.item;
        
        self.accessoryView = self.arrowMultiView;
        
        self.labelView.text = alertItem.LabelInfo;
        [self resizeArrowMultiView];
    }
    else if ([self.item isKindOfClass:[AndySettingArrowItem class]])
    {
        self.accessoryView = self.arrowView;
    }
    else if([self.item isKindOfClass:[AndySettingSwitchItem class]])
    {
        self.accessoryView = self.switchView;

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.switchView.on = [defaults boolForKey:((AndySettingSwitchItem *)self.item).key];
    }
    else if([self.item isKindOfClass:[AndySettingLabelItem class]])
    {
        AndySettingLabelItem *labelItem = (AndySettingLabelItem *)self.item;
        self.labelView.text = labelItem.LabelInfo;
        
        NSMutableDictionary *labelViewM = [NSMutableDictionary dictionary];
        labelViewM[NSFontAttributeName] = ItemLabelInfoFont;
        CGSize labelViewSize = [self.labelView.text sizeWithAttributes:labelViewM];
        self.labelView.frame = (CGRect){CGPointZero, labelViewSize};
        
        self.accessoryView = self.labelView;
    }
    else
    {
        self.accessoryView = nil;
    }
}

- (void)setupData
{
    if (self.item.icon != nil)
    {
        self.imageView.image = [UIImage imageNamed:self.item.icon];
    }
    
    self.textLabel.text = self.item.title;
    self.detailTextLabel.textColor = [UIColor grayColor];
    self.detailTextLabel.text = self.item.subTile;
}

















@end
