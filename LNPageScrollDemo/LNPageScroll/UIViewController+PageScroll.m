//
//  UIViewController+PageScroll.m
//  LanceTool
//
//  Created by lgh on 2018/3/8.
//  Copyright © 2018年 lgh. All rights reserved.
//

#import "UIViewController+PageScroll.h"
#import <objc/runtime.h>
#import <Masonry.h>

@implementation UIViewController (PageScroll)

- (void)loadPageControllerWithTitles:(NSArray <PageTitleModel *> *)titles pageControllers:(NSArray <UIViewController *> *)controllers defaultPage:(NSInteger)page{
    NSAssert(titles.count == controllers.count, @"两数组数量不匹配");
    if(!titles || titles.count == 0) return;
    if(!controllers || controllers.count == 0) return;
    if(self.pageViewController) return;
    __weak __typeof(self)weakSelf = self;
    self.tView = [[LNPageTitleView alloc] initWithTitleConfigs:titles clikBlock:^(UIButton *sender, NSInteger index) {
        __strong __typeof(self)strongSelf = weakSelf;
        [strongSelf.pageViewController scrollToPage:index animated:YES];
    }];
    self.tView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tView];
    [self.tView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@40);
    }];
    
    self.pageViewController = [[LNPageCotainerViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.scrollDelegate = self;
    [self.pageViewController.pageControllers addObjectsFromArray:[controllers mutableCopy]];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    
    [self.pageViewController makeDefualtPage:page<controllers.count?page:0];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tView animationWithSelectedIndex:page<controllers.count?page:0];
    });

}

- (void)selectPage:(NSInteger)page animated:(BOOL)animated{
    if(!self.pageViewController) return;
    if(page < 0 || page >= self.pageViewController.pageControllers.count) return;
    [self.pageViewController scrollToPage:page animated:animated];
}

#pragma mark - 滑动代理
- (void)scrollCompleWithIndex:(NSInteger)index currentController:(UIViewController *)controller{
    
    [self.tView animationWithSelectedIndex:index];
    
}

- (void)pageViewDidScrollOffset:(CGFloat)offset{
    
    [self.tView lineViewScrollOffset:offset];
    
    
}

#pragma mark - 分页控制器
static const char pageViewControllerKey;
- (void)setPageViewController:(LNPageCotainerViewController *)pageViewController
{
    if (self.pageViewController != pageViewController) {
        
        objc_setAssociatedObject(self, &pageViewControllerKey,pageViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (LNPageCotainerViewController *)pageViewController
{
    return objc_getAssociatedObject(self, &pageViewControllerKey);
}

#pragma mark - 顶部标签滑动条
static const char titleViewKey;
- (void)setTView:(LNPageTitleView *)tView
{
    if (self.tView != tView) {
        objc_setAssociatedObject(self, &titleViewKey,tView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (LNPageTitleView *)tView
{
    return objc_getAssociatedObject(self, &titleViewKey);
}

@end
