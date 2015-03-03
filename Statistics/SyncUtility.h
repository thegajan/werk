//
//  SyncUtility.h
//  Statistics
//
//  Created by Alex Erf on 2/15/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SyncUtility : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSMutableData * downloadData;
@property (strong, nonatomic) void (^startLoadingBlock)(void);
@property (strong, nonatomic) void (^stopLoadingBlock)(void);

-(void)syncDatabases;
-(void)startSyncLoop;
+(SyncUtility *)sharedInstance;

@end
