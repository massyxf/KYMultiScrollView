//
//  KYScrollVcProtocol.h
//  KYMultiScrollView
//
//  Created by yxf on 2020/8/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KYHeaderRefreshVcProtocol <NSObject>

@property (nonatomic,weak,readonly)UIScrollView *scrollView;
@property (nonatomic,assign)CGFloat top;

@property (nonatomic,copy)void (^offsetYChanged)(CGFloat y,id<KYHeaderRefreshVcProtocol>vc);

@end

NS_ASSUME_NONNULL_END
