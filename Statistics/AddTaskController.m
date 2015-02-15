//
//  AddTaskController.m
//  Statistics
//
//  Created by Alex Erf on 2/14/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import "AddTaskController.h"
#import "ColorOptions.h"

@interface AddTaskController () {
    NSString * DEFAULT_DESCRIPTION;
    NSDate * startTime;
    NSDate * endTime;
}

@end

@implementation AddTaskController

-(void)loadView {
    [super loadView];
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
    
    _screenTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeKeyboard)];
    DEFAULT_DESCRIPTION = @"Task Description";
    [_confirmTask addTarget:self action:@selector(createTask) forControlEvents:UIControlEventTouchUpInside];
    [_timePicker addTarget:self action:@selector(timeChanged:) forControlEvents:UIControlEventValueChanged];
    [_timeSelection addTarget:self action:@selector(timeSelectionChanged:) forControlEvents:UIControlEventValueChanged];

    startTime = _timePicker.date;
    endTime = _timePicker.date;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addUIComponents];
    [self loadBasicUI];
    [self createConstraints];
    
    [self.view addGestureRecognizer:_screenTapped];
}

-(void)addUIComponents {
    [self.view addSubview:_titleInput];
    [self.view addSubview:_descriptionInput];
    [self.view addSubview:_timePicker];
    [self.view addSubview:_timeSelection];
    [self.view addSubview:_confirmTask];
}

-(void)loadBasicUI {
    self.view.backgroundColor = [ColorOptions mainWhite];
    
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
}

-(void)createConstraints {
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[_titleInput(66)]-12-[_descriptionInput]-12-[_timeSelection(33)][_timePicker][_confirmTask(54)]-12-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleInput, _descriptionInput, _timePicker, _timeSelection, _confirmTask)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_titleInput]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleInput)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_descriptionInput]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_descriptionInput)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_timePicker]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_timePicker)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_timeSelection]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_timeSelection)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_confirmTask]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_confirmTask)]];
}

-(void)removeKeyboard {
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self removeKeyboard];
    return NO;
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

-(void)createTask {
    NSString * name = self.titleInput.text;
    NSString * description = self.descriptionInput.text;
}

@end
