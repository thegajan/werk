//
//  TaskDetailView.m
//  Statistics
//
//  Created by Alex Erf on 3/20/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import "TaskDetailView.h"
#import "Task.h"
#import "ColorOptions.h"

@implementation TaskDetailView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
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
    _progressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _completionHeader = [[UILabel alloc] init];
    _dateInputPicker = [[UIDatePicker alloc] init];
    _confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_countdownLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_descriptionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_startDateLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_endDateLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_progressBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_dateInputPicker setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_confirmButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_completionHeader setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    _titleLabel.font = [UIFont fontWithName:@"Roboto-Thin" size:40];
    _countdownLabel.font = [UIFont fontWithName:@"Roboto-Thin" size:30];
    _descriptionView.font = [UIFont fontWithName:@"Roboto-Regular" size:20];
    _startDateLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:24];
    _endDateLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:24];
    _completionHeader.font = [UIFont fontWithName:@"Roboto-Medium" size:22];
    _confirmButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Light" size:24];;
    
    _descriptionView.editable = NO;
    _startDateLabel.textAlignment = NSTextAlignmentCenter;
    _endDateLabel.textAlignment = NSTextAlignmentCenter;
    _countdownLabel.textAlignment = NSTextAlignmentCenter;
    _progressBar.progressTintColor = [ColorOptions mainRed];
    _completionHeader.text = @" Time Finished ";
    [_confirmButton setTitle:@"Complete Task" forState:UIControlStateNormal];
    _confirmButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self styling];
    
    NSTimer * updateCountTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateCountdown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:updateCountTimer forMode:NSRunLoopCommonModes];
    
    NSTimer * updateProgressTimer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(updateProgressBar) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:updateProgressTimer forMode:NSRunLoopCommonModes];
}

-(void)styling {
    _completionHeader.layer.borderColor = [[UIColor blackColor] CGColor];
    _completionHeader.layer.cornerRadius = 9.0;
    _completionHeader.layer.borderWidth = 1.0;
    
    _confirmButton.backgroundColor = [ColorOptions secondaryGreen];
    _confirmButton.layer.cornerRadius = 9.0;
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(void)addUIElements {
    [self addSubview:_titleLabel];
    [self addSubview:_countdownLabel];
    [self addSubview:_descriptionView];
    [self addSubview:_startDateLabel];
    [self addSubview:_endDateLabel];
    [self addSubview:_progressBar];
    [self addSubview:_dateInputPicker];
    [self addSubview:_completionHeader];
    [self addSubview:_confirmButton];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_titleLabel]-5-[_descriptionView]-15-[_startDateLabel]-5-[_endDateLabel]-15-[_countdownLabel]-5-[_progressBar]-15-[_completionHeader(40)][_dateInputPicker]-5-[_confirmButton(54)]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel, _descriptionView, _startDateLabel, _endDateLabel, _countdownLabel, _progressBar, _completionHeader, _dateInputPicker, _confirmButton)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_titleLabel]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_descriptionView]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_descriptionView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_startDateLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_startDateLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_endDateLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_endDateLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_countdownLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_countdownLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_progressBar]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_progressBar)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_completionHeader]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_completionHeader)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_dateInputPicker]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_dateInputPicker)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_confirmButton]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_confirmButton)]];
}

-(void)setTask:(Task *)task {
    _task = task;
    _titleLabel.text = task.name;
    _descriptionView.text = task.task_description;
    
    if (_descriptionView.text.length == 0) {
        _descriptionView.text = @"<No Description>";
    }
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MMMM d, yyyy 'at' h:mm a";
    
    _startDateLabel.text = [dateFormatter stringFromDate:task.t_start];
    _endDateLabel.text = [dateFormatter stringFromDate:task.t_end];
    
    [self updateCountdown];
}

-(void)updateCountdown {
    NSDate * now = [NSDate date];
    if (!_task) {
        _countdownLabel.text = @"ERROR NO TASK";
    }
    else if ([now compare:_task.t_end] != NSOrderedAscending) {
        _countdownLabel.text = @"Finished!";
    }
    else {
        NSCalendar * calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents * timeRemaining = [calendar components:NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:now toDate:_task.t_end options:0];
        
        NSInteger days = timeRemaining.day;
        NSInteger hours = timeRemaining.hour;
        NSInteger minutes = timeRemaining.minute;
        NSInteger seconds = timeRemaining.second;
        
        if (days > 99999) {
            _countdownLabel.text = @"A Long Time";
        }
        else {
            _countdownLabel.text = [NSString stringWithFormat:@"%ld d . %ld h . %ld m . %ld s", days, hours, minutes, seconds];
        }
    }
}

-(void)updateProgressBar {
    NSDate * now = [NSDate date];
    if (!_task) {
        [_progressBar setProgress:0.0 animated:NO];
    }
    else if ([now compare:_task.t_end] != NSOrderedAscending) {
        [_progressBar setProgress:1.0 animated:YES];
    }
    else {
        double startToNow = [now timeIntervalSinceDate:_task.t_start];
        double total = [_task.t_end timeIntervalSinceDate:_task.t_start];
        
        [_progressBar setProgress:startToNow / total animated:NO];
    }

}

@end
