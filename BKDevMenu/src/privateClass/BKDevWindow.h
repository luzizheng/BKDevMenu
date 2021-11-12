//
//  BKDevWindow.h
//  BKDevMenu
//
//  Created by luzz on 2021/11/3.
//

#import <UIKit/UIKit.h>
#import "BKDevRootVC.h"
NS_ASSUME_NONNULL_BEGIN


@interface BKDevWindow : UIWindow
@property(nonatomic,assign)BOOL open;
@property(nonatomic,readonly)BKDevRootVC * devRootVC;

/// the point of origin X-axis and Y-axis
@property (nonatomic, assign)CGPoint axisXY;

-(void)maxmize;
-(void)minimize;


-(void)bkdev_resignKeyWindow;

@end

NS_ASSUME_NONNULL_END
