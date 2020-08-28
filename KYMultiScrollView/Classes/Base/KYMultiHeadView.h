//
//  KYMultiHeadView.h
//  KYMultiScrollView
//
//  Created by yxf on 2020/8/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYMultiHeadView : UIView

@property (nonatomic,weak)UIView *responseView;

/// 最大展示高度,<=0 时为自己的高度,不得高于自己的height
@property (nonatomic,assign)CGFloat maxShowHeight;
///最小展示高度,0~maxShowHeight,默认为0
@property (nonatomic,assign)CGFloat minShowHeight;

@end

NS_ASSUME_NONNULL_END
