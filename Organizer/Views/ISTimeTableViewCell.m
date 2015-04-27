//
//  ISTimeTableViewCell.m
//  Organizer
//
//  Created by Splash on 4/14/15.
//  Copyright (c) 2015 Splash. All rights reserved.
//

#import "ISTimeTableViewCell.h"
#import "MHNibLoading.h"
#import "ISDataManager.h"
#import <ActionSheetDatePicker.h>

#define kCalendarIconTag 1
#define kTimeIconTag 2


@interface ISTimeTableViewCell() <SelectableIconViewDelegate>
@end

@implementation ISTimeTableViewCell

#pragma mark – State

- (void)awakeFromNib {
    self.calendarIconView.delegate = self;
    self.timeIconView.delegate = self;
   // self.contentView.userInteractionEnabled = NO;
  //  [self.contentView bringSubviewToFront:self.editeView];
    
    [self.noteTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldDidChange :(UITextField *)textField
{
    self.noteLabel.text = textField.text;
    
    if(_event == nil) {
        self.event = [ISDataManager createNewEvent];
        self.event.date = self.date;
    }
    self.event.note = textField.text;
}

- (void)updateEventState
{
    self.noteLabel.text = _event.note;
    self.noteTextField.text = _event.note;
    self.stateButton.selected = [_event.completed boolValue];
    self.date = self.event.date;
}

#pragma mark – Setters & Getters

- (void)setDate:(NSDate *)date
{
    if(_date != date) {
        _date = date;
        self.timeLabel.text = [ISDataManager timeFromDate:date];
    }
}

- (void)setEvent:(Event *)event
{
    if(_event != event) {
        _event = event;
        [self updateEventState];
    }
}

- (void)setCellState:(ISTimeTableViewCellState)cellState
{
    if(_cellState != cellState) {
        
        switch (cellState) {
            case ISTimeTableViewCellStateEmpty:
                self.showView.hidden = YES;
                self.editeView.hidden = YES;
                self.propertiesView.hidden = YES;
                
                break;
            case ISTimeTableViewCellStateShow:
                self.showView.hidden = NO;
                self.editeView.hidden = YES;
                self.propertiesView.hidden = YES;
                
                break;
            case ISTimeTableViewCellStateEdite:
                self.showView.hidden = YES;
                self.editeView.hidden = NO;
                self.propertiesView.hidden = YES;
                
                break;
            case ISTimeTableViewCellStateProperties:
                self.showView.hidden = YES;
                self.editeView.hidden = YES;
                self.propertiesView.hidden = NO;
                
                break;
            default:
                NSLog(@"Undefined cell state on ISTimeTableViewCell");
                break;
        }
        
        _cellState = cellState;
    }
}

#pragma mark – <UITableViewDataSource>

- (void)iconSelected:(SelectableIconView *)iconView
{
    NSLog(@"iconSelected: %ld", (long)iconView.tag);
    switch (iconView.tag) {
        case kCalendarIconTag:
        {
            BOOL newIconState = !self.calendarIconView.selected;
            [self.calendarIconView setSelected: newIconState];
            [self showCalendarPicker];
        }
            break;
        case kTimeIconTag:
        {
            BOOL newIconState = !self.timeIconView.selected;
            [self.timeIconView setSelected: newIconState];
            [self showTimeCalendarPicker];
        }
            break;
        default:
            NSLog(@"Undefined icon tag on ISTimeTableViewCell");
            break;
    }
}

- (void)showCalendarPicker
{
    [ActionSheetDatePicker showPickerWithTitle:@"Select date"
                                datePickerMode:UIDatePickerModeDate
                                  selectedDate:self.date
                                     doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                                         self.date = [ISDataManager useSameTimeAsDate:self.date butOnADifferentDate:selectedDate];
                                         NSLog(@"Picker: %@", picker);
                                         NSLog(@"Selected date: %@", selectedDate);
                                         NSLog(@"Selected origin: %@", origin);
                                         [self.calendarIconView setSelected:NO];
                                     } cancelBlock:^(ActionSheetDatePicker *picker) {
                                          NSLog(@"Block Picker Canceled");
                                         [self.calendarIconView setSelected:NO];
                                     } origin:self];
}

- (void)showTimeCalendarPicker
{
    [ActionSheetDatePicker showPickerWithTitle:@"Select time"
                                datePickerMode:UIDatePickerModeTime
                                  selectedDate:self.date
                                     doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                                         self.date = [ISDataManager useSameTimeAsDate:selectedDate butOnADifferentDate:self.date];
                                         NSLog(@"Picker: %@", picker);
                                         NSLog(@"Selected date: %@", selectedDate);
                                         NSLog(@"Selected origin: %@", origin);
                                         [self.timeIconView setSelected:NO];
                                     } cancelBlock:^(ActionSheetDatePicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                         [self.timeIconView setSelected:NO];
                                     } origin:self];
}

#pragma mark – Actions

- (IBAction)stateButtonPressed:(UIButton *)sender
{
    if(_event != nil) {
        BOOL eventState = [_event.completed boolValue];
        _event.completed = [NSNumber numberWithBool:!eventState];
        [self updateEventState];
    }
}

- (IBAction)editeStateButtonPressed:(UIButton *)sender
{
    self.cellState = ISTimeTableViewCellStateProperties;
}

- (IBAction)propertiesStateButtonPressed:(UIButton *)sender
{
    self.cellState = ISTimeTableViewCellStateShow;
    if([self.event.note length] > 0) {
        [ISDataManager saveToDataBaseWithCompletion:nil];
    } else if(self.event != nil) {
        [ISDataManager deleteEvent:self.event];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        [self setCellState:ISTimeTableViewCellStateEdite];
    } else {
        [self setCellState:ISTimeTableViewCellStateShow];
    }
}

//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
//{
//    if (highlighted) {
//        [self setCellState:ISTimeTableViewCellStateEdite];
//    } else {
//        [self setCellState:ISTimeTableViewCellStateShow];
//    }
//}

#pragma mark – Static

+ (NSString *)cellIdentifier
{
    static NSString *cellIdentifier = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        cellIdentifier = NSStringFromClass([self class]);
    });
    return cellIdentifier;
}

+ (CGFloat)getCellHeight
{
    static CGFloat viewHeight = 0.0;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        UIView *view = [[self class] loadInstanceFromNib];
        viewHeight = view.bounds.size.height;
    });
    return viewHeight;
}

@end
