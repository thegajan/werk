//
//  Account.h
//  Statistics
//
//  Created by Alex Erf on 2/14/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Account : NSManagedObject

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSSet *task_list;
@end

@interface Account (CoreDataGeneratedAccessors)

- (void)addTask_listObject:(NSManagedObject *)value;
- (void)removeTask_listObject:(NSManagedObject *)value;
- (void)addTask_list:(NSSet *)values;
- (void)removeTask_list:(NSSet *)values;

@end
