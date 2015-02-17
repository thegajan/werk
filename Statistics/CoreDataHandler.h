//
//  CoreDataHandler.h
//  Statistics
//
//  Created by Alex Erf on 2/14/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Account;

@interface CoreDataHandler : NSObject

@property (strong, nonatomic) NSManagedObjectContext * moc;
@property (strong, nonatomic) Account * acc;

+(CoreDataHandler *)sharedInstance;
+(void)createTaskWithName:(NSString *)name withDescription:(NSString *)description startsAt:(NSDate *)start endsAt:(NSDate *)end;
+(void)saveContext;
+(Account *)getAccount;


@end
