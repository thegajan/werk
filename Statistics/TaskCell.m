//
//  TaskCell.m
//  Statistics
//
//  Created by Alex Erf on 2/19/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import "TaskCell.h"
#import "Task.h"
#import "ColorOptions.h"

@interface TaskCell () {
    UILabel * _nameLabel;
    UILabel * _timeLabel;
    UIView * _colorBlocker;
    NSDateComponents * _timeRemaining;
    NSDateFormatter * _df;
}
@end

@implementation TaskCell

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _isExpanded = YES;
        
        _df = [NSDateFormatter new];
        _nameLabel = [UILabel new];
        _timeLabel = [UILabel new];
        _colorBlocker = [UIView new];
        
        [_nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_timeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_colorBlocker setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _nameLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:30.0];
        _timeLabel.font = [UIFont fontWithName:@"Roboto-Thin" size:42.0];
        
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        
        _colorBlocker.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [ColorOptions mainRed];
        [self.contentView addSubview:_colorBlocker];
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_timeLabel];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-9-[_nameLabel]-9-[_timeLabel]-21-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_nameLabel, _timeLabel)]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-9-[_nameLabel]-9-[_timeLabel]-21-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_nameLabel, _timeLabel)]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_colorBlocker]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_colorBlocker)]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_colorBlocker]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_colorBlocker)]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    }
    return self;
}

-(void)setName:(NSString *)name {
    _name = name;
    _nameLabel.text = name;
}

-(void)updateTimeDisplay {
    static NSString * const s_completed = @"Finished";
    NSString * text;
    NSCalendar * calendar;
    switch (_taskInfo.n_status) {
        case TaskStatusCurrent:
            _timeLabel.font = [_timeLabel.font fontWithSize:42.0];
            calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
            _timeRemaining = [calendar components:NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate new] toDate:_end options:0];
            
            NSInteger days = _timeRemaining.day;
            NSInteger hours = _timeRemaining.hour;
            NSInteger minutes = _timeRemaining.minute;
            NSInteger seconds = _timeRemaining.second;
            
            if (days == 0) {
                if (hours == 0) {
                    if (minutes == 0) {
                        text = [NSString stringWithFormat:@"%ld Sec", (long)seconds];
                    }
                    else {
                        text = [NSString stringWithFormat:@"%ld Min", (long)minutes];
                    }
                }
                else {
                    text = [NSString stringWithFormat:@"%ld Hrs", (long)hours];
                }
            }
            else if (days >= 100) {
                    text = @"Far Future";
            }
            else {
                text = [NSString stringWithFormat:@"%ld Days", (long)days];
            }
            break;
        case TaskStatusCompleted:
            _timeLabel.font = [_timeLabel.font fontWithSize:42.0];
            text = s_completed;
            break;
        case TaskStatusFuture:
            _timeLabel.font = [_timeLabel.font fontWithSize:33.0];
            text = [self stringForDate:_taskInfo.t_start];
            break;
        default:
            NSLog(@"INVALID TASK STATUS");
            break;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        _timeLabel.text = text;
        [self updateColor];
    });
}

-(void)updateColor {
    int64_t length = [_end timeIntervalSinceDate:_start];
    int64_t remaining = [_end timeIntervalSinceNow];
    
    double transparency = (double)remaining / length;
    _colorBlocker.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0 - transparency];
}

-(NSString *)stringForDate:(NSDate *)date {
    NSDate * now = [NSDate new];
    NSDateComponents * nowComponents = [[NSCalendar currentCalendar] components: NSCalendarUnitYear fromDate:now];
    NSDateComponents * dateComponents = [[NSCalendar currentCalendar] components: NSCalendarUnitYear fromDate:date];
    NSDateComponents * diffComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:now toDate:date options:0];
    NSInteger nowDay = [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:now];
    NSInteger dateDay = [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:date];
    
    if (nowDay == dateDay)
        _df.dateFormat = @"hh:mm a";
    else if (nowDay + 1 == dateDay)
        _df.dateFormat = @"'Tomorrow at' h:mm a";
    else if (diffComponents.day < 7)
        _df.dateFormat = @"EEE h:mm a";
    else if (dateComponents.year == nowComponents.year)
        _df.dateFormat = @"M'/'d h:mm a";
    else
        _df.dateFormat = @"Next Year";
    return [_df stringFromDate:date];
}

@end
