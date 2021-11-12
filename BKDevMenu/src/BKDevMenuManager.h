//
//  BKDevMenuManager.h
//  BKDevMenu
//
//  Created by luzz on 2021/11/3.
//

#import <Foundation/Foundation.h>
#import "BKBaseDevMenu.h"

NS_ASSUME_NONNULL_BEGIN

/// 始终悬浮于app最上层的DEV按钮（可拖拽）
@interface BKDevMenuManager : NSObject

+(instancetype)shareManager;

/// 一般在app delegate 里打开
@property(nonatomic,assign)BOOL enable;

/// 新建一个类继承 BKBaseDevMenu，然后在里面添加测试页面入口
-(void)setupMenu:(__kindof BKBaseDevMenu *)menu;

@end

NS_ASSUME_NONNULL_END
