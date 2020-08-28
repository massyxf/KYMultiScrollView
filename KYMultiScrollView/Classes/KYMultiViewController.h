//
//  KYMultiViewController.h
//  KYMultiScrollView
//
//  Created by yxf on 2020/8/27.
//

#import <UIKit/UIKit.h>

@protocol KYScrollVcProtocol;
@class KYMultiHeadView,KYMultiViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol KYMultiViewControllerDelegate <NSObject>

-(void)multiViewController:(KYMultiViewController *)multiVc
          currentVcChanged:(UIViewController<KYScrollVcProtocol> *)currentVc
                     index:(NSInteger)index;

@end

@interface KYMultiViewController : UIViewController

@property (nonatomic,strong)UIColor *bgColor;

-(instancetype)initWithSubVcs:(NSArray<UIViewController<KYScrollVcProtocol> *> *)subVcs
                     headView:(KYMultiHeadView *)headView
                 defaultIndex:(NSInteger)index;

@property (nonatomic,weak)id<KYMultiViewControllerDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
