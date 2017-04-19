//
//  AndyNavigationController.m
//  EyeSight
//
//  Created by 李扬 on 15/10/21.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyNavigationController.h"

@implementation AndyNavigationController

+ (void)initialize
{
    [self setupNavBarTheme];
    [self setupBarButtonItemTheme];
}

+ (void)setupBarButtonItemTheme
{
    //UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    
//    NSMutableDictionary *textDictionaryM = [NSMutableDictionary dictionary];
//    textDictionaryM[UITextAttributeTextColor] = [UIColor whiteColor];
//    textDictionaryM[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
//    //textDictionaryM[UITextAttributeFont] = [UIFont systemFontOfSize:15];
//    [item setTitleTextAttributes:textDictionaryM forState:UIControlStateNormal];
//    [item setTitleTextAttributes:textDictionaryM forState:UIControlStateHighlighted];
//    
//    NSMutableDictionary *disableTextDictionaryM = [NSMutableDictionary dictionary];
//    disableTextDictionaryM[UITextAttributeTextColor] = [UIColor lightGrayColor];
//    [item setTitleTextAttributes:disableTextDictionaryM forState:UIControlStateDisabled];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
//    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
//}

//- (BOOL)shouldAutorotate
//{
//    return NO;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskPortrait;
//}

//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return [self.topViewController supportedInterfaceOrientations];
//}
//
//- (BOOL)shouldAutorotate {
//    return self.topViewController.shouldAutorotate;
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    return [self.topViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
//}

+ (void)setupNavBarTheme
{
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    NSMutableDictionary *textDictionaryM = [NSMutableDictionary dictionary];
    textDictionaryM[UITextAttributeTextColor] = [UIColor blackColor];
    textDictionaryM[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
    //textDictionaryM[UITextAttributeFont] = [UIFont boldSystemFontOfSize:19];
    [navBar setTitleTextAttributes:textDictionaryM];
    
    [navBar setBarTintColor:AndyNavigationBarTintColor];
    [navBar setTintColor:[UIColor blackColor]];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0)
    {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

@end
