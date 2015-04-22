//
//  PageContentViewController.h
//  Organizer
//
//  Created by Splash on 4/14/15.
//  Copyright (c) 2015 Splash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) NSInteger pageIndex;
@property (strong, nonatomic) NSDate *pageDate;

+ (NSString *)controllerIdentifier;

@end
