//
//  KYMultiHeadView.m
//  KYMultiScrollView
//
//  Created by yxf on 2020/8/27.
//

#import "KYMultiHeadView.h"

@implementation KYMultiHeadView

-(CGFloat)maxShowHeight{
    CGFloat height = CGRectGetHeight(self.bounds);
    if (_maxShowHeight <= 0) {
        _maxShowHeight = height;
    }
    if (_maxShowHeight > height) {
        _maxShowHeight = height;
    }
    return _maxShowHeight;
}

-(CGFloat)minShowHeight{
    if (_minShowHeight < 0) {
        _minShowHeight = 0;
    }
    if (_minShowHeight > self.maxShowHeight) {
        _minShowHeight = self.maxShowHeight;
    }
    return _minShowHeight;
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    CGRect windowRect = [self convertRect:self.bounds toView:[UIApplication sharedApplication].delegate.window];
    if (CGRectContainsPoint(windowRect, point) == false) {
        return nil;
    }
    
    UIView *view = [super hitTest:point withEvent:event];
    if (!_responseView) {
        return view;
    }
    if (view != self && view.userInteractionEnabled) {
        return view;
    }
    return _responseView;
}

@end
