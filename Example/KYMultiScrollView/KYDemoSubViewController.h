//
//  KYDemoSubViewController.h
//  KYMultiScrollView_Example
//
//  Created by yxf on 2020/8/27.
//  Copyright © 2020 massyxf. All rights reserved.
//

#import <KYMultiScrollView/KYHeaderRefreshVcProtocol.h>
#import <KYMultiScrollView/KYTopRefreshVcProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYDemoSubViewController : UIViewController<KYHeaderRefreshVcProtocol,KYTopRefreshVcProtocol>

@property (nonatomic,copy)void (^offsetYChanged)(CGFloat y,id<KYHeaderRefreshVcProtocol>vc);
@property (nonatomic,copy)void (^contentSizeChanged)(CGSize size,UIViewController<KYTopRefreshVcProtocol> *vc);

-(void)loadData:(BOOL)isMore;

@end

NS_ASSUME_NONNULL_END
