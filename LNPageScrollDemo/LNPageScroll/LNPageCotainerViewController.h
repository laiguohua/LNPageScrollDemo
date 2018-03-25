//
//  LNTestViewController.m
//  LNPageScrollDemo
//
//  Created by Mr.lai on 2018/3/25.
//  Copyright © 2018年 Mr.lai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LNPageContainerDelegate <NSObject>

@optional

- (void)scrollCompleWithIndex:(NSInteger)index currentController:(UIViewController *)controller;

- (void)pageViewDidScrollOffset:(CGFloat)offset;


@end

@interface LNPageCotainerViewController : UIPageViewController

@property (nonatomic,weak)id<LNPageContainerDelegate>scrollDelegate;
@property (nonatomic,strong)NSMutableArray <UIViewController *>*pageControllers;


- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated;

- (void)makeDefualtPage:(NSInteger)page;

@end
