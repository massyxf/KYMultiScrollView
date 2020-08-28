//
//  KYDemoSubViewController.h
//  KYMultiScrollView_Example
//
//  Created by yxf on 2020/8/27.
//  Copyright © 2020 massyxf. All rights reserved.
//

#import <KYMultiScrollView/KYScrollVcProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYDemoSubViewController : UIViewController<KYScrollVcProtocol>
@property (nonatomic,assign)CGFloat top;

@property (nonatomic,copy)void (^offsetYChanged)(CGFloat y,id<KYScrollVcProtocol>vc);

@end

NS_ASSUME_NONNULL_END
