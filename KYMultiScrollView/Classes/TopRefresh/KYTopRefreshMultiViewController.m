//
//  KYTopRefreshMultiViewController.m
//  KYMultiScrollView
//
//  Created by yxf on 2020/8/28.
//

#import "KYTopRefreshMultiViewController.h"
#import "KYTopRefreshVcProtocol.h"
#import "KYMultiHeadView.h"

@interface KYTopRefreshMultiViewController ()

@property (nonatomic,strong)KYMultiHeadView *headView;

@property (nonatomic,strong)UIScrollView *verticalScrollView;


@end

@implementation KYTopRefreshMultiViewController

-(instancetype)initWithSubVcs:(NSArray<UIViewController<KYTopRefreshVcProtocol> *> *)subVcs
                 defaultIndex:(NSInteger)index
                     headView:(KYMultiHeadView *)headView{
    if (self = [super initWithSubVcs:subVcs defaultIndex:index]) {
        _headView = headView;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *bgScrollView = self.bgScrollview;
    [self.verticalScrollView addSubview:bgScrollView];
    [self.view insertSubview:self.verticalScrollView atIndex:0];
    _verticalScrollView.frame = self.view.bounds;
    _verticalScrollView.contentSize = CGSizeMake(0, KYMultiScreenHeight);
    _verticalScrollView.delegate = self;
    
    if (@available(iOS 11,*)) {
        _verticalScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
        
    [self configSubVc];
    
    if (!_headView) { return;}
    
    _headView.frame = _headView.bounds;
    [self.view addSubview:_headView];
    _headView.responseView = self.bgScrollview;
    
    CGFloat height = CGRectGetHeight(_headView.bounds);
    self.bgScrollview.scrollIndicatorInsets = UIEdgeInsetsMake(height, 0, 0, 0);
}

-(UIScrollView *)verticalScrollView{
    if (!_verticalScrollView) {
        _verticalScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    }
    return _verticalScrollView;
}

-(BOOL)selectVcAtIndex:(NSInteger)index{
    BOOL response = [super selectVcAtIndex:index];
    if (!response) { return response; }
    UIViewController<KYTopRefreshVcProtocol> *vc = (UIViewController<KYTopRefreshVcProtocol> *)self.subVcs[self.currentIndex];
    vc.scrollView.scrollEnabled = NO;
    
    //fix bug:初次加载vc时，contentInset会有意料之外的值
    UIEdgeInsets insets = vc.scrollView.contentInset;
    insets.top = _headView.maxShowHeight;
    vc.scrollView.contentInset = insets;
    
    [self resetContentSizeWithVc:vc];
    return response;
}

#pragma mark - custom func
-(void)configSubVc{
    KYWeakSelf
    [self.subVcs enumerateObjectsUsingBlock:^(UIViewController<KYTopRefreshVcProtocol> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.contentSizeChanged = ^(CGSize size, UIViewController<KYTopRefreshVcProtocol> * _Nonnull vc) {
            if (vc != weakSelf.currentVc) {
                return;
            }
            [weakSelf resetContentSizeWithVc:vc];
        };
    }];
}

-(void)resetContentSizeWithVc:(UIViewController<KYTopRefreshVcProtocol> *)vc{
    CGSize size = self.verticalScrollView.contentSize;
    size.height = vc.scrollView.contentSize.height + _headView.maxShowHeight;
    if (size.height < KYMultiScreenHeight) {
        size.height = KYMultiScreenHeight;
    }
    CGRect bgFrame = self.bgScrollview.frame;
    bgFrame.size.height = size.height;
    self.bgScrollview.frame = bgFrame;
    
    CGRect vcFrame = vc.view.frame;
    vcFrame.size.height = size.height;
    vc.view.frame = vcFrame;
    vc.scrollView.frame = vc.view.bounds;
    self.verticalScrollView.contentSize = size;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _verticalScrollView && _headView) {
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY > _headView.maxShowHeight - _headView.minShowHeight) {
            offsetY = _headView.maxShowHeight - _headView.minShowHeight;
        }
        CGRect frame = _headView.frame;
        frame.origin.y = -offsetY;
        _headView.frame = frame;
        return;
    }
    if ([KYMultiViewController instancesRespondToSelector:@selector(scrollViewDidScroll:)]) {
        [super scrollViewDidScroll:scrollView];
    }
}


@end
