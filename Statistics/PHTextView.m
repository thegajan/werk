//
//  PHTextView.m
//  Statistics
//
//  Created by Alex Erf on 2/16/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import "PHTextView.h"

@interface PHTextView ()

@property (strong, nonatomic) UILabel * placeholderLabel;

@end

@implementation PHTextView

-(id)init {
    self = [super init];
    if (self) {
        _placeholderColor = [UIColor lightGrayColor];
        _placeholderText = @"";
        _placeholderLabel = [UILabel new];
        _placeholderLabel.textColor = _placeholderColor;
        _placeholderLabel.text = _placeholderText;
        _placeholderLabel.font = self.font;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:self];
        [_placeholderLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_placeholderLabel];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[_placeholderLabel]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_placeholderLabel)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_placeholderLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_placeholderLabel)]];
        [self sendSubviewToBack:_placeholderLabel];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _placeholderColor = [UIColor lightGrayColor];
        _placeholderText = @"";
        _placeholderLabel = [UILabel new];
        _placeholderLabel.textColor = _placeholderColor;
        _placeholderLabel.text = _placeholderText;
        _placeholderLabel.font = self.font;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:self];
        [_placeholderLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_placeholderLabel];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[_placeholderLabel]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_placeholderLabel)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_placeholderLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_placeholderLabel)]];
        [self sendSubviewToBack:_placeholderLabel];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _placeholderColor = [UIColor lightGrayColor];
        _placeholderText = @"";
        _placeholderLabel = [UILabel new];
        _placeholderLabel.textColor = _placeholderColor;
        _placeholderLabel.text = _placeholderText;
        _placeholderLabel.font = self.font;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:self];
        [_placeholderLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_placeholderLabel];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[_placeholderLabel]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_placeholderLabel)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_placeholderLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_placeholderLabel)]];
        [self sendSubviewToBack:_placeholderLabel];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    self = [super initWithFrame:frame textContainer:textContainer];
    if (self) {
        _placeholderColor = [UIColor lightGrayColor];
        _placeholderText = @"";
        _placeholderLabel = [UILabel new];
        _placeholderLabel.textColor = _placeholderColor;
        _placeholderLabel.text = _placeholderText;
        _placeholderLabel.font = self.font;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:self];
        [_placeholderLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_placeholderLabel];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[_placeholderLabel]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_placeholderLabel)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_placeholderLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_placeholderLabel)]];
        [self sendSubviewToBack:_placeholderLabel];
    }
    return self;
}

-(void)setFont:(UIFont *)font {
    [super setFont:font];
    _placeholderLabel.font = font;
}

-(void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    _placeholderLabel.textColor = placeholderColor;
}

-(void)setPlaceholderText:(NSString *)placeholderText {
    _placeholderText = placeholderText;
    _placeholderLabel.text = placeholderText;
}

-(void)textChanged:(NSNotification *)notification {
    if (self.text.length == 0)
        _placeholderLabel.alpha = 1.0;
    else
        _placeholderLabel.alpha = 0.0;
}

@end
