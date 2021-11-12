# BKDevMenu
iOS App调试菜单入口

#### 自带功能有：

1. 查看app控制台
2. 查看app沙盒文件浏览器；
3. 全局快速切换环境按钮（UISegmentContrller）；
4. 测试页面快速预览入口；
5. 快速登陆模块（配置快速登陆名单）



## Installation:

```ruby
pod 'BKDevMenu'
```



仅在DEBUG模式下导入(不增加生产包大小)

```ruby
pod 'BKDevMenu', :configurations => ['Debug']
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

     

