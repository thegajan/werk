//
//  AddTaskController.m
//  Statistics
//
//  Created by Alex Erf on 2/14/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import "AddTaskController.h"
#import "ColorOptions.h"

@interface AddTaskController ()

@end

@implementation AddTaskController

-(void)loadView {
    [super loadView];
    _titleInput = [[UITextField alloc] init];
    
    [_titleInput setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addUIComponents];
    [self loadBasicUI];
    [self createConstraints];
}

-(void)addUIComponents {
    [self.view addSubview:_titleInput];
}

-(void)loadBasicUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    _titleInput.backgroundColor = [UIColor whiteColor];
    _titleInput.layer.cornerRadius = 15.0;
    _titleInput.layer.borderColor = [ColorOptions mainRed].CGColor;
    _titleInput.layer.borderWidth = 3.0;
    _titleInput.font = [UIFont fontWithName:@"Exo2-Light" size:32];
    _titleInput.placeholder = @"Task Title";
    UIView * pad = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    pad.backgroundColor = _titleInput.backgroundColor;
    _titleInput.leftView = pad;
    _titleInput.leftViewMode = UITextFieldViewModeAlways;
}

-(void)createConstraints {
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[_titleInput(66)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleInput)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_titleInput]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleInput)]];
}

@end
