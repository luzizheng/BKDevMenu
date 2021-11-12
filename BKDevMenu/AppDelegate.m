//
//  AppDelegate.m
//  BKDevMenu
//
//  Created by luzz on 2021/11/3.
//

#import "AppDelegate.h"
#import "BKDevMenuManager.h"
#import "BKDevMenu.h"
#import "BKQuickLoginEditVC.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [BKDevMenuManager shareManager].enable = YES;
    [[BKDevMenuManager shareManager] setupMenu:[BKDevMenu new]];
    
//    UIWindow * window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[BKQuickLoginEditVC new]];
//    self.window = window;
//    [window makeKeyWindow];
    
    return YES;
}




@end
