//
//  KYMultiViewController.m
//  KYMultiScrollView
//
//  Created by yxf on 2020/8/27.
//

#import "KYMultiViewController.h"
#import "KYScrollVcProtocol.h"
#import "KYMultiHeader.h"
#import "KYMultiHeadView.h"


@interface KYMultiViewController ()<UIScrollViewDelegate>

@property (nonatomic,copy)NSArray<id<KYScrollVcProtocol>> *subVcs;
@property (nonatomic,assign)NSInteger currentIndex;

@property (nonatomic,weak)UIScrollView *bgScrollview;

@property (nonatomic,strong)KYMultiHeadView *headView;

@end

@implementation KYMultiViewController

-(instancetype)initWithSubVcs:(NSArray<id<KYScrollVcProtocol>> *)subVcs headView:(KYMultiHeadView *)headView defaultIndex:(NSInteger)index{
    if (self = [self init]) {
        _subVcs = [subVcs copy];
        _headView = headView;
        _currentIndex = index;
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
    
    if (_headView) {
        [self.view addSubview:_headView];
    }
    
    [self configSubVcs];
    
    [self selectIndex:_currentIndex];
}

-(void)configSubVcs{
    KYWeakSelf
    CGFloat head_height = _headView.maxShowHeight;
    [_subVcs enumerateObjectsUsingBlock:^(id<KYScrollVcProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.top = head_height;
        obj.offsetYChanged = ^(CGFloat offsetY,id<KYScrollVcProtocol> subVc) {
            id<KYScrollVcProtocol> currentVc = weakSelf.subVcs[weakSelf.currentIndex];
            if (subVc != currentVc) {
                return;
            }
            //head
            //NSLog(@"%f --- %f",offsetY,subVc.scrollView.contentInset.top);
            CGFloat headShowHeight = [self headHeightWithVc:subVc offset:offsetY];
            CGRect frame = weakSelf.headView.frame;
            frame.origin.y = headShowHeight - frame.size.height;
            weakSelf.headView.frame = frame;
            
            //vc
            [weakSelf alterOtherVcOffsetWithHeaderShowHeight:headShowHeight];
        };
        [self addChildViewController:(UIViewController *)obj];
    }];}

-(void)alterOtherVcOffsetWithHeaderShowHeight:(CGFloat)height{
    CGFloat head_height = _headView.maxShowHeight;
    for (int i=0; i<_subVcs.count; i++) {
        if (i == _currentIndex) {
            continue;
        }
        id<KYScrollVcProtocol> vc = _subVcs[i];
        if (((UIViewController *)vc).isViewLoaded) {
            //根据当前offset算出此时head的高度
            CGFloat offsetY = vc.scrollView.contentOffset.y;
            CGFloat headShowHeight = [self headHeightWithVc:vc offset:offsetY];
            if (headShowHeight != height) {
                offsetY = head_height - vc.scrollView.contentInset.top - height;
                dispatch_async(dispatch_get_main_queue(), ^{
                    vc.scrollView.contentOffset = CGPointMake(0, offsetY);
                });
            }
        }
    }
}

#pragma mark - custom func
-(void)selectIndex:(NSInteger)index{
    id<KYScrollVcProtocol> vc = _subVcs[index];
    UIViewController *viewcontroller = (UIViewController *)vc;
    BOOL isviewLoad = viewcontroller.isViewLoaded;
    
    if (index == _currentIndex && isviewLoad) {
        return;
    }
    
    CGFloat needOffset = 0;
    if (!isviewLoad) {
        CGFloat head_height = _headView.maxShowHeight;
        id<KYScrollVcProtocol> currentVc = _subVcs[_currentIndex];
        CGFloat offsetY = currentVc.scrollView.contentOffset.y;
        CGFloat headShowHeight = [self headHeightWithVc:currentVc offset:offsetY];
        if (headShowHeight != head_height) {
            offsetY = head_height - currentVc.scrollView.contentInset.top - headShowHeight;
        }
        needOffset = offsetY;
    }
    
    
    [_bgScrollview addSubview:viewcontroller.view];
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    viewcontroller.view.frame = CGRectMake(index * width, 0, width, height);
    
    _headView.responseView = vc.scrollView;
    _currentIndex = index;
    
    if (!isviewLoad) {
        vc.scrollView.contentOffset = CGPointMake(0, needOffset);
    }
}

-(CGFloat)headHeightWithVc:(id<KYScrollVcProtocol>)vc offset:(CGFloat)offsetY{
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


#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat width = CGRectGetWidth(self.view.bounds);
    NSInteger index = (scrollView.contentOffset.x + 10) / width;
    [self selectIndex:index];
}



@end
