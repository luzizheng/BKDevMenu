//
//  BKBaseDevMenu.h
//  BKDevMenu
//
//  Created by luzz on 2021/11/3.
//

#import <UIKit/UIKit.h>
#import "BKDevMenuItem.h"
#import "BKDevQuickLoginUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BKBaseDevMenu : NSObject


-(NSArray *)allMenuItems;

/// 添加一个测试页面入口
-(void)addTestPageWithTitle:(NSString *)title andAction:(void (^)(UINavigationController * nav))action;

/// 添加一个测试页面入口
-(void)addTestPageWithTitle:(NSString *)title style:(BKDevMenuItemStyle)style andAction:(void (^)(UINavigationController * nav))action;

/// 添加一个带UISegmentContrller的选项
-(void)addTestSegmentWithTitle:(NSString *)title segments:(NSArray <NSString *>*)segments defaultIndex:(NSInteger(^)(void))defaultIndexHandler segAction:(void(^)(NSInteger index,UINavigationController * nav))segAction;

/// 子类继承重写，添加所有测试页面入口
-(void)addingTestPages;
@end

@interface BKBaseDevMenu (Extend)

/// 按需添加一个沙盒浏览器的入口
-(void)addSandBoxViewer:(NSArray <NSUserDefaults *>* _Nullable)additionalUserDefaults;
/// 按需添加一个app控制台浏览器入口
-(void)addAppConsole;
/// 按需添加快速登陆模块
-(void)addQuickLoginUserListWithLoginAction:(void(^)(UINavigationController * nav,BKDevQuickLoginUserModel * user))loginAction;

@end


NS_ASSUME_NONNULL_END
