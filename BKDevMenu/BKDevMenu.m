//
//  BKDevMenu.m
//  BKDevMenu
//
//  Created by luzz on 2021/11/3.
//

#import "BKDevMenu.h"
#import "TestVC.h"

@implementation BKDevMenu
- (void)addTestPages
{
    [self addTestPageWithTitle:@"测试页面1" andAction:^(UINavigationController * _Nonnull nav) {
        [nav pushViewController:[TestVC new] animated:YES];
    }];

    [self addTestSegmentWithTitle:@"切换服务器" segments:@[@"测试",@"生产",@"仿真"] defaultIndex:^NSInteger{
        return 1;
    } segAction:^(NSInteger index, UINavigationController * _Nonnull nav) {
        [nav pushViewController:[TestVC new] animated:YES];
    }];
    
    NSUserDefaults * df = [[NSUserDefaults alloc] initWithSuiteName:@"www.demo.luzz"];
    [self addSandBoxViewer:@[df]];
    
    [self addAppConsole];
    
    [self addQuickLoginUserListWithLoginAction:^(UINavigationController * _Nonnull nav, BKDevQuickLoginUserModel * _Nonnull user) {
        //
    }];

}
@end
