//
//  SyncUtility.m
//  Statistics
//
//  Created by Alex Erf on 2/15/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import "SyncUtility.h"
#import "Account.h"
#import "CoreDataHandler.h"
#import "Task.h"

#define SECONDS_PER_SYNC 10
#define TIMEOUT 9

const char * address = "https://www.readmybluebutton.com/werk/mobile_php/addTask.php";
//const char * address = "http://www.readmybluebutton.com/werk/mobile_php/test.php";

@implementation SyncUtility

+(SyncUtility *)sharedInstance {
    static SyncUtility * sharedInstance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedInstance = [SyncUtility alloc];
        sharedInstance = [sharedInstance init];
    });
    
    return sharedInstance;
}

-(void)syncDatabases {
    NSString * database = [self getDatabase];
    NSURL * url = [NSURL URLWithString:[NSString stringWithCString:address encoding:NSStringEncodingConversionAllowLossy]];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TIMEOUT];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[database dataUsingEncoding:NSUTF8StringEncoding]];
    _downloadData = [[NSMutableData alloc] init];
    NSLog(@"DATA SENT: %@", database);
    __unused NSURLConnection * conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(NSString *)getDatabase {
    NSMutableArray * data;
    NSMutableDictionary * totalData;
    NSMutableDictionary * taskInfo;
    NSDateFormatter * df;
    Account * acc = [CoreDataHandler getAccount];
    NSManagedObjectContext * moc = [[CoreDataHandler sharedInstance] moc];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"account==%@ && last_changed >= %@", acc, acc.last_synced];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [moc executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"COULD NOT FETCH EVENTS");
    }
    
    totalData = [NSMutableDictionary dictionary];
    data = [NSMutableArray array];
    df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    df.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    for (Task * task in fetchedObjects) {
        taskInfo = [NSMutableDictionary dictionary];
        [taskInfo setValue:task.name forKey:@"taskName"];
        [taskInfo setValue:task.task_description forKey:@"description"];
        [taskInfo setValue:[df stringFromDate:task.t_start] forKey:@"startDate"];
        [taskInfo setValue:[df stringFromDate:task.t_end] forKey:@"endDate"];
        
        if (task.should_delete.intValue) {
            [taskInfo setValue:@"delete" forKey:@"status"];
            [moc deleteObject:task];
        }
        else {
            [taskInfo setValue:@"create" forKey:@"status"];
        }
        
        [taskInfo setValue:task.local_id forKey:@"id"];
        [data addObject:taskInfo];
    }
    [totalData setObject:data forKey:@"info"];
    [totalData setObject:acc.user_id forKey:@"creator_id"];
    [totalData setObject:[df stringFromDate:acc.last_synced] forKey:@"last_updated"];
    NSError * err;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:totalData options:NSJSONWritingPrettyPrinted error:&err];
    if (!jsonData) {
        NSLog(@"%@", err);
        return @"";
    }
    [CoreDataHandler saveContext];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

-(void)startSyncLoop {
    NSTimer * timer = [NSTimer timerWithTimeInterval:SECONDS_PER_SYNC target:self selector:@selector(syncDatabases) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_downloadData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSManagedObjectContext * moc = [[CoreDataHandler sharedInstance] moc];
    NSFetchRequest * fetchRequest;
    NSEntityDescription * entity;
    NSPredicate * predicate;
    NSError * error;
    NSArray * fetchedObjects;
    Task * task;
    NSString * response = [[NSString alloc] initWithData:_downloadData encoding:NSUTF8StringEncoding];
    [CoreDataHandler sharedInstance].acc.last_synced = [NSDate new];
    NSLog(@"RESPONSE: %@", response);
    
    NSError * err;
    id jsonArray = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&err];
    
    for (NSDictionary * object in jsonArray) {
        if ([object objectForKey:@"old_id"]) {
            fetchRequest = [[NSFetchRequest alloc] init];
            entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:moc];
            [fetchRequest setEntity:entity];
            predicate = [NSPredicate predicateWithFormat:@"local_id==%@", [object objectForKey:@"old_id"]];
            [fetchRequest setPredicate:predicate];
            
            error = nil;
            fetchedObjects = [moc executeFetchRequest:fetchRequest error:&error];
            if (fetchedObjects == nil) {
                NSLog(@"ERROR: COULD NOT FETCH TASKS");
            }
            else if (fetchedObjects.count > 1) {
                NSLog(@"ERROR: MORE THAN ONE TASK WITH SAME LOCAL ID");
            }
            else if (fetchedObjects.class == 0) {
                NSLog(@"ERROR: NO TASKS WITH MATCHING LOCAL ID");
            }
            else {
                task = [fetchedObjects objectAtIndex:0];
                task.server_id = [object objectForKey:@"new_id"];
            }
        }
        else if ([object objectForKey:@"id"]) {
            task = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:[[CoreDataHandler sharedInstance] moc]];
            task.server_id = [object objectForKey:@"id"];
            task.task_description = [object objectForKey:@"task_description"];
            task.t_start = nil;
            task.t_end = nil;
            NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents * dc = [calendar components:NSCalendarUnitMinute fromDate:task.t_start toDate:task.t_end options:0];
            task.length = [NSNumber numberWithInteger:dc.minute * 60];
            task.account = [[CoreDataHandler sharedInstance] acc];
            task.last_changed = [NSDate new];
            task.should_delete = [NSNumber numberWithBool:NO];
            task.local_id = [CoreDataHandler getNextLocalID];
        }
    }
    [CoreDataHandler saveContext];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"ERROR: %@", error);
}

@end
