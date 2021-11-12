//
//  BKDevMenuManager.m
//  BKDevMenu
//
//  Created by luzz on 2021/11/3.
//

#import "BKDevMenuManager.h"
#import "BKDevRootVC.h"
#import "BKDevMenuItem.h"
#import "BKDevWindow.h"
#pragma mark - BKDevMenuManager
@interface BKDevMenuManager()
@property(nonatomic,strong)__kindof BKBaseDevMenu * menu;
@property(nonatomic,strong)BKDevWindow * devWindow;
@property(nonatomic,assign)BOOL actionSheetShowing;
@property(nonatomic,strong)UIPanGestureRecognizer * panOutGesture;
@end

@implementation BKDevMenuManager
static BKDevMenuManager *sharedInstance = nil;
+(BKDevMenuManager*)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super allocWithZone:NULL] init];
    });
    return sharedInstance;
}
+ (id)allocWithZone:(NSZone *)zone
{
    return [self shareManager];
}
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (void)setupMenu:(__kindof BKBaseDevMenu *)menu
{
    self.menu = menu;
    __weak typeof(self)weakSelf = self;
    
    [self.menu addTestPageWithTitle:@"移除DEV按钮" style:BKDevMenuItemStyleDestructive andAction:^(UINavigationController * _Nonnull nav) {
        weakSelf.enable = NO;
    }];
    
    [self.menu addTestPageWithTitle:@"取消" style:BKDevMenuItemStyleCancel andAction:^(UINavigationController * _Nonnull nav) {
        [weakSelf minimizeAnimation];
    }];
}

// 找到最上层导航栏
-(UINavigationController *)getTopBusinessNav
{
    UINavigationController * targetNav = nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    NSArray * windows =[[UIApplication sharedApplication].windows reverseObjectEnumerator].allObjects;
#pragma clang diagnostic pop
    for (UIWindow * window in windows) {
        if (window!=self.devWindow) {
            if (window.rootViewController) {
                if ([window.rootViewController isKindOfClass:[UITabBarController class]]) {
                    UITabBarController * tabVC = (UITabBarController *)window.rootViewController;
                    if ([tabVC.selectedViewController isKindOfClass:[UINavigationController class]]) {
                        targetNav = tabVC.selectedViewController;
                        break;
                    }
                }else if ([window.rootViewController isKindOfClass:[UINavigationController class]]){
                    targetNav = (UINavigationController *)window.rootViewController;
                    break;
                }
            }
            
        }
    }
    return targetNav;
}


-(void)devBtnClick
{
    self.devWindow.devRootVC.menuItem = [self.menu allMenuItems];
    self.devWindow.devRootVC.currentTopNav = [self getTopBusinessNav];
    [self maximumAnimation];
}

-(void)maximumAnimation
{
    
    [self.devWindow maxmize];
}

-(void)minimizeAnimation
{
    [self.devWindow minimize];
}




- (void)setEnable:(BOOL)enable
{
    _enable = enable;
    self.devWindow.hidden = !enable;
    [self.devWindow bkdev_resignKeyWindow];
}

-(BOOL)isIPHONEX
{
    BOOL is_iPhoneX = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return is_iPhoneX;
    }
    
    if (@available(ios 11.0, *)) {
        // 利用safeAreaInsets.bottom > 0.0来判断是否是iPhone X。
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            is_iPhoneX = YES;
        }
    }
    return is_iPhoneX;
}
- (void)panGesture:(UIPanGestureRecognizer *)gesture {

    if (self.actionSheetShowing) {
        return;
    }
    if(gesture.state == UIGestureRecognizerStateChanged){
        CGPoint translation = [gesture translationInView:gesture.view];
        CGRect rect = CGRectOffset(self.devWindow.frame, translation.x, translation.y);
        self.devWindow.frame = rect;
        [gesture setTranslation:CGPointZero inView:gesture.view];
        self.devWindow.axisXY = self.devWindow.frame.origin;
    }else if (gesture.state == UIGestureRecognizerStateEnded||gesture.state == UIGestureRecognizerStateCancelled){
        CGRect rect = self.devWindow.frame;
        if(self.devWindow.center.y<rect.size.height/2.0f){
            rect.origin.y = [self isIPHONEX]?44:20;
        }else if (self.devWindow.center.y>[UIScreen mainScreen].bounds.size.height-rect.size.height/2.0f){
            rect.origin.y = [UIScreen mainScreen].bounds.size.height-rect.size.height;
        }else{
            if(self.devWindow.center.x<[UIScreen mainScreen].bounds.size.width/2.0f){
                rect.origin.x = 0;
            }else{
                rect.origin.x = [UIScreen mainScreen].bounds.size.width-rect.size.width;
            }
        }
        self.devWindow.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.devWindow.frame = rect;
        } completion:^(BOOL finished) {
            self.devWindow.userInteractionEnabled = YES;
            self.devWindow.axisXY = self.devWindow.frame.origin;
            [self.devWindow bkdev_resignKeyWindow];
            
        }];
    }
}
#pragma mark - lazy

- (BKDevWindow *)devWindow
{
    if (!_devWindow) {
        _devWindow = [[BKDevWindow alloc] init];
        _devWindow.hidden = YES;
        [_devWindow.devRootVC.view addGestureRecognizer:self.panOutGesture];
        [_devWindow.devRootVC.devBtn addTarget:self action:@selector(devBtnClick) forControlEvents:UIControlEventTouchUpInside];
        __weak typeof(self)weakSelf = self;
        _devWindow.devRootVC.minimizeActionBlock = ^{
            [weakSelf minimizeAnimation];
        };
    }
    return _devWindow;
}

- (UIPanGestureRecognizer *)panOutGesture{
    if (!_panOutGesture) {
        _panOutGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    }
    return _panOutGesture;
}
@end
