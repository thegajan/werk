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

@interface AddTaskView () {
    NSString * DEFAULT_DESCRIPTION;
    NSDate * startTime;
    NSDate * endTime;
    NSMutableArray * vertConstraints;
    NSMutableArray * horizConstraints;
    BOOL didCreateTask;
}

@end

@implementation AddTaskView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        didCreateTask = NO;
        _titleInput = [UITextField new];
        _descriptionInput = [UITextView new];
        _timePicker = [UIDatePicker new];
        _timeSelection = [[UISegmentedControl alloc] initWithItems:@[@"Start", @"End"]];
        _confirmTask = [UIButton new];
        
        _titleInput.delegate = self;
        _descriptionInput.delegate = self;
        
        [_titleInput setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_descriptionInput setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_timePicker setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_timeSelection setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_confirmTask setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        DEFAULT_DESCRIPTION = @"Task Description";
        [_confirmTask addTarget:self action:@selector(createTask) forControlEvents:UIControlEventTouchUpInside];
        [_timePicker addTarget:self action:@selector(timeChanged:) forControlEvents:UIControlEventValueChanged];
        [_timeSelection addTarget:self action:@selector(timeSelectionChanged:) forControlEvents:UIControlEventValueChanged];
        
        startTime = _timePicker.date;
        endTime = _timePicker.date;
        
        [self addSubview:_titleInput];
        [self addSubview:_descriptionInput];
        [self addSubview:_timePicker];
        [self addSubview:_timeSelection];
        [self addSubview:_confirmTask];
        
        [self loadBasicUI];
    }
    return self;
}

-(void)loadBasicUI {
    self.backgroundColor = [ColorOptions mainWhite];
    
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
    _descriptionInput.text = DEFAULT_DESCRIPTION;
    
    _timePicker.datePickerMode = UIDatePickerModeDateAndTime;
    
    _timeSelection.selectedSegmentIndex = 0;
    _timeSelection.tintColor = [ColorOptions mainRed];
    [_timeSelection setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Exo2-Black" size:18]} forState:UIControlStateNormal];
    
    _confirmTask.backgroundColor = [ColorOptions secondaryGreen];
    _confirmTask.layer.cornerRadius = 9.0;
    _confirmTask.titleLabel.font = [UIFont fontWithName:@"Exo2-Light" size:24];
    [_confirmTask setTitleColor:[ColorOptions mainWhite] forState:UIControlStateNormal];
    [_confirmTask setTitle:@"Create Task" forState:UIControlStateNormal];
    
    vertConstraints = [NSMutableArray new];
    horizConstraints = [NSMutableArray new];
    
    [vertConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[_titleInput(66)]-12-[_descriptionInput]-12-[_timeSelection(33)][_timePicker][_confirmTask(54)]-12-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleInput, _descriptionInput, _timePicker, _timeSelection, _confirmTask)]];
    [vertConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_titleInput]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleInput)]];
    [vertConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_descriptionInput]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_descriptionInput)]];
    [vertConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_timePicker]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_timePicker)]];
    [vertConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_timeSelection]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_timeSelection)]];
    [vertConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_confirmTask]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_confirmTask)]];

    [horizConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_titleInput(>=44,<=66)]-[_timeSelection(33)][_timePicker(>=60,<=200)][_confirmTask(54)]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleInput, _timePicker, _timeSelection, _confirmTask)]];
    [horizConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_descriptionInput]-[_confirmTask(54)]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_descriptionInput, _confirmTask)]];
    [horizConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_titleInput]-[_descriptionInput(==_titleInput)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleInput, _descriptionInput)]];
    [horizConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_timePicker]-[_descriptionInput(==_timePicker)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_timePicker, _descriptionInput)]];
    [horizConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_timeSelection]-[_descriptionInput(==_timeSelection)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_timeSelection, _descriptionInput)]];
    [horizConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_confirmTask]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_confirmTask)]];
}

-(void)updateConstraints {
    [super updateConstraints];
    if (self.frame.size.height > self.frame.size.width) {
        [NSLayoutConstraint deactivateConstraints:horizConstraints];
        [NSLayoutConstraint activateConstraints:vertConstraints];
    }
    else {
        [NSLayoutConstraint deactivateConstraints:vertConstraints];
        [NSLayoutConstraint activateConstraints:horizConstraints];
    }
}

-(void)timeChanged:(id)sender {
    if (_timeSelection.selectedSegmentIndex == 0) // Start Time
        startTime = _timePicker.date;
    else if (_timeSelection.selectedSegmentIndex == 1) // End Time
        endTime = _timePicker.date;
}

-(void)timeSelectionChanged:(id)sender {
    if (_timeSelection.selectedSegmentIndex == 0) // Start Time
        _timePicker.date = startTime;
    else if (_timeSelection.selectedSegmentIndex == 1) // End Time
        _timePicker.date = endTime;
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    if (textView == _descriptionInput)
        if ([_descriptionInput.text isEqualToString:DEFAULT_DESCRIPTION])
            _descriptionInput.text = @"";
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    if (textView == _descriptionInput)
        if ([_descriptionInput.text isEqualToString:@""])
            _descriptionInput.text = DEFAULT_DESCRIPTION;
}

-(void)removeKeyboard {
    [self endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self removeKeyboard];
    return NO;
}

-(void)resetOptions {
    if (didCreateTask) {
        _titleInput.text = @"";
        _descriptionInput.text = @"Task Description";
        _timePicker.date = [NSDate new];
        startTime = _timePicker.date;
        endTime = _timePicker.date;
        _timeSelection.selectedSegmentIndex = 0;
        didCreateTask = NO;
    }
}

-(void)createTask {
    [CoreDataHandler createTaskWithName:_titleInput.text withDescription:_descriptionInput.text startsAt:startTime endsAt:endTime];
    [[InterfaceController sharedInstance] popToRoot];
    [CoreDataHandler printAllTasks];
    didCreateTask = YES;
}

@end
