//
//  ViewController.h
//  Statistics
//
//  Created by Alex Erf on 2/12/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class Account;
@class TaskDetailController;

@interface MainViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) UICollectionView * taskView;
@property (strong, nonatomic) NSFetchedResultsController * fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) TaskDetailController * detailController;

@end

