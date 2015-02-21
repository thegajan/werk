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
}
@end

@implementation TaskCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _nameLabel = [UILabel new];
        _timeLabel = [UILabel new];
        
        [_nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_timeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _nameLabel.font = [UIFont fontWithName:@"Exo2-Light" size:20.0];
        _timeLabel.font = [UIFont fontWithName:@"OxygenMono-Regular" size:18.0];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_timeLabel];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-9-[_nameLabel(>=100)]-9-[_timeLabel]-9-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_nameLabel, _timeLabel)]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    }
    return self;
}

-(void)setName:(NSString *)name {
    _name = name;
    _nameLabel.text = name;
}

-(void)updateTimeDisplay {
    static NSString * const s_completed = @"Input Results";
    NSCalendar * calendar;
    switch (_taskInfo.n_status) {
        case TaskStatusCurrent:
            calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
            _timeRemaining = [calendar components:NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate new] toDate:_end options:0];
            
            NSInteger days = _timeRemaining.day;
            NSInteger hours = _timeRemaining.hour;
            NSInteger minutes = _timeRemaining.minute;
            NSInteger seconds = _timeRemaining.second;
            
            _timeLabel.text = [NSString stringWithFormat:@"%02ldd | %02ldh | %02ldm | %02lds", (long)days, (long)hours, (long)minutes, (long)seconds];
            break;
        case TaskStatusCompleted:
            _timeLabel.text = s_completed;
            break;
        case TaskStatusFuture:
            _timeLabel.text = [self stringForDate:_taskInfo.t_start];
            break;
        default:
            NSLog(@"INVALID TASK STATUS");
            break;
    }
    
}

-(NSString *)stringForDate:(NSDate *)date {
    NSDateFormatter * df = [NSDateFormatter new];
    NSDate * now = [NSDate new];
    NSDateComponents * nowComponents = [[NSCalendar currentCalendar] components: NSCalendarUnitYear fromDate:now];
    NSDateComponents * dateComponents = [[NSCalendar currentCalendar] components: NSCalendarUnitYear fromDate:date];
    NSDateComponents * diffComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:now toDate:date options:0];
    NSInteger nowDay = [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:now];
    NSInteger dateDay = [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:date];
    
    if (nowDay == dateDay)
        df.dateFormat = @"'Today at' hh:mm a";
    else if (nowDay + 1 == dateDay)
        df.dateFormat = @"'Tomorrow at' hh:mm a";
    else if (diffComponents.day < 7)
        df.dateFormat = @"EEEE 'at' hh:mm a";
    else if (dateComponents.year == nowComponents.year)
        df.dateFormat = @"MM'/'dd 'at' hh:mm a";
    else
        df.dateFormat = @"MM'/'dd'/'yy 'at' hh:mm a";
    return [df stringFromDate:date];
}

@end
