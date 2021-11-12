//
//  BKDevTransformView.m
//  BKDevMenu
//
//  Created by luzz on 2021/11/4.
//

#import "BKDevTransformView.h"
@interface BKDevTransformView()<CAAnimationDelegate>
@end
@implementation BKDevTransformView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.layer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8].CGColor;
        self.layer.cornerRadius = kDevBtnWidth/2;
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
}
-(UIBezierPath *)getSqurePathWithRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, rect.size.width, rect.size.height) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(4, 4)];
    return path;
}
-(void)transformToCircleWithRect:(CGRect)rect
{
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    animation.toValue = @(kDevBtnWidth/2);
    animation.delegate = self;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.layer addAnimation:animation forKey:@"cornerRadius"];

    [UIView animateWithDuration:kDuration animations:^{
        self.frame = rect;
    }];
    [UIView animateWithDuration:kDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = rect;
    } completion:nil];
}
-(void)transformToSqureWithRect:(CGRect)rect
{
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    animation.toValue = @(4);
    animation.delegate = self;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.layer addAnimation:animation forKey:@"cornerRadius"];
    [UIView animateWithDuration:kDuration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.frame = rect;
    } completion:nil];
}
- (void)animationDidStart:(CAAnimation *)anim{}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{}


@end
