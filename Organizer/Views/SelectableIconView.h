//
//  SelectableIconView.h
//  Organizer
//
//  Created by Splash on 4/18/15.
//  Copyright (c) 2015 Splash. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectableIconView;

@protocol SelectableIconViewDelegate <NSObject>

- (void)iconSelected:(SelectableIconView *)iconView;

@end

@interface SelectableIconView : UIView

@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, weak) UIImageView *dotImageView;
@property (nonatomic, assign) BOOL selected;

@property (nonatomic, assign) id<SelectableIconViewDelegate> delegate;

@end
