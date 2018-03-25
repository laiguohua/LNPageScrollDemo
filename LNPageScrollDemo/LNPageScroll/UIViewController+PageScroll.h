//
//  UIViewController+PageScroll.h
//  LanceTool
//
//  Created by lgh on 2018/3/8.
//  Copyright © 2018年 lgh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNPageTitleView.h"
#import "LNPageCotainerViewController.h"

@interface UIViewController (PageScroll)<LNPageContainerDelegate>

@property (nonatomic,strong)LNPageCotainerViewController *pageViewController;
@property (nonatomic,strong)LNPageTitleView *tView;

- (void)loadPageControllerWithTitles:(NSArray <PageTitleModel *> *)titles pageControllers:(NSArray <UIViewController *> *)controllers defaultPage:(NSInteger)page;

- (void)selectPage:(NSInteger)page animated:(BOOL)animated;

@end
