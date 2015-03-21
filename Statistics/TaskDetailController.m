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
    self.view = [[TaskDetailView alloc] init];
}

-(void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    _detailView.task = _task;
}

@end
