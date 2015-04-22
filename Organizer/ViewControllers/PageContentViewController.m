//
//  PageContentViewController.m
//  Organizer
//
//  Created by Splash on 4/14/15.
//  Copyright (c) 2015 Splash. All rights reserved.
//

#import "PageContentViewController.h"
#import "ISTimeTableViewCell.h"
#import <CoreData+MagicalRecord.h>
#import "Event.h"
#import "ISDataManager.h"

#define kHoursPerDay 24

@interface PageContentViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *timesArray;

@end

@implementation PageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"ISTimeTableViewCell" bundle:nil] forCellReuseIdentifier:[ISTimeTableViewCell cellIdentifier]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
//    NSCalendar* calendar = [NSCalendar currentCalendar];
//    NSDateComponents* components = [calendar components:flags fromDate:self.pageDate];
//   // NSDate* dateOnly = [calendar dateFromComponents:components];
//    
//    NSDate* dateOnly = [[calendar dateFromComponents:components] dateByAddingTimeInterval:[[NSTimeZone localTimeZone]secondsFromGMT]];
    
    NSDateComponents *components = [[NSCalendar currentCalendar]
                                    components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                    fromDate:[NSDate date]];
    NSDate *startDate = [[NSCalendar currentCalendar]
                         dateFromComponents:components];
    NSTimeInterval secondsInOneHours = 1 * 60 * 60;
    self.timesArray = [NSMutableArray new];
    
    for (NSInteger index = 0; index < kHoursPerDay; index++)
    {
        NSDate *dateAfter = [startDate dateByAddingTimeInterval:(secondsInOneHours * index)];
        [self.timesArray addObject:dateAfter];
    }
    
    NSPredicate *stalePredicate = [NSPredicate predicateWithFormat:@"date < %@", self.pageDate];
    NSArray *staleObjects = [Event MR_findAllWithPredicate:stalePredicate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark – <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.timesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ISTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ISTimeTableViewCell cellIdentifier]];
    
    cell.date = self.timesArray[indexPath.item];
    //cell.timeLabel.text = [ISDataManager timeFromDate:self.timesArray[indexPath.item]];
    //[NSString stringWithFormat:@"%ld:00", (long)indexPath.item];
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    tableView des
//}

#pragma mark – <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ISTimeTableViewCell getCellHeight];
}

+ (NSString *)controllerIdentifier
{
    static NSString *cellIdentifier = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        cellIdentifier = NSStringFromClass([self class]);
    });
    return cellIdentifier;
}

@end
