//
//  KYTopRefreshMultiViewController.h
//  KYMultiScrollView
//
//  Created by yxf on 2020/8/28.
//

#import <KYMultiScrollView/KYMultiViewController.h>

NS_ASSUME_NONNULL_BEGIN

@class KYMultiHeadView;
@protocol KYTopRefreshVcProtocol;

@interface KYTopRefreshMultiViewController : KYMultiViewController

-(instancetype)initWithSubVcs:(NSArray<UIViewController<KYTopRefreshVcProtocol> *> *)subVcs
                 defaultIndex:(NSInteger)index
                     headView:(KYMultiHeadView *)headView;

@end

NS_ASSUME_NONNULL_END
