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
        obj.offsetYChanged = ^(CGFloat offsetY,id<KYHeaderRefreshVcProtocol> subVc) {
            //一般的多tableview嵌套
            if (!weakSelf.headView) { return; }
            
            if (!subVc.scrollView) { return; }
            
            UIViewController<KYHeaderRefreshVcProtocol> *currentVc = (UIViewController<KYHeaderRefreshVcProtocol> *)weakSelf.subVcs[weakSelf.currentIndex];
            if (subVc != currentVc) { return; }
            
            //head
            //NSLog(@"%f --- %f",offsetY,subVc.scrollView.contentInset.top);
            CGFloat headShowHeight = [self headHeightWithVc:subVc offset:offsetY];
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
        CGFloat headShowHeight = [self headHeightWithVc:vc offset:offsetY];
        if (headShowHeight == height) { continue; }
        offsetY = head_height - vc.scrollView.contentInset.top - height;
        dispatch_async(dispatch_get_main_queue(), ^{
            vc.scrollView.contentOffset = CGPointMake(0, offsetY);
        });
    }
}

-(CGFloat)headHeightWithVc:(id<KYHeaderRefreshVcProtocol>)vc offset:(CGFloat)offsetY{
    CGFloat head_height = _headView.maxShowHeight;
    CGFloat head_minHeight = _headView.minShowHeight;
    CGFloat headShowHeight = head_height - (offsetY + vc.scrollView.contentInset.top);
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
    
    UIViewController<KYHeaderRefreshVcProtocol> *viewcontroller = (UIViewController<KYHeaderRefreshVcProtocol> *)self.subVcs[self.currentIndex];
    BOOL isviewLoad = viewcontroller.isViewLoaded;
    
    CGFloat needOffset = 0;
    //一般的多tableview嵌套 _headView
    //初次加载 isviewLoad
    if (!isviewLoad && _headView) {
        CGFloat head_height = _headView.maxShowHeight;
        id<KYHeaderRefreshVcProtocol> currentVc = (UIViewController<KYHeaderRefreshVcProtocol> *)self.subVcs[lastIndex];
        CGFloat offsetY = currentVc.scrollView.contentOffset.y;
        CGFloat headShowHeight = [self headHeightWithVc:currentVc offset:offsetY];
        if (headShowHeight != head_height) {
            offsetY = head_height - currentVc.scrollView.contentInset.top - headShowHeight;
        }
        needOffset = offsetY;
    }
    
    _headView.responseView = viewcontroller.scrollView;
    
    //一般的多tableview嵌套
    if (!isviewLoad && _headView) {
        viewcontroller.scrollView.contentOffset = CGPointMake(0, needOffset);
    }
    
    //fix bug:初次加载vc时，contentInset会有意料之外的值
    UIEdgeInsets insets = viewcontroller.scrollView.contentInset;
    insets.top = _headView.maxShowHeight;
    viewcontroller.scrollView.contentInset = insets;
    
    return YES;
}


@end
