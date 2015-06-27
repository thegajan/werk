//
//  TaskDetailController.m
//  Statistics
//
//  Created by Alex Erf on 3/20/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import "TaskDetailController.h"
#import "TaskDetailView.h"

@interface TaskDetailController () {
    TaskDetailView * _detailView;
}
@end

static const int HEIGHT = 736;

@implementation TaskDetailController

-(void)viewDidLoad {
    [super viewDidLoad];
    CGRect frame = self.view.frame;
    self.view = [[UIScrollView alloc] initWithFrame:frame];
    frame.size.height = HEIGHT;
    _detailView = [[TaskDetailView alloc] initWithFrame:frame];
    ((UIScrollView *)self.view).contentSize = _detailView.frame.size;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_detailView];
    [_detailView addUIElements];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _detailView.task = _task;
}

-(void)setTask:(Task *)task {
    _task = task;
    _detailView.task = task;
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    size.height = HEIGHT;
    CGRect frame = _detailView.frame;
    frame.size.width = size.width;
    _detailView.frame = frame;
    ((UIScrollView *)self.view).contentSize = _detailView.frame.size;
}

@end
