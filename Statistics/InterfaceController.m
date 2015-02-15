//
//  UIControl.m
//  Statistics
//
//  Created by Alex Erf on 2/14/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import "InterfaceController.h"

@implementation InterfaceController

-(id)initWithNavigationController:(UINavigationController *)nav {
    self = [super init];
    if (self) {
        _c_nav = nav;
    }
    return self;
}

-(void)addTask {
    [_c_nav pushViewController:_c_task animated:YES];
}

@end
