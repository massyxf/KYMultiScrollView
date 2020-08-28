//
//  KYMultiViewController.h
//  KYMultiScrollView
//
//  Created by yxf on 2020/8/27.
//

#import <UIKit/UIKit.h>

@protocol KYScrollVcProtocol;
@class KYMultiHeadView;

NS_ASSUME_NONNULL_BEGIN

@interface KYMultiViewController : UIViewController

@property (nonatomic,strong)UIColor *bgColor;

-(instancetype)initWithSubVcs:(NSArray<id<KYScrollVcProtocol>> *)subVcs
                     headView:(KYMultiHeadView *)headView
                 defaultIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
