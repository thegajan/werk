//
//  AddTaskView.m
//  Statistics
//
//  Created by Alex Erf on 2/15/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import "AddTaskView.h"
#import "CoreDataHandler.h"
#import "InterfaceController.h"
#import "ColorOptions.h"
#import "SuccessView.h"
#import "PHTextView.h"

@interface AddTaskView () {
    NSDate * _startTime;
    NSDate * _endTime;
    NSMutableArray * _vertConstraints;
    NSMutableArray * _horizConstraints;
    BOOL _didCreateTask;
    
    NSString * _confirmText;
    UIColor * _confirmColor;
}

@end

@implementation AddTaskView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _didCreateTask = NO;
        _titleInput = [UITextField new];
        _descriptionInput = [PHTextView new];
        _timePicker = [UIDatePicker new];
        _timeSelection = [[UISegmentedControl alloc] initWithItems:@[@"Start", @"End"]];
        _confirmTask = [UIButton new];
        _successView = [SuccessView new];
        
        _titleInput.delegate = self;
        
        [_titleInput setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_descriptionInput setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_timePicker setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_timeSelection setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_confirmTask setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_successView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [_confirmTask addTarget:self action:@selector(attemptToCreateTask) forControlEvents:UIControlEventTouchUpInside];
        [_timePicker addTarget:self action:@selector(timeChanged:) forControlEvents:UIControlEventValueChanged];
        [_timeSelection addTarget:self action:@selector(timeSelectionChanged:) forControlEvents:UIControlEventValueChanged];
        
        NSTimeInterval t = floor([[NSDate date] timeIntervalSinceReferenceDate] / 60.0) * 60.0;
        _timePicker.date = [NSDate dateWithTimeIntervalSinceReferenceDate:t];
        _startTime = _timePicker.date;
        _endTime = _timePicker.date;
        
        [self addSubview:_titleInput];
        [self addSubview:_descriptionInput];
        [self addSubview:_timePicker];
        [self addSubview:_timeSelection];
        [self addSubview:_confirmTask];
        [self addSubview:_successView];
        
        [self loadBasicUI];
    }
    return self;
}

-(void)loadBasicUI {
    self.backgroundColor = [ColorOptions mainWhite];
    
    _confirmText = @"Create Task";
    _confirmColor = [ColorOptions secondaryGreen];
    
    _titleInput.backgroundColor = [ColorOptions mainWhite];
    _titleInput.layer.cornerRadius = 9.0;
    _titleInput.layer.borderColor = [ColorOptions mainRed].CGColor;
    _titleInput.layer.borderWidth = 1.0;
    _titleInput.font = [UIFont fontWithName:@"Exo2-Light" size:32];
    _titleInput.placeholder = @"Task Name";
    UIView * pad = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    pad.backgroundColor = _titleInput.backgroundColor;
    _titleInput.leftView = pad;
    _titleInput.leftViewMode = UITextFieldViewModeAlways;
    _titleInput.returnKeyType = UIReturnKeyDone;
    
    _descriptionInput.backgroundColor = [ColorOptions mainWhite];
    _descriptionInput.layer.cornerRadius = 9.0;
    _descriptionInput.layer.borderColor = [ColorOptions mainRed].CGColor;
    _descriptionInput.layer.borderWidth = 1.0;
    _descriptionInput.font = [UIFont fontWithName:@"Exo2-Light" size:22];
    _descriptionInput.placeholderText = @"Task Description";
    
    _timePicker.datePickerMode = UIDatePickerModeDateAndTime;
    
    _timeSelection.selectedSegmentIndex = 0;
    _timeSelection.tintColor = [ColorOptions mainRed];
    [_timeSelection setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Exo2-Black" size:18]} forState:UIControlStateNormal];
    
    _confirmTask.backgroundColor = _confirmColor;
    _confirmTask.layer.cornerRadius = 9.0;
    _confirmTask.titleLabel.font = [UIFont fontWithName:@"Exo2-Light" size:24];
    [_confirmTask setTitleColor:[ColorOptions mainWhite] forState:UIControlStateNormal];
    [_confirmTask setTitle:_confirmText forState:UIControlStateNormal];
    
    _vertConstraints = [NSMutableArray new];
    _horizConstraints = [NSMutableArray new];
    
    _successView.hidden = YES;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_successView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_successView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_successView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_successView)]];
    
    [_vertConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[_titleInput(66)]-12-[_descriptionInput]-12-[_timeSelection(33)][_timePicker][_confirmTask(54)]-12-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleInput, _descriptionInput, _timePicker, _timeSelection, _confirmTask)]];
    [_vertConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_titleInput]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleInput)]];
    [_vertConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_descriptionInput]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_descriptionInput)]];
    [_vertConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_timePicker]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_timePicker)]];
    [_vertConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_timeSelection]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_timeSelection)]];
    [_vertConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_confirmTask]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_confirmTask)]];

    [_horizConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_titleInput(>=44,<=66)]-[_timeSelection(33)][_timePicker(>=60,<=200)][_confirmTask(54)]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleInput, _timePicker, _timeSelection, _confirmTask)]];
    [_horizConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_descriptionInput]-[_confirmTask(54)]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_descriptionInput, _confirmTask)]];
    [_horizConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_titleInput]-[_descriptionInput(==_titleInput)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleInput, _descriptionInput)]];
    [_horizConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_timePicker]-[_descriptionInput(==_timePicker)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_timePicker, _descriptionInput)]];
    [_horizConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_timeSelection]-[_descriptionInput(==_timeSelection)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_timeSelection, _descriptionInput)]];
    [_horizConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_confirmTask]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_confirmTask)]];
}

-(void)updateConstraints {
    [super updateConstraints];
    if (self.frame.size.height > self.frame.size.width) {
        [NSLayoutConstraint deactivateConstraints:_horizConstraints];
        [NSLayoutConstraint activateConstraints:_vertConstraints];
    }
    else {
        [NSLayoutConstraint deactivateConstraints:_vertConstraints];
        [NSLayoutConstraint activateConstraints:_horizConstraints];
    }
}

-(void)timeChanged:(id)sender {
    if (_timeSelection.selectedSegmentIndex == 0) // Start Time
        _startTime = _timePicker.date;
    else if (_timeSelection.selectedSegmentIndex == 1) // End Time
        _endTime = _timePicker.date;
}

-(void)timeSelectionChanged:(id)sender {
    if (_timeSelection.selectedSegmentIndex == 0) // Start Time
        _timePicker.date = _startTime;
    else if (_timeSelection.selectedSegmentIndex == 1) // End Time
        _timePicker.date = _endTime;
}

-(void)removeKeyboard {
    [self endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self removeKeyboard];
    return NO;
}

-(void)resetOptions {
    if (_didCreateTask) {
        _titleInput.text = @"";
        _descriptionInput.text = @"";
        NSTimeInterval t = floor([[NSDate date] timeIntervalSinceReferenceDate] / 60.0) * 60.0;
        _timePicker.date = [NSDate dateWithTimeIntervalSinceReferenceDate:t];
        _startTime = _timePicker.date;
        _endTime = _timePicker.date;
        _timeSelection.selectedSegmentIndex = 0;
        _successView.hidden = YES;
        _didCreateTask = NO;
    }
}

-(void)attemptToCreateTask {
    if (_titleInput.text.length == 0)
        [self displayErrorWithMessage:@"Incomplete Form"];
    else if (!([_endTime compare:_startTime] == NSOrderedDescending))
        [self displayErrorWithMessage:@"Invalid Dates"];
    else
        [self createTask];
}

-(void)displayErrorWithMessage:(NSString *)text {
    [_confirmTask setBackgroundColor:[ColorOptions secondaryRed]];
    [_confirmTask setTitle:text forState:UIControlStateNormal];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_confirmTask setBackgroundColor:_confirmColor];
        [_confirmTask setTitle:_confirmText forState:UIControlStateNormal];
    });
}

-(void)createTask {
    [CoreDataHandler createTaskWithName:_titleInput.text withDescription:_descriptionInput.text startsAt:_startTime endsAt:_endTime withColor:0xFFFFFF];
    _successView.hidden = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[InterfaceController sharedInstance] popToRoot];
    });
    _didCreateTask = YES;
}

@end
