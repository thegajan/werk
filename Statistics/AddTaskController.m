//
//  AddTaskController.m
//  Statistics
//
//  Created by Alex Erf on 2/14/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import "AddTaskController.h"
#import "AddTaskView.h"

@interface AddTaskController ()

@end

@implementation AddTaskController

-(void)loadView {
    [super loadView];
    AddTaskView * view = [[AddTaskView alloc] initWithFrame:CGRectZero];
    self.view = view;
    _screenTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeKeyboard)];
}

-(void)viewWillAppear:(BOOL)animated {
    [(AddTaskView *)self.view resetOptions];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addGestureRecognizer:_screenTapped];
    [self.view setNeedsUpdateConstraints];
}

-(void)removeKeyboard {
    [self.view endEditing:YES];
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self.view setNeedsUpdateConstraints];
}

@end
