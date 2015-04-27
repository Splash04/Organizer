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
    [self updateDates];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateDates
{
    NSDateComponents *components = [[NSCalendar currentCalendar]
                                    components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                    fromDate:self.pageDate];
    NSDate *startDate = [[NSCalendar currentCalendar]
                         dateFromComponents:components];
    NSTimeInterval secondsInOneHours = 1 * 60 * 60;
    self.timesArray = [NSMutableArray new];
    
    for (NSInteger index = 0; index < kHoursPerDay; index++)
    {
        NSDate *dateAfter = [startDate dateByAddingTimeInterval:(secondsInOneHours * index)];
        [self.timesArray addObject:dateAfter];
    }
    NSDate *endDate = [startDate dateByAddingTimeInterval:(secondsInOneHours * kHoursPerDay)];
    
    // NSPredicate *stalePredicate = [NSPredicate predicateWithFormat:@"date < %@", self.pageDate];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", startDate, endDate];
    NSArray *staleObjects = [Event MR_findAllWithPredicate:predicate];
    for (NSInteger index = 0; index < self.timesArray.count; ++index) {
        startDate = self.timesArray[index];
        endDate = [startDate dateByAddingTimeInterval:secondsInOneHours];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(self.date >= %@) AND (self.date <= %@)", startDate, endDate];
        NSArray *filteredArray = [staleObjects filteredArrayUsingPredicate:predicate];
        if([filteredArray count] > 0) {
            [self.timesArray removeObjectAtIndex:index];
            for(NSInteger addedObjectIndex = 0; addedObjectIndex < filteredArray.count; addedObjectIndex++) {
                [self.timesArray insertObject:filteredArray[addedObjectIndex] atIndex:(index + addedObjectIndex)];
            }
            index += filteredArray.count - 1;
        }
    }
    [self.tableView reloadData];
}

#pragma mark – <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.timesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ISTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ISTimeTableViewCell cellIdentifier]];
    NSObject *item = self.timesArray[indexPath.item];
    if([item isKindOfClass:[NSDate class]]) {
        cell.date = (NSDate *)item;
    } else if([item isKindOfClass:[Event class]]) {
        cell.event = (Event *)item;
    }
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
