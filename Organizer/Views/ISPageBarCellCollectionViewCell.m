//
//  ISPageBarCellCollectionViewCell.m
//  Organizer
//
//  Created by Splash on 4/12/15.
//  Copyright (c) 2015 Splash. All rights reserved.
//

#import "ISPageBarCellCollectionViewCell.h"

@implementation ISPageBarCellCollectionViewCell

//- (void)awakeFromNib {
//    // Initialization code
//    NSLog(@"test");
//}

+ (NSString *)cellIdentifier
{
    static NSString *cellIdentifier = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        cellIdentifier = NSStringFromClass([self class]);
    });
    return cellIdentifier;
}

@end
