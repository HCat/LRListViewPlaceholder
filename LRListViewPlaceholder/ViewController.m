//
//  ViewController.m
//  LRListViewPlaceholder
//
//  Created by hcat on 2018/6/21.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "ViewController.h"
#import "UITableView+Placeholder.h"
#import <MJRefresh/MJRefresh.h>
#import "NetWorkHelper.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArr;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
    //点击网络异常时重载数据block
    __weak typeof(self) weakSelf = self;
    self.tableView.reloadBlock = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.tableView.mj_header beginRefreshing];
    };

    //模拟空数据
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadNotData];
    });
    
    //模拟网络重新连接情况
    [NetWorkHelper shareInstance].networkReconnectionBlock = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.tableView.mj_header beginRefreshing];
    };
    
    //模拟网络断开情况
    //你可以在请求失败的情况下做相同的事情。
    [NetWorkHelper shareInstance].networkUnconnectionBlock  = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf loadNotData];
    };
    
}



#pragma mark - set&&get

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _tableView.tableFooterView = [UIView new];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

#pragma mark - loadData

//模拟空数据或者网络出错时候的处理
- (void)loadNotData{
    
    self.dataArr = @[];
    [self.tableView reloadData];
}

//模拟有数据
- (void)loadData{
    
   
    [self.tableView.mj_header endRefreshing];
    
    if ([NetWorkHelper shareInstance].currentNetworkStatus == NotReachable) {
        [self loadNotData];
        return;
    }
    
    self.dataArr = @[@"numberOfRowsInSection",@"numberOfRowsInSection",@"numberOfRowsInSection"];
    [_tableView reloadData];
}


#pragma mark - UITableViewDelegate or UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.dataArr.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.text = self.dataArr[indexPath.row];
        
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
