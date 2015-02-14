//
//  ViewController.h
//  Statistics
//
//  Created by Alex Erf on 2/12/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Account;

@interface MainViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext * moc;
@property (strong, nonatomic) Account * acc;

@end

