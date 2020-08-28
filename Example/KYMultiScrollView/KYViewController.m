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

@interface KYViewController ()

@end

@implementation KYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    KYDemoHeadView *headView = [[KYDemoHeadView alloc] initWithFrame:CGRectMake(0, 0, width, 200)];
    headView.backgroundColor = [UIColor redColor];
    headView.maxShowHeight = 200;
    headView.minShowHeight = 50;
    
    KYDemoSubViewController *subVc1 = [[KYDemoSubViewController alloc] init];
    subVc1.rowCount = 3;
    KYDemoSubViewController *subVc2 = [[KYDemoSubViewController alloc] init];
    subVc2.rowCount = 0;
    KYDemoSubViewController *subVc3 = [[KYDemoSubViewController alloc] init];
    subVc3.rowCount = 20;
    
    KYHeaderRefreshMultiViewController *multiVc = [[KYHeaderRefreshMultiViewController alloc] initWithSubVcs:@[subVc1,subVc2,subVc3]
                                                                          headView:headView
                                                                      defaultIndex:2];
    [self addChildViewController:multiVc];
    [self.view addSubview:multiVc.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
