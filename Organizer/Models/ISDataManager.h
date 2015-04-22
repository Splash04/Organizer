//
//  ISDataManager.h
//  Organizer
//
//  Created by Splash on 4/14/15.
//  Copyright (c) 2015 Splash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"
#import <CoreData+MagicalRecord.h>

@interface ISDataManager : NSObject

@property (strong, nonatomic) NSDate *currentDate;

+ (instancetype)sharedInstance;

- (Event *)createNewEvent;
- (void)saveToDataBaseWithCompletion:(MRSaveCompletionHandler)completion;
- (void)deleteEvent:(Event *)event;

- (NSDate *)dateAfter:(NSInteger)days;
- (NSDate *)dateBefore:(NSInteger)days;
- (NSString *)dayOfWeekFromDate:(NSDate *)date;
- (NSString *)timeFromDate:(NSDate *)date;
- (NSString *)shortDateStringFrom:(NSDate *)date;

+ (NSDate *)dateAfter:(NSInteger)days;
+ (NSDate *)dateBefore:(NSInteger)days;
+ (NSString *)dayOfWeekFromDate:(NSDate *)date;
+ (NSString *)timeFromDate:(NSDate *)date;
+ (NSString *)shortDateStringFrom:(NSDate *)date;
+ (Event *)createNewEvent;
+ (void)saveToDataBaseWithCompletion:(MRSaveCompletionHandler)completion;
+ (void)deleteEvent:(Event *)event;

@end
