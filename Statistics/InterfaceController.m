//
//  UIControl.m
//  Statistics
//
//  Created by Alex Erf on 2/14/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import "InterfaceController.h"
#import "TaskDetailController.h"

@implementation InterfaceController

+(InterfaceController *)sharedInstance {
    static InterfaceController * sharedInstance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedInstance = [InterfaceController alloc];
        sharedInstance = [sharedInstance init];
    });
    
    return sharedInstance;
}

+(void)setNavController:(UINavigationController *)nav {
    [InterfaceController sharedInstance].c_nav = nav;
}

-(void)addTask {
    [_c_nav pushViewController:_c_task animated:YES];
    _c_nav.navigationBarHidden = NO;
}

-(void)popToRoot {
    _c_nav.navigationBarHidden = YES;
    [_c_nav popToRootViewControllerAnimated:YES];
}

-(BOOL)splitViewController:(UISplitViewController *)splitViewController showDetailViewController:(UIViewController *)vc sender:(id)sender {
    if (splitViewController.collapsed) {
        UINavigationController * nvc = [splitViewController.viewControllers objectAtIndex:0];
        [nvc pushViewController:vc animated:YES];
        return YES;
    }
    return NO;
}

-(BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    return YES;
}

@end
