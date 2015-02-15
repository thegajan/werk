//
//  UIControl.m
//  Statistics
//
//  Created by Alex Erf on 2/14/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import "InterfaceController.h"

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
}

-(void)popToRoot {
    [_c_nav popToRootViewControllerAnimated:YES];
}

@end
