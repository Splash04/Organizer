//
//  MainViewController.h
//  Organizer
//
//  Created by Splash on 4/10/15.
//  Copyright (c) 2015 Splash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISPageBar.h"

@interface MainViewController : UIViewController

@property (weak, nonatomic) IBOutlet ISPageBar *pagesBar;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) UIPageViewController *pageViewController;

@end

