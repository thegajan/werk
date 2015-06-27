//
//  TaskDetailView.h
//  Statistics
//
//  Created by Alex Erf on 3/20/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Task;

@interface TaskDetailView : UIView

@property (strong, nonatomic) Task * task;

@property (strong, nonatomic) UILabel * titleLabel;
@property (strong, nonatomic) UILabel * countdownLabel;
@property (strong, nonatomic) UITextView * descriptionView;
@property (strong, nonatomic) UILabel * startDateLabel;
@property (strong, nonatomic) UILabel * endDateLabel;
@property (strong, nonatomic) UIProgressView * progressBar;
@property (strong, nonatomic) UILabel * completionHeader;
@property (strong, nonatomic) UIDatePicker * dateInputPicker;
@property (strong, nonatomic) UIButton * confirmButton;

-(void)addUIElements;

@end
