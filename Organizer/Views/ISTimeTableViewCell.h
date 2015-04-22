//
//  ISTimeTableViewCell.h
//  Organizer
//
//  Created by Splash on 4/14/15.
//  Copyright (c) 2015 Splash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectableIconView.h"
#import "Event.h"

typedef NS_ENUM(NSUInteger, ISTimeTableViewCellState) {
    ISTimeTableViewCellStateEmpty = 0,
    ISTimeTableViewCellStateShow   = 1,
    ISTimeTableViewCellStateEdite  = 2,
    ISTimeTableViewCellStateProperties = 3
};

@interface ISTimeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *showView;
@property (weak, nonatomic) IBOutlet UIView *editeView;
@property (weak, nonatomic) IBOutlet UIView *propertiesView;

// showView
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UIButton *stateButton;

// showView
@property (weak, nonatomic) IBOutlet UIButton *editeStateButton;
@property (weak, nonatomic) IBOutlet UITextField *noteTextField;

//propertiesView
@property (weak, nonatomic) IBOutlet UIButton *propertiesStateButton;
@property (weak, nonatomic) IBOutlet SelectableIconView *calendarIconView;
@property (weak, nonatomic) IBOutlet SelectableIconView *timeIconView;
@property (weak, nonatomic) IBOutlet UILabel *propertiesTimeLabel;

//other properties

@property (assign, nonatomic) ISTimeTableViewCellState cellState;
@property (strong, nonatomic) Event *event;
@property (strong, nonatomic) NSDate *date;

+ (NSString *)cellIdentifier;
+ (CGFloat)getCellHeight;

@end
