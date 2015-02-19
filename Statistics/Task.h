//
//  Task.h
//  Statistics
//
//  Created by Alex Erf on 2/19/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef NS_ENUM(int64_t, TaskStatus) {
    TaskStatusCurrent = 0,
    TaskStatusFuture = 1,
    TaskStatusCompleted = 2
};

@class Account;

@interface Task : NSManagedObject

@property (nonatomic, retain) NSDate * last_changed;
@property (nonatomic) int64_t length;
@property (nonatomic) int64_t local_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic) int64_t server_id;
@property (nonatomic) BOOL should_delete;
@property (nonatomic, retain) NSString * s_status;
@property (nonatomic, retain) NSDate * t_end;
@property (nonatomic, retain) NSDate * t_start;
@property (nonatomic, retain) NSString * task_description;
@property (nonatomic) BOOL was_success;
@property (nonatomic) int64_t n_status;
@property (nonatomic, retain) Account *account;

@end
