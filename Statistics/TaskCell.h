//
//  TaskCell.h
//  Statistics
//
//  Created by Alex Erf on 2/19/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Task;

@interface TaskCell : UITableViewCell

-(void)updateTimeDisplay;

@property (strong, nonatomic) Task * taskInfo;
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSDate * end;

@end