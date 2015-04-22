//
//  ISPageBar.h
//  Organizer
//
//  Created by Splash on 4/12/15.
//  Copyright (c) 2015 Splash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISPageBar : UICollectionView

@property (weak, nonatomic) id<UIScrollViewDelegate> scrollDelegate;

- (void)updateContentOffset:(CGPoint)contentffset;

@end
