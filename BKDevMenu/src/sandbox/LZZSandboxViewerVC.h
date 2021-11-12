//
//  LZZSandboxViewerVC.h
//  LZZSandboxViewer
//
//  Created by luzz on 2021/11/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/// 沙盒入口页
@interface LZZSandboxViewerVC : UITableViewController

/// 添加额外的用户偏好域
@property(nonatomic,strong)NSArray <NSUserDefaults *>* additionalUserDefaults;

@end

NS_ASSUME_NONNULL_END
