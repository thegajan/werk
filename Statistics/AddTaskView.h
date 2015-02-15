//
//  AddTaskView.h
//  Statistics
//
//  Created by Alex Erf on 2/15/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTaskView : UIView <UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate>

@property (strong, nonatomic) UITextField * titleInput;
@property (strong, nonatomic) UITextView * descriptionInput;
@property (strong, nonatomic) UIDatePicker * timePicker;
@property (strong, nonatomic) UIButton * selectStart;
@property (strong, nonatomic) UISegmentedControl * timeSelection;
@property (strong, nonatomic) UIButton * confirmTask;

@end