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
@property (nonatomic,assign,readonly)CGFloat defaultTop;//暂时没什么用

@property (nonatomic,copy)void (^offsetYChanged)(id<KYHeaderRefreshVcProtocol>vc);

@end

NS_ASSUME_NONNULL_END
