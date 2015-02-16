//
//  SyncUtility.m
//  Statistics
//
//  Created by Alex Erf on 2/15/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import "SyncUtility.h"

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

@end
