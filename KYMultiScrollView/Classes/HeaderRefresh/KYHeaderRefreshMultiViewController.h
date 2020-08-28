//
//  KYMultiHeaderRefreshViewController.h
//  KYMultiScrollView
//
//  Created by yxf on 2020/8/28.
//

#import <KYMultiScrollView/KYMultiViewController.h>

@class KYMultiHeadView;
@protocol KYHeaderRefreshVcProtocol;

NS_ASSUME_NONNULL_BEGIN

@interface KYHeaderRefreshMultiViewController : KYMultiViewController

-(instancetype)initWithSubVcs:(NSArray<UIViewController<KYHeaderRefreshVcProtocol> *> *)subVcs
                     headView:(KYMultiHeadView *)headView
                 defaultIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
