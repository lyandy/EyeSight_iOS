//
//  AndyCommonTableViewController.h
//  EyeSight
//
//  Created by 李扬 on 15/11/4.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AndyCommonTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *videoList;

- (void)beginRefresh;

@end
