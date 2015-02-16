//
//  SuccessView.m
//  Statistics
//
//  Created by Alex Erf on 2/15/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import "SuccessView.h"
#import "ColorOptions.h"

@implementation SuccessView

-(id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _check = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Check"]];
        _label = [UILabel new];
        _label.text = @"Task Created!";
        _label.textColor = [ColorOptions secondaryGreen];
        _label.font = [UIFont fontWithName:@"Exo2-Light" size:48];
        
        [_check setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_label setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_check];
        [self addSubview:_label];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_check attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_check attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    }
    return self;
}

@end
