# BKDevMenu
百科app端调试菜单入口

## Installation:

```ruby
pod 'BKDevMenu', :git => 'http://192.168.1.30/luzizheng/BKDevMenu.git'
```



仅在百科DEBUG模式下导入(不增加生产包大小)

```ruby
pod 'BKDevMenu', :git => 'http://192.168.1.30/luzizheng/BKDevMenu.git', :configurations => ['Debug','Debug_UAT','Debug_PRD','Pre_Debug']
```



## Usage:

* #### App启动：

```objective-c
#import "BKDevMenuManager.h"
[BKDevMenuManager shareManager].enable = YES;
[[BKDevMenuManager shareManager] setupMenu:[BKDevMenu new]];
```

- #### 添加测试入口

  1. 创建一个类继承BKBaseDevMenu

     ```objective-c
     @interface BKDevMenu : BKBaseDevMenu
     
     @end
     ```

     

  2. .m文件中引入并添加一些测试页面

     ```objective-c
     #import "BKDevMenu.h"
     
     #import "TestVC1.h"
     #import "TestVC2.h"
     #import "TestVC3.h"
     
     @implementation BKDevMenu
     - (void)addTestPages
     {
         [self addTestPageWithTitle:@"测试页面1" andAction:^(UINavigationController * _Nonnull nav) {
             [nav pushViewController:[TestVC1 new] animated:YES];
         }];
         [self addTestPageWithTitle:@"测试页面2" andAction:^(UINavigationController * _Nonnull nav) {
             [nav pushViewController:[TestVC2 new] animated:YES];
         }];
         [self addTestPageWithTitle:@"测试页面3" andAction:^(UINavigationController * _Nonnull nav) {
             [nav pushViewController:[TestVC3 new] animated:YES];
         }];
         
     }
     @end
     ```

     

