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

@implementation TaskDetailController

-(id)init {
    self = [super init];
    if (self) {
        _detailView = [[TaskDetailView alloc] init];
    }
    return self;
}

-(void)loadView {
    self.view = _detailView;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [_detailView addUIElements];
}

-(void)viewWillAppear:(BOOL)animated {
    _detailView.task = _task;
}

-(void)setTask:(Task *)task {
    _task = task;
    _detailView.task = task;
}

@end
