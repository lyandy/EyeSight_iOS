//
//  AndyCommonVideoDetailTableViewController.m
//  EyeSight
//
//  Created by 李扬 on 15/11/6.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyCommonVideoDetailTableViewController.h"
#import "AndyVideoDetailViewCell.h"
#import "AndyVideoListBaseModel.h"

@interface AndyCommonVideoDetailTableViewController()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation AndyCommonVideoDetailTableViewController

- (void)viewDidLoad
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    self.tableView = tableView;
    
    self.tableView.delegate  = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.pagingEnabled = YES;
    
    self.tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    
    self.tableView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    
    [self.view addSubview:self.tableView];
    
    self.tableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    
    self.tableView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height);
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.videoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AndyVideoDetailViewCell *cell = [AndyVideoDetailViewCell cellWithTableView:tableView];
    
    AndyVideoListBaseModel *detailModel = self.videoList[indexPath.row];
    
    cell.videoModel = detailModel;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //隐藏遮罩层和标题介绍
    
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIScreen mainScreen].bounds.size.width;
}

- (void)moviePlayerDidFinished
{
    if (self.commonVideoPlayerVC != nil)
    {
        [self dismissViewControllerAnimated:NO completion:nil];
        self.commonVideoPlayerVC = nil;
    }
}


@end
