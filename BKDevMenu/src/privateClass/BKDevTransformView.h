//
//  BKDevTransformView.h
//  BKDevMenu
//
//  Created by luzz on 2021/11/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


#define kDuration 0.25
#define kDevBtnWidth (50.0 * [UIScreen mainScreen].bounds.size.width / 375.0)


@interface BKDevTransformView : UIView
-(void)transformToCircleWithRect:(CGRect)rect;
-(void)transformToSqureWithRect:(CGRect)rect;
@end

NS_ASSUME_NONNULL_END
