//
//  Account.h
//  Statistics
//
//  Created by Alex Erf on 2/19/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Task;

@interface Account : NSManagedObject

@property (nonatomic) int64_t last_event_id;
@property (nonatomic, retain) NSDate * last_synced;
@property (nonatomic, retain) NSString * password;
@property (nonatomic) int64_t user_id;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *task_list;
@end

@interface Account (CoreDataGeneratedAccessors)

- (void)addTask_listObject:(Task *)value;
- (void)removeTask_listObject:(Task *)value;
- (void)addTask_list:(NSSet *)values;
- (void)removeTask_list:(NSSet *)values;

@end
