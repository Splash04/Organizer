//
//  Event.h
//  
//
//  Created by Splash on 4/18/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * alertDate;
@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * note;

@end
