//
//  UIControl.h
//  Statistics
//
//  Created by Alex Erf on 2/14/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface InterfaceController : NSObject <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UINavigationController * c_nav;
@property (strong, nonatomic) UIViewController * c_task;

-(id)initWithNavigationController:(UINavigationController *)nav;

-(void)addTask;

@end
