//
//  KYMultiHeaderRefreshViewController.m
//  KYMultiScrollView
//
//  Created by yxf on 2020/8/28.
//

#import "KYHeaderRefreshMultiViewController.h"
#import "KYHeaderRefreshVcProtocol.h"
#import "KYMultiHeadView.h"

@interface KYHeaderRefreshMultiViewController ()

@property (nonatomic,strong)KYMultiHeadView *headView;

@end

@implementation KYHeaderRefreshMultiViewController

-(instancetype)initWithSubVcs:(NSArray<UIViewController<KYHeaderRefreshVcProtocol> *> *)subVcs
                     headView:(KYMultiHeadView *)headView
                 defaultIndex:(NSInteger)index{
    if (self = [super initWithSubVcs:subVcs defaultIndex:index]) {
        _headView = headView;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configSubVcs];
    
    if (_headView) {
        _headView.frame = _headView.bounds;
        [self.view addSubview:_headView];
    }
}

-(void)configSubVcs{
    KYWeakSelf
    [self.subVcs enumerateObjectsUsingBlock:^(UIViewController<KYHeaderRefreshVcProtocol> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.offsetYChanged = ^(id<KYHeaderRefreshVcProtocol> subVc) {
            //一般的多tableview嵌套
            if (!weakSelf.headView) { return; }
            
            if (!subVc.scrollView) { return; }
            
            UIViewController<KYHeaderRefreshVcProtocol> *currentVc = (UIViewController<KYHeaderRefreshVcProtocol> *)weakSelf.subVcs[weakSelf.currentIndex];
            if (subVc != currentVc) { return; }
            
            //head
            //NSLog(@"%f --- %f",offsetY,subVc.scrollView.contentInset.top);
            CGFloat headShowHeight = [self headHeightWithVc:subVc];
            CGRect frame = weakSelf.headView.frame;
            frame.origin.y = headShowHeight - frame.size.height;
            weakSelf.headView.frame = frame;
            
            //vc
            [weakSelf alterOtherVcOffsetWithHeaderShowHeight:headShowHeight];
        };
        [self addChildViewController:obj];
    }];
}

-(void)alterOtherVcOffsetWithHeaderShowHeight:(CGFloat)height{
    CGFloat head_height = _headView.maxShowHeight;
    for (int i=0; i<self.subVcs.count; i++) {
        if (i == self.currentIndex) { continue; }
        
        UIViewController<KYHeaderRefreshVcProtocol> *vc = (UIViewController<KYHeaderRefreshVcProtocol> *)self.subVcs[i];
        if (!vc.isViewLoaded) { continue; }
        
        //根据当前offset算出此时head的高度
        CGFloat offsetY = vc.scrollView.contentOffset.y;
        CGFloat headShowHeight = [self headHeightWithVc:vc];
        if (headShowHeight == height) { continue; }
        offsetY = head_height - vc.scrollView.contentInset.top - height;
        dispatch_async(dispatch_get_main_queue(), ^{
            vc.scrollView.contentOffset = CGPointMake(0, offsetY);
        });
    }
}

-(CGFloat)headHeightWithVc:(id<KYHeaderRefreshVcProtocol>)vc{
    CGFloat head_height = _headView.maxShowHeight;
    CGFloat head_minHeight = _headView.minShowHeight;
    CGFloat headShowHeight = head_height - (vc.scrollView.contentOffset.y + vc.scrollView.contentInset.top);
    if (headShowHeight <= head_minHeight) {
        headShowHeight = head_minHeight;
    }else if(headShowHeight >= head_height){
        headShowHeight = head_height;
    }
    return headShowHeight;
}

-(BOOL)selectVcAtIndex:(NSInteger)index{
    NSInteger lastIndex = self.currentIndex;
    if (![super selectVcAtIndex:index]) { return NO; }
    
    if (!_headView) { return YES; }
    
    UIViewController<KYHeaderRefreshVcProtocol> *vc = (UIViewController<KYHeaderRefreshVcProtocol> *)self.subVcs[self.currentIndex];
    BOOL isviewLoad = vc.isViewLoaded;
    
    _headView.responseView = vc.scrollView;
    
    //fix bug:初次加载vc时，contentInset会有意料之外的值
    UIEdgeInsets insets = vc.scrollView.contentInset;
    insets.top = _headView.maxShowHeight + vc.defaultTop;
    vc.scrollView.contentInset = insets;
        
    if (isviewLoad) {
        CGFloat scrollHeight = vc.scrollView.contentSize.height + insets.top - (_headView.maxShowHeight - _headView.minShowHeight);
        if (scrollHeight < CGRectGetHeight(vc.scrollView.frame) - insets.top) {
            [vc.scrollView setContentOffset:CGPointMake(0, -insets.top) animated:YES];
            !vc.offsetYChanged ? : vc.offsetYChanged(vc);
            return YES;
        }
        CGFloat maxHeight = _headView.maxShowHeight;
        UIViewController<KYHeaderRefreshVcProtocol> *lastVc = (UIViewController<KYHeaderRefreshVcProtocol> *)self.subVcs[lastIndex];
        CGFloat offsetY = lastVc.scrollView.contentOffset.y;
        CGFloat showHeight = [self headHeightWithVc:lastVc];
        if (showHeight != maxHeight) {
            offsetY = maxHeight - lastVc.scrollView.contentInset.top - showHeight;
        }
        [vc.scrollView setContentOffset:CGPointMake(0, offsetY) animated:YES];
        return YES;
    }
    
    [vc.scrollView setContentOffset:CGPointMake(0, -insets.top) animated:YES];
    return YES;
}


@end
