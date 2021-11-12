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

-(void)addTestPageWithTitle:(NSString *)title andAction:(void (^)(UINavigationController * nav))action;

-(void)addTestPageWithTitle:(NSString *)title style:(BKDevMenuItemStyle)style andAction:(void (^)(UINavigationController * nav))action;

-(void)addTestSegmentWithTitle:(NSString *)title segments:(NSArray <NSString *>*)segments defaultIndex:(NSInteger(^)(void))defaultIndexHandler segAction:(void(^)(NSInteger index,UINavigationController * nav))segAction;

/// 子类继承重写，添加所有测试页面入口
-(void)addTestPages;
@end

@interface BKBaseDevMenu (Extend)

-(void)addSandBoxViewer:(NSArray <NSUserDefaults *>* _Nullable)additionalUserDefaults;
-(void)addAppConsole;
-(void)addQuickLoginUserListWithLoginAction:(void(^)(UINavigationController * nav,BKDevQuickLoginUserModel * user))loginAction;

@end


NS_ASSUME_NONNULL_END
