//
//  ViewController.m
//  LNPageScrollDemo
//
//  Created by Mr.lai on 2018/3/25.
//  Copyright © 2018年 Mr.lai. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+PageScroll.h"
#import "LNTestViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [UIApplication sharedApplication].statusBarHidden = YES;
}
- (IBAction)demoTestAction:(UIButton *)sender {
    NSMutableArray *labels = [NSMutableArray array];
    NSMutableArray *controllers = [NSMutableArray array];
    for(int i=0;i<10;i++){
        PageTitleModel *model = [[PageTitleModel alloc] initWithNorStr:[NSString stringWithFormat:@"page%d",i+1]];
        model.afont = [UIFont systemFontOfSize:18];
        [labels addObject:model];
        LNTestViewController *pageVC = [LNTestViewController new];
        pageVC.pageIndex = i+1;
        [controllers addObject:pageVC];
    }
    [self loadPageControllerWithTitles:labels pageControllers:controllers defaultPage:4];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
