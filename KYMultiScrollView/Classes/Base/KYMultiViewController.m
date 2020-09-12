//
//  KYMultiViewController.m
//  KYMultiScrollView
//
//  Created by yxf on 2020/8/27.
//

#import "KYMultiViewController.h"


@interface KYMultiViewController ()

@property (nonatomic,copy)NSArray<UIViewController *> *subVcs;
@property (nonatomic,assign)NSInteger currentIndex;

@property (nonatomic,weak)UIScrollView *bgScrollview;

@end

@implementation KYMultiViewController

-(instancetype)initWithSubVcs:(NSArray<UIViewController *> *)subVcs defaultIndex:(NSInteger)index{
    if (self = [self init]) {
        _subVcs = [subVcs copy];
        if (index < 0 && _subVcs.count <= index) {
            index = 0;
        }
        _currentIndex = index;
        
        [_subVcs enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addChildViewController:obj];
        }];
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = _bgColor ? _bgColor : [UIColor whiteColor];
    
    NSInteger number = _subVcs.count;
    if (number == 0) { return; }
    CGFloat width = CGRectGetWidth(self.view.bounds);
    UIScrollView *bgScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:bgScrollView];
    bgScrollView.contentSize = CGSizeMake(width * number, 0);
    bgScrollView.pagingEnabled = YES;
    bgScrollView.delegate = self;
    bgScrollView.showsHorizontalScrollIndicator = NO;
    bgScrollView.bounces = NO;
    _bgScrollview = bgScrollView;
    
    if (_subVcs.count > 0) {
        bgScrollView.contentOffset = CGPointMake(width * _currentIndex, 0);
        [self selectVcAtIndex:_currentIndex];
    }
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _bgScrollview.frame = self.view.bounds;
    [_subVcs enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isViewLoaded) {
            CGRect frame = obj.view.frame;
            frame.size = self.bgScrollview.frame.size;
            frame.origin.y = self.bgScrollview.bounds.origin.y;
            obj.view.frame = frame;
        }
    }];
}

#pragma mark - setter
-(void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    if ([_delegate respondsToSelector:@selector(multiViewController:currentVcChanged:index:)]) {
        [_delegate multiViewController:self currentVcChanged:self.currentVc index:_currentIndex];
    }
}

#pragma mark - getter
-(UIViewController *)currentVc{
    return _subVcs[_currentIndex];
}

#pragma mark - public func
-(BOOL)selectVcAtIndex:(NSInteger)index{
    UIViewController *viewcontroller = _subVcs[index];
    BOOL isviewLoad = viewcontroller.isViewLoaded;
    if (index == _currentIndex && isviewLoad) {
        return NO;
    }
    self.currentIndex = index;
    [_bgScrollview addSubview:viewcontroller.view];
    CGRect frame = _bgScrollview.bounds;
    frame.origin.x = index * CGRectGetWidth(frame);
    viewcontroller.view.frame = frame;
    return YES;
}


#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _bgScrollview) {
        CGFloat width = CGRectGetWidth(self.view.bounds);
        NSInteger index = (scrollView.contentOffset.x + 10) / width;
        [self selectVcAtIndex:index];
    }
}

@end
