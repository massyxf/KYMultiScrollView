# KYMultiScrollView

[![CI Status](https://img.shields.io/travis/massyxf/KYMultiScrollView.svg?style=flat)](https://travis-ci.org/massyxf/KYMultiScrollView)
[![Version](https://img.shields.io/cocoapods/v/KYMultiScrollView.svg?style=flat)](https://cocoapods.org/pods/KYMultiScrollView)
[![License](https://img.shields.io/cocoapods/l/KYMultiScrollView.svg?style=flat)](https://cocoapods.org/pods/KYMultiScrollView)
[![Platform](https://img.shields.io/cocoapods/p/KYMultiScrollView.svg?style=flat)](https://cocoapods.org/pods/KYMultiScrollView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

KYMultiScrollView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'KYMultiScrollView'
```

## How to use
### 没有head view
```
 KYDemoSubViewController *subVc1 = [[KYDemoSubViewController alloc] init];
 KYDemoSubViewController *subVc2 = [[KYDemoSubViewController alloc] init];
 KYDemoSubViewController *subVc3 = [[KYDemoSubViewController alloc] init];
 KYMultiViewController *multiVc = [[KYMultiViewController alloc] initWithSubVcs:@[subVc1,subVc2,subVc3] defaultIndex:2];
[self addChildViewController:multiVc];
[self.view addSubview:multiVc.view];
[self relayoutViewFrameWithVc:multiVc];

```
### 独立head view
```
CGFloat width = [UIScreen mainScreen].bounds.size.width;
KYDemoHeadView *headView = [[KYDemoHeadView alloc] initWithFrame:CGRectMake(0, 0, width, 200)];
headView.backgroundColor = [UIColor redColor];
headView.maxShowHeight = 200;
headView.minShowHeight = 50;

KYDemoSubViewController *subVc1 = [[KYDemoSubViewController alloc] init];
KYDemoSubViewController *subVc2 = [[KYDemoSubViewController alloc] init];
KYDemoSubViewController *subVc3 = [[KYDemoSubViewController alloc] init];

KYHeaderRefreshMultiViewController *multiVc = [[KYHeaderRefreshMultiViewController alloc] initWithSubVcs:@[subVc1,subVc2,subVc3] headView:headView defaultIndex:2];
[self addChildViewController:multiVc];
[self.view addSubview:multiVc.view];
[self relayoutViewFrameWithVc:multiVc];

```
### 共用head view
```
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
[self relayoutViewFrameWithVc:multiVc];

```


## Author

massyxf, ssi-yanxf@dfmc.com.cn

## License

KYMultiScrollView is available under the MIT license. See the LICENSE file for more info.
