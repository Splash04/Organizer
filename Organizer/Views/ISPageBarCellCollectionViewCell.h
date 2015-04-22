//
//  ISPageBarCellCollectionViewCell.h
//  Organizer
//
//  Created by Splash on 4/12/15.
//  Copyright (c) 2015 Splash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISPageBarCellCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

+ (NSString *)cellIdentifier;

@end
