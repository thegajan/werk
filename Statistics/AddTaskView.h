//
//  AddTaskView.h
//  Statistics
//
//  Created by Alex Erf on 2/15/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SuccessView;
@class PHTextView;

@interface AddTaskView : UIView <UITextFieldDelegate, UIPickerViewDelegate>

@property (strong, nonatomic) UITextField * titleInput;
@property (strong, nonatomic) PHTextView * descriptionInput;
@property (strong, nonatomic) UIDatePicker * timePicker;
@property (strong, nonatomic) UIButton * selectStart;
@property (strong, nonatomic) UISegmentedControl * timeSelection;
@property (strong, nonatomic) UIButton * confirmTask;
@property (strong, nonatomic) SuccessView * successView;

-(void)resetOptions;

@end
