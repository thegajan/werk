//
//  ViewController.m
//  Statistics
//
//  Created by Alex Erf on 2/12/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import "MainViewController.h"
#import "ColorOptions.h"
#import "CoreDataHandler.h"
#import "TaskCell.h"
#import "Task.h"
#import "TaskStatusHandler.h"
#import "TaskDetailController.h"
#import "InterfaceController.h"
#import "ColorOptions.h"
#import "AppDelegate.h"

@interface MainViewController () {
    NSTimer * _refreshTimer;
    NSMutableDictionary * _objChanges;
    NSMutableDictionary * _sectChanges;
}
@end

@implementation MainViewController

-(void)loadView {
    [super loadView];
    _taskView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
    [_taskView registerClass:[TaskCell class] forCellWithReuseIdentifier:@"task cell"];
    _taskView.backgroundColor = [UIColor whiteColor];
    _taskView.dataSource = self;
    _taskView.delegate = self;
    [_taskView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    
    [self setUpDataFetch];
    [TaskStatusHandler initialLoad];
}

-(void)setUpDataFetch {
    static NSString * const cacheName = @"taskCache";
    
    [NSFetchedResultsController deleteCacheWithName:cacheName];
    
    _managedObjectContext = [[CoreDataHandler sharedInstance] moc];
    
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription * entityDescription = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"account == %@ && should_delete == NO", [CoreDataHandler getAccount]];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor * sortSection = [[NSSortDescriptor alloc] initWithKey:@"n_status" ascending:YES];
    NSSortDescriptor * sortTime = [[NSSortDescriptor alloc] initWithKey:@"t_end" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortSection, sortTime, nil]];
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath:@"s_status" cacheName:cacheName];
    
    NSError * err;
    _fetchedResultsController.delegate = self;
    if (![_fetchedResultsController performFetch:&err])
        NSLog(@"ERROR: FAILED TO FETCH EVENTS: %@", err);
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _refreshTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(refreshCellsAndTasks) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_refreshTimer forMode:NSRunLoopCommonModes];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_refreshTimer invalidate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addUIComponents];
    [self loadBasicUI];
    [self createContstraints];
}

-(void)addUIComponents {
    [self.view addSubview:_taskView];
}

-(void)loadBasicUI {
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)createContstraints {
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_taskView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_taskView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_taskView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_taskView)]];
}

-(void)openSettings {
    
}

-(void)presentTask:(Task *)task {
    _detailController.task = task;
    [[InterfaceController sharedInstance].splitVC showDetailViewController:_detailController.navigationController sender:self];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [[_fetchedResultsController sections] count];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([[_fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    }
    else
        return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const cell_id = @"task cell";
    TaskCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cell_id forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

-(void)configureCell:(TaskCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Task * info = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.name = info.name;
    cell.start = info.t_start;
    cell.end = info.t_end;
    cell.taskInfo = info;
    [cell updateTimeDisplay];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsLandscape(orientation)) {
        AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSInteger width = delegate.primaryColumnWidth;
        return CGSizeMake(width, 150);
    }
    else {
        CGFloat dim1 = [UIScreen mainScreen].bounds.size.width;
        CGFloat dim2 = [UIScreen mainScreen].bounds.size.height;
        return CGSizeMake((dim1 < dim2 ? dim1 : dim2) / 2, 201);
    }
}


-(void)orientationChanged:(NSNotification *)notification {
    [_taskView performBatchUpdates:nil completion:nil];
}

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    _objChanges = [NSMutableDictionary dictionary];
    _sectChanges = [NSMutableDictionary dictionary];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    NSLog(@"CHANGED SECTION: %ld", (unsigned long)sectionIndex);
    if (type == NSFetchedResultsChangeDelete || type == NSFetchedResultsChangeInsert) {
        NSMutableIndexSet * set = _sectChanges[@(type)];
        if (set) {
            [set addIndex:sectionIndex];
        }
        else {
            _sectChanges[@(type)] = [[NSMutableIndexSet alloc] initWithIndex:sectionIndex];
        }
    }
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    NSLog(@"CHANGED OBJECT ROW: %ld SECTION: %ld", (long)newIndexPath.row, (long)newIndexPath.section);
    
    NSMutableArray * set = _objChanges[@(type)];
    if (!set) {
        set = [NSMutableArray array];
        _objChanges[@(type)] = set;
    }
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [set addObject:newIndexPath];
            break;
        case NSFetchedResultsChangeDelete:
        case NSFetchedResultsChangeUpdate:
            [set addObject:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [set addObject:@[indexPath, newIndexPath]];
            break;
    }
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    NSMutableArray * moves = _objChanges[@(NSFetchedResultsChangeMove)];
    if (moves.count > 0) {
        NSMutableArray * updatedMoves = [[NSMutableArray alloc] initWithCapacity:moves.count];
        
        NSMutableIndexSet * insertSections = _sectChanges[@(NSFetchedResultsChangeInsert)];
        NSMutableIndexSet * deleteSections = _sectChanges[@(NSFetchedResultsChangeDelete)];
        for (NSArray * move in moves) {
            NSIndexPath * fromIP = move[0];
            NSIndexPath * toIP = move[1];
            
            if ([deleteSections containsIndex:fromIP.section]) {
                if (![insertSections containsIndex:toIP.section]) {
                    NSMutableArray * set = _objChanges[@(NSFetchedResultsChangeInsert)];
                    if (!set) {
                        set = [[NSMutableArray alloc] initWithObjects:toIP, nil];
                        _objChanges[@(NSFetchedResultsChangeInsert)] = set;
                    }
                    else {
                        [set addObject:toIP];
                    }
                }
            }
            else if ([insertSections containsIndex:toIP.section]) {
                NSMutableArray * set = _objChanges[@(NSFetchedResultsChangeDelete)];
                if (!set) {
                    set = [[NSMutableArray alloc] initWithObjects:fromIP, nil];
                    _objChanges[@(NSFetchedResultsChangeDelete)] = set;
                }
                else {
                    [set addObject:fromIP];
                }
            }
            else {
                [updatedMoves addObject:move];
            }
        }
        if (updatedMoves.count > 0) {
            _objChanges[@(NSFetchedResultsChangeMove)] = updatedMoves;
        }
        else {
            [_objChanges removeObjectForKey:@(NSFetchedResultsChangeMove)];
        }
    }
    
    NSMutableArray * toDelete = _objChanges[@(NSFetchedResultsChangeDelete)];
    if (toDelete.count > 0) {
        NSMutableIndexSet * deletedSections = _sectChanges[@(NSFetchedResultsChangeDelete)];
        [toDelete filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSIndexPath * evaluatedObject, NSDictionary * bindings) {
            return ![deletedSections containsIndex:evaluatedObject.section];
        }]];
    }
    
    NSMutableArray * toInsert = _objChanges[@(NSFetchedResultsChangeInsert)];
    if (toInsert.count > 0) {
        NSMutableIndexSet * insertedSections = _sectChanges[@(NSFetchedResultsChangeInsert)];
        [toInsert filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSIndexPath * evaluatedObject, NSDictionary * bindings) {
            return ![insertedSections containsIndex:evaluatedObject.section];
        }]];
    }
    
    UICollectionView * collectionView = _taskView;
    
    [collectionView performBatchUpdates:^{
        NSIndexSet * deletedSections = _sectChanges[@(NSFetchedResultsChangeDelete)];
        if (deletedSections.count > 0) {
            [collectionView deleteSections:deletedSections];
        }
        
        NSIndexSet * insertedSections = _sectChanges[@(NSFetchedResultsChangeInsert)];
        if (insertedSections.count > 0) {
            [collectionView insertSections:insertedSections];
        }
        
        NSArray * deletedItems = _objChanges[@(NSFetchedResultsChangeDelete)];
        if (deletedItems.count > 0) {
            [collectionView deleteItemsAtIndexPaths:deletedItems];
        }
        
        NSArray * insertedItems = _objChanges[@(NSFetchedResultsChangeInsert)];
        if (insertedItems.count > 0) {
            [collectionView insertItemsAtIndexPaths:insertedItems];
        }
        
        NSArray * reloadItems = _objChanges[@(NSFetchedResultsChangeUpdate)];
        if (reloadItems.count > 0) {
            [collectionView reloadItemsAtIndexPaths:reloadItems];
        }
        
        NSArray * moveItems = _objChanges[@(NSFetchedResultsChangeMove)];
        for (NSArray * paths in moveItems) {
            [collectionView moveItemAtIndexPath:paths[0] toIndexPath:paths[1]];
        }
    } completion:nil];
    
    _objChanges = nil;
    _sectChanges = nil;
    
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TaskCell * cell = (TaskCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self presentTask:cell.taskInfo];
}

-(void)refreshCellsAndTasks {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        for (TaskCell * cell in _taskView.visibleCells) {
            [cell updateTimeDisplay];
        }
    });
    [TaskStatusHandler updateTaskStatus];
}

@end
