//
//  TaskDetailView.m
//  Statistics
//
//  Created by Alex Erf on 3/20/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import "TaskDetailView.h"
#import "Task.h"

@implementation TaskDetailView

-(id)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 0, 900);
        [self initializeUIElements];
    }
    return self;
}

-(void)initializeUIElements {
    _titleLabel = [[UILabel alloc] init];
    _countdownLabel = [[UILabel alloc] init];
    _descriptionView = [[UITextView alloc] init];
    _startDateLabel = [[UILabel alloc] init];
    _endDateLabel = [[UILabel alloc] init];
    _completionHeader = [[UILabel alloc] init];
    _dateInputPicker = [[UIDatePicker alloc] init];
    _confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_countdownLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_descriptionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_startDateLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_endDateLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_dateInputPicker setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_confirmButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    _titleLabel.font = [UIFont fontWithName:@"Roboto-Thin" size:40];
    _countdownLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:16];
    _descriptionView.font = [UIFont fontWithName:@"Roboto-Regular" size:22];
    _startDateLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:16];
    _endDateLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:16];
    _completionHeader.font = [UIFont fontWithName:@"Roboto-Medium" size:22];
    _confirmButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Thin" size:22];
    
    //_descriptionView.editable = NO;
    _descriptionView.backgroundColor = [UIColor blackColor];
}

-(void)addUIElements {
    [self addSubview:_titleLabel];
    [self addSubview:_countdownLabel];
    [self addSubview:_descriptionView];
    [self addSubview:_startDateLabel];
    [self addSubview:_endDateLabel];
    [self addSubview:_completionHeader];
    [self addSubview:_confirmButton];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_titleLabel]-10-[_descriptionView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel, _descriptionView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[_titleLabel]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[_descriptionView]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_descriptionView)]];

    NSLog(@"%@", self.constraints);
}

-(void)setTask:(Task *)task {
    _titleLabel.text = task.name;
    _descriptionView.text = @"test";
}

@end
