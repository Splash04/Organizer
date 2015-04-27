//
//  ISDataManager.m
//  Organizer
//
//  Created by Splash on 4/14/15.
//  Copyright (c) 2015 Splash. All rights reserved.
//

#import "ISDataManager.h"

@interface ISDataManager()

@property (strong, nonatomic) NSDateFormatter *weekDateFormatter;
@property (strong, nonatomic) NSDateFormatter *timeDateFormatter;
@property (strong, nonatomic) NSDateFormatter *dateDateFormatter;

@end

@implementation ISDataManager

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    if(self = [super init]) {
        self.currentDate = [NSDate new];
        self.weekDateFormatter = [NSDateFormatter new];
        [self.weekDateFormatter setDateFormat:@"EEEE"];
        self.timeDateFormatter = [NSDateFormatter new];
        [self.timeDateFormatter setDateFormat:@"HH:mm"];
        self.dateDateFormatter = [NSDateFormatter new];
        [self.dateDateFormatter setDateFormat:@"dd MMMM"];
    }
    return self;
}

#pragma mark - Date

- (NSString *)dayOfWeekFromDate:(NSDate *)date {
    return [self.weekDateFormatter stringFromDate:date];
}

- (NSString *)timeFromDate:(NSDate *)date {
    return [self.timeDateFormatter stringFromDate:date];
}

- (NSString *)shortDateStringFrom:(NSDate *)date {
    return [self.dateDateFormatter stringFromDate:date];
}

- (NSDate *)dateAfter:(NSInteger)days {
    // Create and initialize date component instance
    NSDateComponents *dateComponents = [NSDateComponents new];
    [dateComponents setDay:days];
    
    NSDate *result = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self.currentDate options:0];
    return result;
}

- (NSDate *)dateBefore:(NSInteger)days {
    return [self dateAfter:-days];
}

#pragma mark - DataBase

- (Event *)createNewEvent {
    return [Event MR_createInContext:NSManagedObjectContext.MR_contextForCurrentThread];
}

- (void)saveToDataBaseWithCompletion:(MRSaveCompletionHandler)completion {
    [NSManagedObjectContext.MR_contextForCurrentThread MR_saveToPersistentStoreWithCompletion:completion];
}

- (void)deleteEvent:(Event *)event {
    [event MR_deleteInContext:NSManagedObjectContext.MR_contextForCurrentThread];
}

#pragma mark - Static

+ (NSDate *)dateAfter:(NSInteger)days {
    return [[self sharedInstance] dateAfter:days];
}

+ (NSDate *)dateBefore:(NSInteger)days {
    return [[self sharedInstance] dateBefore:days];
}

+ (NSString *)dayOfWeekFromDate:(NSDate *)date {
    return [[self sharedInstance] dayOfWeekFromDate:date];
}

+ (NSString *)timeFromDate:(NSDate *)date{
    return [[self sharedInstance] timeFromDate:date];
}

+ (NSString *)shortDateStringFrom:(NSDate *)date {
    return [[self sharedInstance] shortDateStringFrom:date];
}

+ (Event *)createNewEvent {
    return [[self sharedInstance] createNewEvent];
}

+ (void)saveToDataBaseWithCompletion:(MRSaveCompletionHandler)completion {
    [[self sharedInstance] saveToDataBaseWithCompletion:completion];
}

+ (void)deleteEvent:(Event *)event {
    [[self sharedInstance] deleteEvent:event];
}

+ (NSDate *)useSameTimeAsDate:(NSDate *)priorDate butOnADifferentDate:(NSDate *)differentDate
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents  *priorComponents = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:priorDate];
    NSDateComponents *newComponents = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:differentDate];
    [newComponents setSecond:[priorComponents second]];
    [newComponents setMinute:[priorComponents minute]];
    [newComponents setHour:[priorComponents hour]];
    
    return [cal dateFromComponents:newComponents];
}

@end
