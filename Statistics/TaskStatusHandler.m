//
//  TaskStatusHandler.m
//  Statistics
//
//  Created by Alex Erf on 2/21/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import "TaskStatusHandler.h"
#import "Task.h"

#define i_currentTasks [self instance]->_currentTasks
#define i_futureTasks [self instance]->_futureTasks
#define i_currentController [self instance]->_currentController
#define i_futureController [self instance]->_futureController

@interface TaskStatusHandler () {
    NSMutableArray * _currentTasks;
    NSMutableArray * _futureTasks;
    NSFetchedResultsController * _currentController;
    NSFetchedResultsController * _futureController;
}
@end

@implementation TaskStatusHandler

+(void)initialLoad {
    static dispatch_once_t pred;
    static NSString * const c_cache = @"c_cache";
    static NSString * const f_cache = @"f_cache";
    
    dispatch_once(&pred, ^{
        [NSFetchedResultsController deleteCacheWithName:c_cache];
        [NSFetchedResultsController deleteCacheWithName:f_cache];
        
        NSManagedObjectContext * managedObjectContext = [[CoreDataHandler sharedInstance] moc];
        NSError * err;
        NSFetchRequest * c_request = [[NSFetchRequest alloc] init];
        NSEntityDescription * c_entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:managedObjectContext];
        [c_request setEntity:c_entity];
        NSSortDescriptor * s_sort = [NSSortDescriptor sortDescriptorWithKey:@"local_id" ascending:YES];
        [c_request setSortDescriptors:[NSArray arrayWithObject:s_sort]];
        NSPredicate * c_predicate = [NSPredicate predicateWithFormat:@"account == %@ && n_status == %d", [CoreDataHandler getAccount], TaskStatusCurrent];
        [c_request setPredicate:c_predicate];
        
        i_currentController = [[NSFetchedResultsController alloc] initWithFetchRequest:c_request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:c_cache];
        i_currentController.delegate = [self instance];
        if ([i_currentController performFetch:&err]) {
            i_currentTasks = [NSMutableArray arrayWithArray:i_currentController.fetchedObjects];
            NSLog(@"FETCHED %lu CURRENT TASKS",(unsigned long)i_currentTasks.count);
        }
        else
            NSLog(@"COULD NOT FETCH CURRENT TASKS: %@", err);
        
        
        NSFetchRequest * f_request = [[NSFetchRequest alloc] init];
        NSEntityDescription * f_entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:managedObjectContext];
        [f_request setEntity:f_entity];
        NSSortDescriptor * f_sort = [NSSortDescriptor sortDescriptorWithKey:@"local_id" ascending:YES];
        [f_request setSortDescriptors:[NSArray arrayWithObject:f_sort]];
        NSPredicate * f_predicate = [NSPredicate predicateWithFormat:@"account == %@ && n_status == %d", [CoreDataHandler getAccount], TaskStatusFuture];
        [f_request setPredicate:f_predicate];
        
        i_futureController = [[NSFetchedResultsController alloc] initWithFetchRequest:f_request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:f_cache];
        i_futureController.delegate = [self instance];
        if ([i_futureController performFetch:&err]) {
            i_futureTasks = [NSMutableArray arrayWithArray:i_futureController.fetchedObjects];
            NSLog(@"FETCHED %lu FUTURE TASKS",(unsigned long)i_futureTasks.count);
        }
        else
            NSLog(@"COULD NOT FETCH FUTURE TASKS: %@", err);
    });
    
}

+(void)updateTaskStatus {
    NSDate * now = [NSDate new];
    for (Task * task in i_currentTasks) {
        if ([now compare:task.t_end] == NSOrderedDescending || [now compare:task.t_end] == NSOrderedSame) {
            task.n_status = TaskStatusCompleted;
        }
    }
    for (Task * task in i_futureTasks) {
        if ([now compare:task.t_start] == NSOrderedDescending || [now compare:task.t_start] == NSOrderedSame) {
            task.n_status = TaskStatusCurrent;
        }
    }
    [CoreDataHandler saveContext];
}

+(TaskStatusHandler *)instance {
    static TaskStatusHandler * sharedInstance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedInstance = [TaskStatusHandler alloc];
        sharedInstance = [sharedInstance init];
    });
    
    return sharedInstance;
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            if (controller == _currentController)
                [_currentTasks addObject:anObject];
            else if (controller == _futureController)
                [_futureTasks addObject:anObject];
            NSLog(@"ADDED TASK TO STATUS HANDLER");
            break;
        case NSFetchedResultsChangeDelete:
            if (controller == _currentController)
                [_currentTasks removeObjectIdenticalTo:anObject];
            else if (controller == _futureController)
                [_futureTasks removeObjectIdenticalTo:anObject];
            NSLog(@"REMOVED TASK FROM STATUS HANDLER");
            break;
        case NSFetchedResultsChangeMove:
            NSLog(@"OBJECT MOVED");
            break;
        case NSFetchedResultsChangeUpdate:
            NSLog(@"OBJECT UPDATED");
            break;
    }
}

@end
