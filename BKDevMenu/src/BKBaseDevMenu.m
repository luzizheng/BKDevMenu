//
//  BKBaseDevMenu.m
//  BKDevMenu
//
//  Created by luzz on 2021/11/3.
//

#import "BKBaseDevMenu.h"
#import "LZZSandboxViewerVC.h"
#import "BKConsoleManager.h"
#import "BKDevConsoleVC.h"
#import "BKQuickLoginListVC.h"
@interface BKBaseDevMenu()
@property(nonatomic,copy)void(^loginAction)(UINavigationController *nav,BKDevQuickLoginUserModel*user);
@property(nonatomic,strong)NSMutableArray * menuItemsEdit;
@end

@implementation BKBaseDevMenu


- (instancetype)init
{
    if (self = [super init]) {
        [self addTestPages];
    }
    return self;
}

-(void)addTestPages{
    
}


- (void)addTestPageWithTitle:(NSString *)title andAction:(void (^)(UINavigationController * _Nonnull))action
{
    [self addTestPageWithTitle:title style:BKDevMenuItemStyleDefault andAction:action];
    
}

-(void)addTestPageWithTitle:(NSString *)title style:(BKDevMenuItemStyle)style andAction:(void (^)(UINavigationController * nav))action
{
    BKDevMenuItem * item = [BKDevMenuItem itemWithTitle:title andStyle:style andAction:action];
    [self.menuItemsEdit addObject:item];
}

-(void)addTestSegmentWithTitle:(NSString *)title segments:(NSArray<NSString *> *)segments defaultIndex:(NSInteger (^)(void))defaultIndexHandler segAction:(void (^)(NSInteger, UINavigationController * _Nonnull))segAction
{
    BKDevMenuItem * item = [BKDevMenuItem itemSegmentWithTitle:title segments:segments defaultIndex:defaultIndexHandler segAction:segAction];
    [self.menuItemsEdit addObject:item];
}

- (NSArray *)allMenuItems
{
    if (self.loginAction) {
        
        NSMutableArray * tempA = [NSMutableArray array];
        for (BKDevMenuItem * item in self.menuItemsEdit) {
            if (item.style != BKDevMenuItemStyleQuickLogin) {
                [tempA addObject:item];
            }
        }
        
        NSInteger targetIndex = -1;
        for (int i = 0; i< tempA.count; i++) {
            BKDevMenuItem * obj = tempA[i];
            if ([obj.identifier isEqualToString:@"addLogin"]) {
                targetIndex = i;
                break;
            }
        }
        targetIndex +=1;
        
        
        NSArray * a = [tempA subarrayWithRange:NSMakeRange(0, targetIndex)];
        NSArray * b = [tempA subarrayWithRange:NSMakeRange(targetIndex, tempA.count - targetIndex)];
        

        NSMutableArray * tempB = [NSMutableArray array];
        __weak typeof(self)weakSelf = self;
        for (BKDevQuickLoginUserModel * user in [BKDevQuickLoginUserModel modelArray]) {
            BKDevMenuItem * item = [BKDevMenuItem itemWithTitle:user.title andStyle:BKDevMenuItemStyleQuickLogin andAction:^(id  _Nonnull obj) {
                weakSelf.loginAction(obj, user);
            }];
            [tempB addObject:item];
        }
        NSMutableArray * tempC = [NSMutableArray array];
        [tempC addObjectsFromArray:a];
        [tempC addObjectsFromArray:tempB];
        [tempC addObjectsFromArray:b];
        
        return tempC;
    }else{
        return self.menuItemsEdit;
    }
    
}

#pragma mark - getter and setter and lazy

- (NSMutableArray *)menuItemsEdit
{
    if (!_menuItemsEdit) {
        _menuItemsEdit = [NSMutableArray array];
    }
    return _menuItemsEdit;
}
@end





@implementation BKBaseDevMenu (Extend)

-(void)addSandBoxViewer:(NSArray<NSUserDefaults *> *)additionalUserDefaults
{
    
    [self addTestPageWithTitle:@"沙盒浏览器" andAction:^(UINavigationController * _Nonnull nav) {
        
        LZZSandboxViewerVC * vc = [[LZZSandboxViewerVC alloc] init];
        vc.additionalUserDefaults = additionalUserDefaults;
        [nav pushViewController:vc animated:YES];
    }];
}
-(void)addAppConsole
{
    [BKConsoleManager shareManager].enable = YES;
    
    [self addTestPageWithTitle:@"App控制台" andAction:^(UINavigationController * _Nonnull nav) {
        
        if ([BKConsoleManager shareManager].window) {
            [[BKConsoleManager shareManager].window makeKeyAndVisible];
        }else{
            UIWindow * window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            window.windowLevel = UIWindowLevelAlert-1;
            BKDevConsoleVC * vc = [[BKDevConsoleVC alloc] init];
            window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
            [window makeKeyAndVisible];
            [BKConsoleManager shareManager].window = window;
            
            vc.hideBlock = ^{
                [[BKConsoleManager shareManager].window resignKeyWindow];
                [BKConsoleManager shareManager].window.hidden = YES;
                [BKConsoleManager shareManager].window = nil;
            };
        }
    }];
}
-(void)addQuickLoginUserListWithLoginAction:(void (^)(UINavigationController * _Nonnull, BKDevQuickLoginUserModel * _Nonnull))loginAction
{
    self.loginAction = loginAction;
    BKDevMenuItem * item = [BKDevMenuItem itemWithTitle:@"添加快速登陆账号+" andStyle:BKDevMenuItemStyleDefault andAction:^(id  _Nonnull obj) {
        [(UINavigationController *)obj pushViewController:[BKQuickLoginListVC new] animated:YES];
    }];
    item.identifier = @"addLogin";
    [self.menuItemsEdit addObject:item];
    
    
}
@end
