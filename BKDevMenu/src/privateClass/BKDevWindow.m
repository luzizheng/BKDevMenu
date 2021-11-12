//
//  BKDevWindow.m
//  BKDevMenu
//
//  Created by luzz on 2021/11/3.
//

#import "BKDevWindow.h"

@interface BKDevWindow()

@end

@implementation BKDevWindow

- (BKDevRootVC *)devRootVC
{
    return (BKDevRootVC *)self.rootViewController;
}

- (instancetype)init
{
    if (self = [super initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - kDevBtnWidth, 300, kDevBtnWidth, kDevBtnWidth)]) {
        self.userInteractionEnabled = YES;
        self.windowLevel = UIWindowLevelStatusBar + 100;
        BKDevRootVC * vc = [BKDevRootVC new];
        self.rootViewController = vc;
        self.axisXY = self.frame.origin;
    }
    return self;
}
-(void)maxmize
{
    self.frame = [UIScreen mainScreen].bounds;
    self.devRootVC.actionView.frame = CGRectMake(self.axisXY.x, self.axisXY.y, kDevBtnWidth, kDevBtnWidth);
    
    CGFloat list_h = [self.devRootVC listHeight];
    CGRect listRect = CGRectMake(20, ([UIScreen mainScreen].bounds.size.height - list_h)/2, [UIScreen mainScreen].bounds.size.width - 40, list_h);
    [self.devRootVC.actionView transformToSqureWithRect:listRect];
    [UIView animateWithDuration:kDuration animations:^{
        self.devRootVC.devBtn.alpha = 0;
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.devRootVC.tableView.alpha = 1.0;
        [self.devRootVC.tableView reloadData];
    }];
}
-(void)minimize
{
    [self bkdev_resignKeyWindow];
    
    CGRect targetRect = CGRectMake(self.axisXY.x, self.axisXY.y, kDevBtnWidth, kDevBtnWidth);
    
    [self.devRootVC.actionView transformToCircleWithRect:targetRect];
    
    [UIView animateWithDuration:kDuration animations:^{
        self.devRootVC.devBtn.alpha = 1.0;
        self.devRootVC.tableView.alpha = 0.0;
        [self setNeedsLayout];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.frame = targetRect;
        self.devRootVC.actionView.frame = CGRectMake(0, 0, kDevBtnWidth, kDevBtnWidth);
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.rootViewController.view.frame = self.bounds;
}

-(void)bkdev_resignKeyWindow
{
    [self resignKeyWindow];
    __weak typeof(self)weakSelf = self;
    [[UIApplication sharedApplication].windows.reverseObjectEnumerator.allObjects enumerateObjectsUsingBlock:^(__kindof UIWindow * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj != weakSelf && CGSizeEqualToSize(obj.bounds.size, [UIScreen mainScreen].bounds.size)) {
            [obj makeKeyWindow];
            *stop = YES;
        }
    }];
}
@end
