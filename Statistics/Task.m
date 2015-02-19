//
//  Task.m
//  Statistics
//
//  Created by Alex Erf on 2/19/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import "Task.h"
#import "Account.h"


@implementation Task

@dynamic last_changed;
@dynamic length;
@dynamic local_id;
@dynamic name;
@dynamic server_id;
@dynamic should_delete;
@dynamic s_status;
@dynamic t_end;
@dynamic t_start;
@dynamic task_description;
@dynamic was_success;
@dynamic account;

@synthesize n_status = _n_status;

-(void)setN_status:(int64_t)n_status {
    _n_status = n_status;
    
    switch (n_status) {
        case TaskStatusCurrent:
            self.s_status = @"Current";
            break;
        case TaskStatusFuture:
            self.s_status = @"Future";
            break;
        case TaskStatusCompleted:
            self.s_status = @"Finished";
            break;
        default:
            NSLog(@"INVALID TASK N_STATUS");
            break;
    }
}

@end
