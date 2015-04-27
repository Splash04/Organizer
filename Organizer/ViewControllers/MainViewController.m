//
//  MainViewController.m
//  Organizer
//
//  Created by Splash on 4/10/15.
//  Copyright (c) 2015 Splash. All rights reserved.
//

#import "MainViewController.h"
#import "PageContentViewController.h"
#import "ISDataManager.h"
#import <UIView+AutoLayout.h>

@interface MainViewController () <UIPageViewControllerDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) UIScrollView *pageViewControllerScrollView;
@property (weak, nonatomic) UIScrollView *scrollingView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pagesBar.scrollDelegate = self;
    [self.pagesBar reloadData];
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(-16, 0, [UIScreen mainScreen].bounds.size.width-30, self.view.frame.size.height);
    
    [self addChildViewController:_pageViewController];
    [self.contentView addSubview:_pageViewController.view];
    [_pageViewController.view pinToSuperviewEdges:JRTViewPinAllEdges inset:0.];
    [self.pageViewController didMoveToParentViewController:self];

    for (UIView *view in self.pageViewController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            self.pageViewControllerScrollView = (UIScrollView *)view;
            [(UIScrollView *)view setDelegate:self];
        }
    }
}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    // scroll to the 2nd page, which is showing the first item.
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        // scroll to the first page, note that this call will trigger scrollViewDidScroll: once and only once
//        [self.pagesBar scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
//    });
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    NSLog(@"Page Index: %ld", (long)index);
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:[PageContentViewController controllerIdentifier]];
    pageContentViewController.pageIndex = index;
    pageContentViewController.pageDate = [ISDataManager dateAfter:index];
    
    return pageContentViewController;
}

#pragma mark – <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == self.pagesBar &&
       self.scrollingView == self.pagesBar) {
        CGFloat x = self.pagesBar.contentOffset.x / self.pagesBar.bounds.size.width;// * SM_IPHONE_THUMB_CONTAINER_SIZE; // cell width + spacing 48 + 8
        CGFloat y = 0;
        CGPoint contentOffset = CGPointMake(x, y);
        self.pageViewControllerScrollView.contentOffset = contentOffset;
        
    }
    else if(scrollView == self.pageViewControllerScrollView &&
            self.scrollingView == self.pageViewControllerScrollView) {
        CGFloat x = self.pageViewControllerScrollView.contentOffset.x;/// SM_IPHONE_THUMB_CONTAINER_SIZE * self.mainCollectionView.frame.size.width; // cell width + spacing 48 + 8
        CGFloat y = 0;
        CGPoint contentOffset = CGPointMake(x, y);
        //self.pagesBar.contentOffset = contentOffset;
        [self.pagesBar updateContentOffset:contentOffset];
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.scrollingView = scrollView;
}

#pragma mark – <UIPageViewControllerDataSource>

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController *)viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController *) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

@end
