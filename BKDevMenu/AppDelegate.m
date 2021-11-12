//
//  AppDelegate.m
//  BKDevMenu
//
//  Created by luzz on 2021/11/3.
//

#import "AppDelegate.h"
#import "BKDevMenuManager.h"
#import "DemoMenu.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [BKDevMenuManager shareManager].enable = YES;
    [[BKDevMenuManager shareManager] setupMenu:[DemoMenu new]];
    
    
    return YES;
}




@end
