//
//  SelectableIconView.m
//  Organizer
//
//  Created by Splash on 4/18/15.
//  Copyright (c) 2015 Splash. All rights reserved.
//

#import "SelectableIconView.h"

#define kIconImageViewTag 1
#define kDotImageViewTag 2

@interface SelectableIconView() {
}

@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

@end

@implementation SelectableIconView

- (void)awakeFromNib
{
    self.iconImageView = (UIImageView *)[self viewWithTag:kIconImageViewTag];
    self.dotImageView = (UIImageView *)[self viewWithTag:kDotImageViewTag];
    
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                 action:@selector(viewTapped:)];
    [self addGestureRecognizer:_tapRecognizer];
}

- (void)viewTapped:(UITapGestureRecognizer *)recognizer
{
    [self.delegate iconSelected:self];
}

- (void)setSelected:(BOOL)selected
{
    if (_dotImageView.hidden == selected) {
        _dotImageView.hidden = !selected;
    }
}

- (BOOL)selected
{
    return !_dotImageView.hidden;
}

@end
