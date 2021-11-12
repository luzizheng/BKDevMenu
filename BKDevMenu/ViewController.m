//
//  ViewController.m
//  BKDevMenu
//
//  Created by luzz on 2021/11/3.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Index";
    self.view.backgroundColor = [UIColor whiteColor];
    
    /// 随便插入一点用户偏好数据
    
    NSString * imgPath = @"/Users/apple/Downloads/123.jpeg";
    NSData * data = [NSData dataWithContentsOfFile:imgPath];
    NSDictionary * dict = @{@"str":@"jaiofjdisahfildhsiah",
                            @"dic":@{@"num":@(2),
                                     @"arr":@[@"12321",@"sajfd",@"2",@"efdf"]
                            },
                            @"arr":@[@{@"str":@"123"},@{@"num":@(234)}],
                            @"img":data,
                            @"bool":@(YES),
                            @"date":[NSDate date]
    };
    [[NSUserDefaults standardUserDefaults] setValue:dict forKey:@"demoUD"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    NSUserDefaults * df = [[NSUserDefaults alloc] initWithSuiteName:@"www.demo.luzz"];
    
    [df setValue:@"luzz" forKey:@"luzzName"];
    [df synchronize];
    
}


@end
