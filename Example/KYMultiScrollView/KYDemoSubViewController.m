//
//  KYDemoSubViewController.m
//  KYMultiScrollView_Example
//
//  Created by yxf on 2020/8/27.
//  Copyright © 2020 massyxf. All rights reserved.
//

#import "KYDemoSubViewController.h"
#import "NDHeaderRefresh.h"
#import "NDFooterRefresh.h"
#import "NDBackFooterRefresh.h"

@interface KYDemoSubViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak)UITableView *tableview;
@property (nonatomic,assign)NSInteger rowCount;

@end

@implementation KYDemoSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _rowCount = 0;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                          style:UITableViewStylePlain];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    if (@available(iOS 11,*)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _tableview = tableView;
    
    [self.view addSubview:tableView];
    
    if (_isTopRefreshDemo) {
        [tableView addObserver:self
                    forKeyPath:@"contentSize"
                       options:NSKeyValueObservingOptionNew
                       context:nil];
        return;
    }
    
    tableView.mj_header = [NDHeaderRefresh headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    tableView.mj_footer = [NDBackFooterRefresh footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    [tableView.mj_header beginRefreshing];
}


-(UIScrollView *)scrollView{
    return _tableview;
}

-(void)loadData:(BOOL)isMore{
    _rowCount = isMore ? (_rowCount + 3) : 0;
    [_tableview reloadData];
}

#pragma mark - refresh action
-(void)headerRefresh{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableview.mj_header endRefreshing];
        [self loadData:NO];
    });
}

-(void)footerRefresh{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableview.mj_footer endRefreshing];
        [self loadData:YES];
    });
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithRed:arc4random() % 256 /255.0 green:arc4random() % 256 /255.0 blue:arc4random() % 256 /255.0 alpha:1];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _rowCount;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

#pragma mark - scroll
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat y = scrollView.contentOffset.y;
    !_offsetYChanged ? : _offsetYChanged(y,self);
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGSize size = [change[NSKeyValueChangeNewKey] CGSizeValue];
        !_contentSizeChanged ? : _contentSizeChanged(size,self);
    }
}


@end
