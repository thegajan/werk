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

@interface MainViewController () {
    NSTimer * _refreshTimer;
}
@end

@implementation MainViewController

-(void)loadView {
    [super loadView];
    _taskView = [[UITableView alloc] init];
    _taskView.dataSource = self;
    _taskView.delegate = self;
    [_taskView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
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
    NSNumber * tab = @(self.tabBarController.tabBar.frame.size.height);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_taskView]-tab-|" options:0 metrics:NSDictionaryOfVariableBindings(tab) views:NSDictionaryOfVariableBindings(_taskView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_taskView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_taskView)]];
}

-(void)openSettings {
    
}

-(void)presentTask:(Task *)task {
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[_fetchedResultsController sections] count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[_fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    }
    else
        return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const cell_id = @"task cell";
    TaskCell * cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[TaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

-(void)configureCell:(TaskCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Task * info = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.name = info.name;
    cell.end = info.t_end;
    cell.taskInfo = info;
    [cell updateTimeDisplay];
}
 
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([[_fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
        UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView * blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
        UILabel * header = [UILabel new];
        header.text = [NSString stringWithFormat:@" %@", [sectionInfo name]];
        header.font = [UIFont fontWithName:@"Exo2-Light" size:30.0];
        header.textColor = [ColorOptions mainRed];
        [header setTranslatesAutoresizingMaskIntoConstraints:NO];
        [blurView.contentView addSubview:header];
        [blurView.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[header]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(header)]];
        [blurView.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[header]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(header)]];
        return blurView;
    }
    else
        return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 51.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 51.0;
}

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [_taskView beginUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    NSLog(@"CHANGED SECTION: %ld", (unsigned long)sectionIndex);
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [_taskView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [_taskView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
    }
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    NSLog(@"CHANGED OBJECT ROW: %ld SECTION: %ld", (long)newIndexPath.row, (long)newIndexPath.section);
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [_taskView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [_taskView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(TaskCell *)[_taskView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [_taskView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [_taskView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [_taskView endUpdates];
}

-(void)refreshCellsAndTasks {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        dispatch_apply(_taskView.visibleCells.count, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(size_t i) {
            [_taskView.visibleCells[i] updateTimeDisplay];
        });
    });
    [TaskStatusHandler updateTaskStatus];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
