//
//  BKDevRootVC.h
//  BKDevMenu
//
//  Created by luzz on 2021/11/3.
//

#import <UIKit/UIKit.h>
#import "BKDevTransformView.h"



NS_ASSUME_NONNULL_BEGIN

@interface BKDevRootVC : UIViewController
@property(nonatomic,strong)BKDevTransformView * actionView;
@property(nonatomic,strong)NSArray * menuItem;
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)UIButton * devBtn;
@property(nonatomic,weak)UINavigationController * currentTopNav;
@property (nonatomic,strong) void(^minimizeActionBlock)(void);
-(CGFloat)listHeight;
@end

NS_ASSUME_NONNULL_END
