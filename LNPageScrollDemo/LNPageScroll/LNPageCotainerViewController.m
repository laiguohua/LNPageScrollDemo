//
//  LNPageCotainerViewController.m
//  LNPageScrollDemo
//
//  Created by Mr.lai on 2018/3/25.
//  Copyright © 2018年 Mr.lai. All rights reserved.
//

#import "LNPageCotainerViewController.h"

@interface LNPageCotainerViewController ()<UIScrollViewDelegate,UIPageViewControllerDelegate,UIPageViewControllerDataSource>


@property (nonatomic,assign)BOOL isSlipEnable;

@property (nonatomic,assign)NSInteger currentIndex;

@end

@implementation LNPageCotainerViewController

- (id)initWithTransitionStyle:(UIPageViewControllerTransitionStyle)style navigationOrientation:(UIPageViewControllerNavigationOrientation)navigationOrientation options:(NSDictionary<NSString *,id> *)options{
    self = [super initWithTransitionStyle:style navigationOrientation:navigationOrientation options:options];
    if(self){
        //找到滑动的scrollView
        for(UIView *aview in self.view.subviews){
            if([aview isKindOfClass:[UIScrollView class]]){
                UIScrollView *ascrollView = (UIScrollView *)aview;
                ascrollView.delegate = self;
            }
        }
        
        //设置自己的代理为自己
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}


- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated{
    if(page >= self.pageControllers.count || page < 0) return;
    UIViewController *controller = [self.viewControllers firstObject];
    if(!controller) return;
    NSInteger currentIndex = [self.pageControllers indexOfObject:controller];
    if(currentIndex == page) return;
    UIPageViewControllerNavigationDirection direct;
    if(page > currentIndex){
        direct = UIPageViewControllerNavigationDirectionForward;
    }else{
        direct = UIPageViewControllerNavigationDirectionReverse;
    }
    __weak __typeof(self)weakSelf = self;
    [self setViewControllers:[self.pageControllers subarrayWithRange:NSMakeRange(page, 1)] direction:direct animated:animated completion:^(BOOL finished) {
        
        __strong __typeof(self)strongSelf = weakSelf;
        strongSelf.currentIndex = page;
    }];
    
}

- (void)makeDefualtPage:(NSInteger)page{
    [self setViewControllers:[self.pageControllers subarrayWithRange:NSMakeRange(page, 1)] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 代理协议
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    int index = (int)[self.pageControllers indexOfObject:viewController];
    if (index <= 0) {
        return nil;
    }else{
        
        return self.pageControllers[index - 1];
    }
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    int index = (int)[self.pageControllers indexOfObject:viewController];
    
    if (index >= self.pageControllers.count - 1) {
        return nil;
    }
    
    return self.pageControllers[index + 1];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    UIViewController *controller = [pageViewController.viewControllers firstObject];
    NSInteger index = [self.pageControllers indexOfObject:controller];
    if(finished && self.scrollDelegate && [self.scrollDelegate respondsToSelector:@selector(scrollCompleWithIndex:currentController:)]){
        [self.scrollDelegate scrollCompleWithIndex:index currentController:controller];
    }
    self.currentIndex = index;
}

#pragma  mark - 懒加载
- (NSMutableArray *)pageControllers{
    if(!_pageControllers){
        _pageControllers = [NSMutableArray array];
    }
    return _pageControllers;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat width = CGRectGetWidth(scrollView.frame);
    CGFloat offsetx = scrollView.contentOffset.x;
    CGFloat caOffsetx = 0;
    //相等的情况,其实就是刚好停下来
    if(fabs(offsetx - width) < 0.0001){
        caOffsetx = self.currentIndex * width;
    }else{
        caOffsetx = (self.currentIndex - 1) * width + offsetx;
    }
    if(self.scrollDelegate && [self.scrollDelegate respondsToSelector:@selector(pageViewDidScrollOffset:)]){
        [self.scrollDelegate pageViewDidScrollOffset:caOffsetx];
    }
}


@end
