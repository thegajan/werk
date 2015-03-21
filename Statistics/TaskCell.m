//
//  TaskCell.m
//  Statistics
//
//  Created by Alex Erf on 2/19/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import "TaskCell.h"
#import "Task.h"

@interface TaskCell () {
    UILabel * _nameLabel;
    UILabel * _timeLabel;
    NSDateComponents * _timeRemaining;
    NSDateFormatter * _df;
}
@end

@implementation TaskCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _isExpanded = YES;
        
        _df = [NSDateFormatter new];
        _nameLabel = [UILabel new];
        _timeLabel = [UILabel new];
        
        [_nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_timeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _nameLabel.font = [UIFont fontWithName:@"Exo2-Light" size:20.0];
        _timeLabel.font = [UIFont fontWithName:@"OxygenMono-Regular" size:18.0];
                
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textAlignment = NSTextAlignmentRight;
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_timeLabel];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-9-[_nameLabel]-9-[_timeLabel]-9-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_nameLabel, _timeLabel)]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
        [_timeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
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
            calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
            _timeRemaining = [calendar components:NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate new] toDate:_end options:0];
            
            NSInteger days = _timeRemaining.day;
            NSInteger hours = _timeRemaining.hour;
            NSInteger minutes = _timeRemaining.minute;
            NSInteger seconds = _timeRemaining.second;
            
            if (days == 0) {
                if (hours == 0) {
                    if (minutes == 0) {
                        text = [NSString stringWithFormat:@"%lds", (long)seconds];
                    }
                    else {
                        text = [NSString stringWithFormat:@"%ldm | %02lds", (long)minutes, (long)seconds];
                    }
                }
                else {
                    text = [NSString stringWithFormat:@"%ldh | %02ldm | %02lds", (long)hours, (long)minutes, (long)seconds];
                }
            }
            else {
                text = [NSString stringWithFormat:@"%ldd | %02ldh | %02ldm | %02lds", (long)days, (long)hours, (long)minutes, (long)seconds];
            }
            break;
        case TaskStatusCompleted:
            text = s_completed;
            break;
        case TaskStatusFuture:
            text = [self stringForDate:_taskInfo.t_start];
            break;
        default:
            NSLog(@"INVALID TASK STATUS");
            break;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        _timeLabel.text = text;
    });
}

-(NSString *)stringForDate:(NSDate *)date {
    NSDate * now = [NSDate new];
    NSDateComponents * nowComponents = [[NSCalendar currentCalendar] components: NSCalendarUnitYear fromDate:now];
    NSDateComponents * dateComponents = [[NSCalendar currentCalendar] components: NSCalendarUnitYear fromDate:date];
    NSDateComponents * diffComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:now toDate:date options:0];
    NSInteger nowDay = [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:now];
    NSInteger dateDay = [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:date];
    
    if (nowDay == dateDay)
        _df.dateFormat = @"'Today at' hh:mm a";
    else if (nowDay + 1 == dateDay)
        _df.dateFormat = @"'Tomorrow at' hh:mm a";
    else if (diffComponents.day < 7)
        _df.dateFormat = @"EEEE 'at' hh:mm a";
    else if (dateComponents.year == nowComponents.year)
        _df.dateFormat = @"MM'/'dd 'at' hh:mm a";
    else
        _df.dateFormat = @"MM'/'dd'/'yy 'at' hh:mm a";
    return [_df stringFromDate:date];
}

@end
