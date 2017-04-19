//
//  AndyCommonVideoFrame.m
//  EyeSight
//
//  Created by 李扬 on 15/10/22.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyCommonVideoFrame.h"
#import "AndyVideoListBaseModel.h"

@implementation AndyCommonVideoFrame

- (void)setVideoListBaseModel:(AndyVideoListBaseModel *)videoListBaseModel
{
    _videoListBaseModel = videoListBaseModel;
    
    //Cell的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    //backgroundView
    CGFloat backgroundW = cellW;
    CGFloat backgroundH = cellW * 3 / 5;
    CGFloat backgroundX = 0;
    CGFloat baclgroundY = 0;
    _bgViewF = CGRectMake(backgroundX, baclgroundY, backgroundW, backgroundH);
    
    //coverView
    _coverViewF = _bgViewF;
    
    //titleLabel
    CGSize titleSize = [videoListBaseModel.title sizeWithFont:AndyVideoListBaseModelTitleFont];
    CGFloat titleX = (cellW - titleSize.width) / 2;
    CGFloat titleY = (backgroundH - titleSize.height) / 2;
    _titleLabelF = (CGRect){{titleX, titleY}, titleSize};
    
    //categoryLabel
    CGFloat categoryAndDurationLabelY = CGRectGetMaxY(_titleLabelF) + 3;
    CGSize categoryAndDurationLabelSize = [[NSString stringWithFormat:@"#%@  /  %@", videoListBaseModel.category, videoListBaseModel.videoDurtion] sizeWithFont:AndyVideoListBaseModelCategoryAndDurationFont];
    CGFloat categoryAndDurationLabelX = (cellW - categoryAndDurationLabelSize.width) / 2;
    
    _categoryAndDurationLabelF = (CGRect){{categoryAndDurationLabelX, categoryAndDurationLabelY}, categoryAndDurationLabelSize};
    
    _cellHeight = backgroundH;
}

@end
