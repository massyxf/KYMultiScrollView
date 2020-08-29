//
//  KYTopRefreshVcProtocol.h
//  KYMultiScrollView
//
//  Created by yxf on 2020/8/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KYTopRefreshVcProtocol <NSObject>

@property (nonatomic,weak,readonly)UIScrollView *scrollView;
@property (nonatomic,copy)void (^contentSizeChanged)(CGSize size,UIViewController<KYTopRefreshVcProtocol> *vc);

@end

NS_ASSUME_NONNULL_END
