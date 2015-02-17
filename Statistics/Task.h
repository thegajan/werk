//
//  Task.h
//  Statistics
//
//  Created by Alex Erf on 2/16/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Account;

@interface Task : NSManagedObject

@property (nonatomic, retain) NSDate * last_changed;
@property (nonatomic, retain) NSNumber * length;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * t_end;
@property (nonatomic, retain) NSDate * t_start;
@property (nonatomic, retain) NSString * task_description;
@property (nonatomic, retain) NSNumber * was_success;
@property (nonatomic, retain) NSNumber * event_id;
@property (nonatomic, retain) Account *account;

@end
