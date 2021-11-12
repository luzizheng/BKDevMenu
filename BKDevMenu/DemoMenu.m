//
//  DemoMenu.m
//  BKDevMenu
//
//  Created by luzz on 2021/11/12.
//

#import "DemoMenu.h"
#import "TestVC.h"



@implementation DemoMenu
- (void)addingTestPages
{
    /// 添加页面快速入口
    [self addTestPageWithTitle:@"测试页面1" andAction:^(UINavigationController * _Nonnull nav) {
        [nav pushViewController:[TestVC new] animated:YES];
    }];
    [self addTestPageWithTitle:@"测试页面2" andAction:^(UINavigationController * _Nonnull nav) {
        [nav pushViewController:[TestVC new] animated:YES];
    }];

    /// 添加全局切换状态模块
    [self addTestSegmentWithTitle:@"切换服务器" segments:@[@"测试",@"生产",@"仿真"] defaultIndex:^NSInteger{
        return 1;
    } segAction:^(NSInteger index, UINavigationController * _Nonnull nav) {
        /// 根据index自行实现切换逻辑
    }];
    
    
    /// 添加沙盒文件浏览器模块
    NSUserDefaults * df = [[NSUserDefaults alloc] initWithSuiteName:@"www.demo.luzz"];
    [self addSandBoxViewer:@[df]];
    
    /// 添加app内置控制台模块
    [self addAppConsole];
    
    
    /// 添加快速登陆模块
    [self addQuickLoginUserListWithLoginAction:^(UINavigationController * _Nonnull nav, BKDevQuickLoginUserModel * _Nonnull user) {
        // 具体实现登陆的逻辑
    }];

}
@end
