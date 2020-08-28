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
    
    [self configSubVc];
    
    if (!_headView) { return;}
    
    _headView.frame = _headView.bounds;
    [self.view addSubview:_headView];
    _headView.responseView = self.bgScrollview;
    
    CGFloat height = CGRectGetHeight(_headView.bounds);
    self.bgScrollview.scrollIndicatorInsets = UIEdgeInsetsMake(height, 0, 0, 0);
}

-(BOOL)selectVcAtIndex:(NSInteger)index{
    BOOL response = [super selectVcAtIndex:index];
    if (!response) { return response; }
    UIViewController<KYTopRefreshVcProtocol> *vc = (UIViewController<KYTopRefreshVcProtocol> *)self.subVcs[self.currentIndex];
    vc.scrollView.scrollEnabled = NO;
    [self resetContentSizeWithVc:vc];
    return response;
}

#pragma mark - custom func
-(void)configSubVc{
    KYWeakSelf
    CGFloat head_height = _headView.maxShowHeight;
    [self.subVcs enumerateObjectsUsingBlock:^(UIViewController<KYTopRefreshVcProtocol> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.top = head_height;
        obj.contentSizeChanged = ^(CGSize size, UIViewController<KYTopRefreshVcProtocol> * _Nonnull vc) {
            if (vc != weakSelf.currentVc) {
                return;
            }
            [weakSelf resetContentSizeWithVc:vc];
        };
    }];
}

-(void)resetContentSizeWithVc:(UIViewController<KYTopRefreshVcProtocol> *)vc{
    CGSize size = self.bgScrollview.contentSize;
    size.height = vc.scrollView.contentSize.height;
    self.bgScrollview.contentSize = size;
}




@end
