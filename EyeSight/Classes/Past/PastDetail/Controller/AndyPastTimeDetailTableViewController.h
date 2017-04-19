//
//  AndyPastTimeDetailTableViewController.h
//  EyeSight
//
//  Created by 李扬 on 15/12/7.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyCommonTableViewController.h"
#import "AndyPastDetailViewController.h"

@interface AndyPastTimeDetailTableViewController : AndyCommonTableViewController

@property (nonatomic, weak) AndyPastDetailViewController *pastDetailViewController;

@property (nonatomic, copy) NSString *cartegoryTimeDetailUrl;

@end
