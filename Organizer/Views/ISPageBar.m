//
//  ISPageBar.m
//  Organizer
//
//  Created by Splash on 4/12/15.
//  Copyright (c) 2015 Splash. All rights reserved.
//

#import "ISPageBar.h"
#import "ISPageBarCellCollectionViewCell.h"
#import "ISDataManager.h"

#define kTopMargin 20.f
#define kBottomMargin 5.f
#define kLeftMargin 5.f
#define kRightMargin 5.f
#define kCellViewCoeff 1.

#define kCollectionItemsCount 7
#define kCollectionItemsArrayCount 9

@interface ISPageBar() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    NSInteger currentCollectionIndex;
    NSInteger indexWeek;
    
    NSInteger indexArray[kCollectionItemsArrayCount];
    CGFloat lastContentOffsetX;
}

@property (strong, nonatomic) NSIndexPath *indexPathForDeviceOrientation;
@property (strong, nonatomic) ISDataManager *dataManager;

@end

@implementation ISPageBar

- (void)awakeFromNib {
    [self initCommon];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initCommon];
    }
    return self;
}

- (void)initCommon {
    lastContentOffsetX = FLT_MIN;
    currentCollectionIndex = 0;
    indexWeek = 0;
    self.dataManager = [ISDataManager sharedInstance];
    
    [self updateIndexArray];
    
    // Create a flow layout for the collection view that scrolls
    // horizontally and has no space between items
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    
    [self setCollectionViewLayout:flowLayout];
    
    // Set up the collection view with no scrollbars, paging enabled
    // and the delegate and data source set to this view controller
    self.showsHorizontalScrollIndicator = NO;
    //self.pagingEnabled = YES;
    self.delegate = self;
    self.dataSource = self;
    [self registerNib:[UINib nibWithNibName:@"ISPageBarCellCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:[ISPageBarCellCollectionViewCell cellIdentifier]];
}

- (void)updateIndexArray {
    if(indexWeek >= 0) {
        if(indexWeek > 0) {
            indexArray[0] = (indexWeek - 1) * kCollectionItemsCount + kCollectionItemsCount - 1;
        } else {
            indexArray[0] = -1;
        }
        
        for (NSInteger index = 0; index < kCollectionItemsCount; ++index) {
            indexArray[index + 1] = indexWeek * kCollectionItemsCount + index;
        }
        indexArray[kCollectionItemsArrayCount - 1] = (indexWeek + 1) * kCollectionItemsCount;
    } else {
        NSInteger inWeek = indexWeek + 1;
        indexArray[kCollectionItemsArrayCount - 1] = inWeek * kCollectionItemsCount;
        
        for (NSInteger index = 0; index < kCollectionItemsCount; ++index) {
            indexArray[kCollectionItemsCount - index] = inWeek * kCollectionItemsCount - index - 1;
        }
        
        indexArray[0] = (inWeek - 1) * kCollectionItemsCount - 1;
    }
    
    for (NSInteger index = 0; index < kCollectionItemsArrayCount; ++index) {
        NSLog(@"Day index: %ld values: %ld", index, indexArray[index]);
    }
}

#pragma mark - Calendar Data



#pragma mark - UIInterfaceOrientation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    _indexPathForDeviceOrientation = [[self indexPathsForVisibleItems] firstObject];
    [self.collectionViewLayout invalidateLayout];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self scrollToItemAtIndexPath:_indexPathForDeviceOrientation atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

#pragma mark - <UIScrollViewDelegate>
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if(scrollView == self.mainCollectionView &&
//       self.scrollingView == self.mainCollectionView){
//        CGFloat x = self.mainCollectionView.contentOffset.x / self.mainCollectionView.bounds.size.width * SM_IPHONE_THUMB_CONTAINER_SIZE; // cell width + spacing 48 + 8
//        CGFloat y = 0;
//        CGPoint contentOffset = CGPointMake(x, y);
//        self.thumbsCollectionView.contentOffset = contentOffset;
//        
//    }
//    else if(scrollView == self.thumbsCollectionView &&
//            self.scrollingView == self.thumbsCollectionView){
//        CGFloat x = self.thumbsCollectionView.contentOffset.x / SM_IPHONE_THUMB_CONTAINER_SIZE * self.mainCollectionView.frame.size.width; // cell width + spacing 48 + 8
//        CGFloat y = 0;
//        CGPoint contentOffset = CGPointMake(x, y);
//        self.mainCollectionView.contentOffset = contentOffset;
//        
//    }
//}
//
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    self.scrollingView = scrollView;
//}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return kCollectionItemsArrayCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"IndexPath: %ld, %ld", indexPath.row, indexPath.item);
    ISPageBarCellCollectionViewCell *cell = (ISPageBarCellCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[ISPageBarCellCollectionViewCell cellIdentifier]
                                                                                                                forIndexPath:indexPath];
    
    NSInteger nextCollectionIndex = indexPath.item;
    
    if(currentCollectionIndex == 0) {
        if(nextCollectionIndex >= kCollectionItemsArrayCount / 2) {
            --indexWeek;
            [self updateIndexArray];
        }
    } else if(currentCollectionIndex == kCollectionItemsCount) {
        if(nextCollectionIndex < kCollectionItemsArrayCount / 2) {
            ++indexWeek;
            [self updateIndexArray];
        }
    }
    
    NSDate *cellDate = [ISDataManager dateAfter:indexArray[nextCollectionIndex] + 1];
    
    cell.titleLabel.text = [[ISDataManager dayOfWeekFromDate:cellDate] uppercaseString];
    cell.subTitleLabel.text = [ISDataManager shortDateStringFrom:cellDate];
    NSLog(@"Day realIndex: %ld", indexArray[nextCollectionIndex]);
    currentCollectionIndex = nextCollectionIndex;
    return cell;
}

#pragma mark – <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake(collectionView.bounds.size.width * kCellViewCoeff, collectionView.bounds.size.height) ;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(kTopMargin, kLeftMargin, kBottomMargin, kRightMargin);
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // We can ignore the first time scroll,
    // because it is caused by the call scrollToItemAtIndexPath: in ViewWillAppear
    if (FLT_MIN == lastContentOffsetX) {
        lastContentOffsetX = scrollView.contentOffset.x;
        return;
    }
    
    [self.scrollDelegate scrollViewDidScroll:scrollView];
    
    [self updateContentOffset:scrollView.contentOffset];
}

- (void)updateContentOffset:(CGPoint)contentffset
{
    CGFloat currentOffsetX = contentffset.x;
    CGFloat currentOffsetY = contentffset.y;
    
    CGFloat pageWidth = self.frame.size.width * kCellViewCoeff;
    CGFloat offset = pageWidth * (kCollectionItemsArrayCount - 2);
    
    // the first page(showing the last item) is visible and user is still scrolling to the left
    if (currentOffsetX < pageWidth && lastContentOffsetX > currentOffsetX) {
        lastContentOffsetX = currentOffsetX + offset;
        self.contentOffset = (CGPoint){lastContentOffsetX, currentOffsetY};
    }
    // the last page (showing the first item) is visible and the user is still scrolling to the right
    else if (currentOffsetX > offset && lastContentOffsetX < currentOffsetX) {
        lastContentOffsetX = currentOffsetX - offset;
        self.contentOffset = (CGPoint){lastContentOffsetX, currentOffsetY};
    } else {
        lastContentOffsetX = currentOffsetX;
    }

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.scrollDelegate scrollViewWillBeginDragging:scrollView];
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    
//    // Calculate where the collection view should be at the right-hand end item
//    float contentOffsetWhenFullyScrolledRight = self.frame.size.width * (kCollectionItemsCount - 1);
//    
//    if (self.contentOffset.x == contentOffsetWhenFullyScrolledRight) {
//        
//        // user is scrolling to the right from the last item to the 'fake' item 1.
//        // reposition offset to show the 'real' item 1 at the left-hand end of the collection view
//        
//        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
//        
//        [self scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
//        
//    } else if (self.contentOffset.x == 0)  {
//        
//        // user is scrolling to the left from the first item to the fake 'item N'.
//        // reposition offset to show the 'real' item N at the right end end of the collection view
//        
//        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:(kCollectionItemsArrayCount - 2) inSection:0];
//        
//        [self scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
//        
//    }
//}

@end
