//
//  CoreDataHandler.m
//  Statistics
//
//  Created by Alex Erf on 2/14/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import "CoreDataHandler.h"
#import "Task.h"

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

+(void)createTaskWithName:(NSString *)name withDescription:(NSString *)description startsAt:(NSDate *)start endsAt:(NSDate *)end {
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
            task.length = [NSNumber numberWithInteger:dc.minute * 60];
            task.account = cdh.acc;
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

+(Account *)getAccount {
    Account * account = [CoreDataHandler sharedInstance].acc;
    if (!account) {
        account = [NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:[[CoreDataHandler sharedInstance] moc]];
        [CoreDataHandler saveContext];
        // TODO: Setup account
    }
    return account;
}

@end
