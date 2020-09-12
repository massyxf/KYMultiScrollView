//
//  KYViewController.m
//  KYMultiScrollView
//
//  Created by massyxf on 08/27/2020.
//  Copyright (c) 2020 massyxf. All rights reserved.
//

#import "KYViewController.h"
#import <KYMultiScrollView/KYHeaderRefreshMultiViewController.h>
#import "KYDemoHeadView.h"
#import "KYDemoSubViewController.h"
#import <KYMultiScrollView/KYTopRefreshMultiViewController.h>

#import "NDHeaderRefresh.h"
#import "NDFooterRefresh.h"
#import "NDBackFooterRefresh.h"

@interface KYViewController ()

@end

@implementation KYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self normalContain];
    
    [self headerRefreshDemo];
    
//    [self topRefreshDemo];
}

-(void)normalContain{
    KYDemoSubViewController *subVc1 = [[KYDemoSubViewController alloc] init];
    KYDemoSubViewController *subVc2 = [[KYDemoSubViewController alloc] init];
    KYDemoSubViewController *subVc3 = [[KYDemoSubViewController alloc] init];
    KYMultiViewController *multiVc = [[KYMultiViewController alloc] initWithSubVcs:@[subVc1,subVc2,subVc3]
                                                                      defaultIndex:2];
    [self addChildViewController:multiVc];
    [self.view addSubview:multiVc.view];
}

-(void)headerRefreshDemo{
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    KYDemoHeadView *headView = [[KYDemoHeadView alloc] initWithFrame:CGRectMake(0, 0, width, 200)];
    headView.backgroundColor = [UIColor redColor];
    headView.maxShowHeight = 200;
    headView.minShowHeight = 50;
    
    KYDemoSubViewController *subVc1 = [[KYDemoSubViewController alloc] init];
    KYDemoSubViewController *subVc2 = [[KYDemoSubViewController alloc] init];
    KYDemoSubViewController *subVc3 = [[KYDemoSubViewController alloc] init];
    
    KYHeaderRefreshMultiViewController *multiVc = [[KYHeaderRefreshMultiViewController alloc] initWithSubVcs:@[subVc1,subVc2,subVc3]
                                                                          headView:headView
                                                                      defaultIndex:2];
    [self addChildViewController:multiVc];
    [self.view addSubview:multiVc.view];
}

-(void)topRefreshDemo{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    KYDemoHeadView *headView = [[KYDemoHeadView alloc] initWithFrame:CGRectMake(0, 0, width, 200)];
    headView.backgroundColor = [UIColor redColor];
    headView.maxShowHeight = 200;
    headView.minShowHeight = 50;
    
    KYDemoSubViewController *subVc1 = [[KYDemoSubViewController alloc] init];
    subVc1.isTopRefreshDemo = YES;
    KYDemoSubViewController *subVc2 = [[KYDemoSubViewController alloc] init];
    subVc2.isTopRefreshDemo = YES;
    KYDemoSubViewController *subVc3 = [[KYDemoSubViewController alloc] init];
    subVc3.isTopRefreshDemo = YES;
    
    KYTopRefreshMultiViewController *multiVc = [[KYTopRefreshMultiViewController alloc] initWithSubVcs:@[subVc1,subVc2,subVc3] defaultIndex:0 headView:headView];
    
    __weak typeof(multiVc) weakVc = multiVc;
    multiVc.verticalScrollView.mj_header = [NDHeaderRefresh headerWithRefreshingBlock:^{
        [(KYDemoSubViewController *)weakVc.currentVc loadData:NO];
        [weakVc.verticalScrollView.mj_header endRefreshing];
    }];
    multiVc.verticalScrollView.mj_footer = [NDBackFooterRefresh footerWithRefreshingBlock:^{
        [(KYDemoSubViewController *)weakVc.currentVc loadData:YES];
        [weakVc.verticalScrollView.mj_footer endRefreshing];
    }];
    [self addChildViewController:multiVc];
    [self.view addSubview:multiVc.view];
}

@end
