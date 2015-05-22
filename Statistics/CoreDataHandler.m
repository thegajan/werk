//
//  CoreDataHandler.m
//  Statistics
//
//  Created by Alex Erf on 2/14/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import "CoreDataHandler.h"
#import "Task.h"
#import "Account.h"
#import "ColorOptions.h"

@implementation CoreDataHandler

+(CoreDataHandler *)sharedInstance {
    static CoreDataHandler * sharedInstance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedInstance = [CoreDataHandler alloc];
        sharedInstance = [sharedInstance init];
    });
    
    return sharedInstance;
}

+(void)saveContext {
    NSManagedObjectContext * moc = [[CoreDataHandler sharedInstance] moc];
    if (moc != nil) {
        NSError *error = nil;
        if ([moc hasChanges] && ![moc save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

+(void)createTaskWithName:(NSString *)name withDescription:(NSString *)description startsAt:(NSDate *)start endsAt:(NSDate *)end withColor:(int64_t)color {
    CoreDataHandler * cdh = [CoreDataHandler sharedInstance];
    if (cdh.moc != nil) {
        if (cdh.acc != nil) {
            Task * task = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:[[CoreDataHandler sharedInstance] moc]];
            task.name = name;
            task.task_description = description;
            task.t_start = start;
            task.t_end = end;
            NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents * dc = [calendar components:NSCalendarUnitMinute fromDate:start toDate:end options:0];
            task.length = dc.minute * 60;
            task.account = cdh.acc;
            task.last_changed = [NSDate new];
            task.should_delete = NO;
            task.local_id = [CoreDataHandler getNextLocalID];
            task.color = color;
            NSDate * now = [NSDate new];
            if (!([start compare:now] == NSOrderedAscending)) {
                task.n_status = TaskStatusFuture;
            }
            else if (!([end compare:now] == NSOrderedDescending)) {
                task.n_status = TaskStatusCompleted;
            }
            else
                task.n_status = TaskStatusCurrent;
            [CoreDataHandler saveContext];
        }
        else {
            NSLog(@"ACCOUNT NOT SET");
        }
    }
    else {
        NSLog(@"MANANGED OBJECT CONTEXT NOT SET");
    }
}

+(int64_t)getNextLocalID {
    int64_t n = [[CoreDataHandler sharedInstance] acc].last_event_id;
    [[[CoreDataHandler sharedInstance] acc] setLast_event_id:n + 1];
    [CoreDataHandler saveContext];
    return n;
}

+(Account *)getAccount {
    Account * account = [CoreDataHandler sharedInstance].acc;
    if (!account) {
        account = [NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:[[CoreDataHandler sharedInstance] moc]];
        account.last_synced = [NSDate distantPast];
        account.last_event_id = 1;
        [CoreDataHandler saveContext];
        // TODO: Setup account
    }
    return account;
}

@end
