//
//  KYMultiHeaderRefreshViewController.h
//  KYMultiScrollView
//
//  Created by yxf on 2020/8/28.
//

#import <KYMultiScrollView/KYMultiViewController.h>

@protocol KYScrollVcProtocol;
@class KYMultiHeadView;

NS_ASSUME_NONNULL_BEGIN

@interface KYMultiHeaderRefreshViewController : KYMultiViewController

-(instancetype)initWithSubVcs:(NSArray<UIViewController<KYScrollVcProtocol> *> *)subVcs
                     headView:(KYMultiHeadView *)headView
                 defaultIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
