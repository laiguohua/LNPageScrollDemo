//
//  LNTestViewController.m
//  LNPageScrollDemo
//
//  Created by Mr.lai on 2018/3/25.
//  Copyright © 2018年 Mr.lai. All rights reserved.
//

#import "LNTestViewController.h"
#import <Masonry.h>

@interface LNTestViewController ()<UITableViewDelegate,UITableViewDataSource>



@property (nonatomic,strong)UITableView *tableView;


@end

@implementation LNTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:.5];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSLog(@"=======page %ld %s",self.pageIndex,__func__);
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"page %ld %s",self.pageIndex,__func__);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indeCell = @"acell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indeCell];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indeCell];
        cell.textLabel.textColor = [UIColor redColor];
        cell.detailTextLabel.textColor = [UIColor blueColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"page %ld",self.pageIndex];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%ld",@"this is row ", indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"点击加载详情");
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

@end
