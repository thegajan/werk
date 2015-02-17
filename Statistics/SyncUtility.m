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
    NSURLConnection * conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(NSString *)getDatabase {
    NSMutableArray * data;
    NSMutableDictionary * taskInfo;
    Account * acc = [CoreDataHandler getAccount];
    NSManagedObjectContext * moc = [[CoreDataHandler sharedInstance] moc];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"account==%@", acc];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [moc executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"COULD NOT FETCH EVENTS");
    }
    
    data = [NSMutableArray array];
    // mm/dd/yyyy hh:ss:00 A
    // $taskName = $a['taskName'];
    // $description = $a['description'];
    // $startDate = $a['startDate'];
    // $endDate = $a['endDate'];
    // $creator = "1";
    // $status = $a['status'];
    for (Task * task in fetchedObjects) {
        // Check if task is new (since last synced date)
        NSDateFormatter * df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"MM/dd/yyyy hh:mm:ss a";
        taskInfo = [NSMutableDictionary dictionary];
        [taskInfo setValue:task.name forKey:@"taskName"];
        [taskInfo setValue:task.task_description forKey:@"description"];
        [taskInfo setValue:[df stringFromDate:task.t_start] forKey:@"startDate"];
        [taskInfo setValue:[df stringFromDate:task.t_end] forKey:@"endDate"];
        [taskInfo setValue:acc.user_id forKey:@"creator"];
        //[taskInfo setValue:@"" forKey:<#(NSString *)#>]
        // finish adding items
        [data addObject:taskInfo];
    }
    NSError * err;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&err];
    if (!jsonData) {
        NSLog(@"%@", err);
        return @"";
    }
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
    NSString * response = [[NSString alloc] initWithData:_downloadData encoding:NSUTF8StringEncoding];
    NSLog(@"RESPONSE: %@", response);
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"ERROR: %@", error);
}

@end
