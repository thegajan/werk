//
//  TaskStatusHandler.h
//  Statistics
//
//  Created by Alex Erf on 2/21/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CoreDataHandler.h"

@interface TaskStatusHandler : NSObject <NSFetchedResultsControllerDelegate>

+(void)initialLoad;
+(void)updateTaskStatus;

@end
