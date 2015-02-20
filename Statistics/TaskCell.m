//
//  TaskCell.m
//  Statistics
//
//  Created by Alex Erf on 2/19/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import "TaskCell.h"


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
        
        _nameLabel.font = [UIFont fontWithName:@"Exo2-Black" size:24.0];
        _timeLabel.font = [UIFont fontWithName:@"Exo2-Light" size:24.0];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_timeLabel];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-9-[_nameLabel(>=100)]-9-[_timeLabel]-9-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_nameLabel, _timeLabel)]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    }
    return self;
}

-(void)setName:(NSString *)name {
    _name = name;
    _nameLabel.text = name;
}

-(void)updateTimeDisplay {
    
    NSCalendar * calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    _timeRemaining = [calendar components:NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate new] toDate:_end options:0];
    
    NSInteger days = _timeRemaining.day;
    NSInteger hours = _timeRemaining.hour;
    NSInteger minutes = _timeRemaining.minute;
    NSInteger seconds = _timeRemaining.second;
    
    _timeLabel.text = [NSString stringWithFormat:@"%ld d, %ld h, %ld m, %ld s", days, hours, minutes, seconds];
}

@end
