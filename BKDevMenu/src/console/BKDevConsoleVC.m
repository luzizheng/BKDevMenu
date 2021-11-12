//
//  BKDevConsoleVC.m
//  DSLinPedia-OC
//
//  Created by luzz on 2021/10/29.
//  Copyright © 2021 DaShenLin Pharmaceutical Group. All rights reserved.
//

#import "BKDevConsoleVC.h"
#import "BKConsoleManager.h"

@interface BKDevConsoleSearchBar : UISearchBar

@end

@implementation BKDevConsoleSearchBar
{
    NSString *_cancelTitle;
    UIEdgeInsets _insets;
    UITextField *_searchField;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setUpView];
    }
    return self;
}

#pragma mark - Private
- (void)_setUpView
{
    // 设置搜索图标
     [self setImage: [UIImage imageNamed:@"search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    // iOS11版本以后 高度限制为44
    if (@available(iOS 11.0, *)) {
        [self.heightAnchor constraintEqualToConstant:44].active = YES;
        self.searchTextPositionAdjustment = (UIOffset){10, 0}; // 光标偏移量
    }
    // 设置边距
    CGFloat top = 8;
    CGFloat bottom = top;
    CGFloat left = 12;
    CGFloat right = left;
    _insets = UIEdgeInsetsMake(top, left, bottom, right);
}

- (void)_hookSearchBar
{
    // 遍历子视图，获取输入UITextFiled
    if (!_searchField) {
        NSArray *subviewArr = self.subviews;
        for(int i = 0; i < subviewArr.count ; i++) {
            UIView *viewSub = [subviewArr objectAtIndex:i];
            NSArray *arrSub = viewSub.subviews;
            for (int j = 0; j < arrSub.count ; j ++) {
                id tempId = [arrSub objectAtIndex:j];
                if([tempId isKindOfClass:[UITextField class]]) {
                    _searchField = (UITextField *)tempId;
                }
            }
        }
    }
    
    if (_searchField) {
        //自定义UISearchBar
        UITextField *searchField = _searchField;
        if (@available(iOS 11.0, *)) {
            // iOS11版本以后进行适配
            CGRect frame = searchField.frame;
            CGFloat offsetX = frame.origin.x - _insets.left;
            CGFloat offsetY = frame.origin.y - _insets.top;
            frame.origin.x = _insets.left;
            frame.origin.y = _insets.top;
            frame.size.height += offsetY * 2;
            frame.size.width += offsetX * 2;
            searchField.frame = frame;
        }
        // 自定义样式
        searchField.placeholder = @"请输入关键字";
        searchField.font = [UIFont systemFontOfSize:16];
        searchField.backgroundColor = [UIColor whiteColor];
        [searchField setBorderStyle:UITextBorderStyleNone];
        [searchField setTextAlignment:NSTextAlignmentLeft];
        [searchField setTextColor:[UIColor grayColor]];
        // 设置圆角
        searchField.layer.masksToBounds = YES;
        searchField.layer.cornerRadius = 5.0f;
        // 设置placeholder是否居中显示
        SEL centerSelector = NSSelectorFromString([NSString stringWithFormat:@"%@%@", @"setCenter", @"Placeholder:"]);
        if ([self respondsToSelector:centerSelector])
        {
            BOOL hasCentredPlaceholder = NO;
            NSMethodSignature *signature = [[UISearchBar class] instanceMethodSignatureForSelector:centerSelector];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:self];
            [invocation setSelector:centerSelector];
            [invocation setArgument:&hasCentredPlaceholder atIndex:2];
            [invocation invoke];
        }
    }
}
#pragma mark - Layout
-(void) layoutSubviews
{
    [super layoutSubviews];
    [self _hookSearchBar];
}




@end



@interface BKDevConsoleVC ()<UISearchBarDelegate>
@property(nonatomic,strong)UITextView * textView;
@property(nonatomic,strong)BKDevConsoleSearchBar * searchBar;
@property(nonatomic,strong)NSMutableArray * ranges;
@property(nonatomic,assign)NSInteger resultIndex;
@property(nonatomic,strong)UIButton * upBtn;
@property(nonatomic,strong)UIButton * downBtn;
@property(nonatomic,strong)UILabel * toastLabel;
@property(nonatomic,copy)NSString * searchT;
@end

@implementation BKDevConsoleVC

static NSBundle * consoleBundle = nil;
+(NSBundle *)getResourceBundle
{
    if (!consoleBundle) {
        NSBundle * mainBundle = [NSBundle bundleForClass:[self class]];
        NSString * resourcePath = [mainBundle pathForResource:@"BKConsoleResources" ofType:@"bundle"];
        consoleBundle = [NSBundle bundleWithPath:resourcePath] ?: mainBundle;
    }
    
    return consoleBundle;
}


-(UIImage *)imageWithName:(NSString *)imageName
{
    UIImage * image = [[UIImage alloc] initWithContentsOfFile:[[BKDevConsoleVC getResourceBundle] pathForResource:imageName ofType:@"png"]];
    return image;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"App Console Log";
    self.edgesForExtendedLayout= UIRectEdgeNone;
     
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    
    self.searchBar = [[BKDevConsoleSearchBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    self.searchBar.delegate = self;
    if (@available(iOS 13.0, *)) {
        self.searchBar.searchTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    self.navigationItem.titleView = self.searchBar;
    UIBarButtonItem * clearBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clearLog)];
    
    UIBarButtonItem * closeBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(closeThisPage)];
    self.navigationItem.rightBarButtonItems = @[closeBtn,clearBtn];

    self.textView = [[UITextView alloc] init];
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.textColor = [UIColor systemGreenColor];
    self.textView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    self.textView.editable = NO;
    self.textView.layoutManager.allowsNonContiguousLayout= NO;
    self.textView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:self.textView];
    
    self.upBtn = [[UIButton alloc] init];
    [self.upBtn setImage:[self imageWithName:@"s_up"] forState:UIControlStateNormal];
    [self.upBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.upBtn addTarget:self action:@selector(searchResultScanAction:) forControlEvents:UIControlEventTouchUpInside];
    self.upBtn.hidden = YES;
    [self.view addSubview:self.upBtn];
    
    self.downBtn = [[UIButton alloc] init];
    [self.downBtn setImage:[self imageWithName:@"s_down"] forState:UIControlStateNormal];
    [self.downBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.downBtn addTarget:self action:@selector(searchResultScanAction:) forControlEvents:UIControlEventTouchUpInside];
    self.downBtn.hidden = YES;
    [self.view addSubview:self.downBtn];
    
    self.toastLabel = [[UILabel alloc] init];
    self.toastLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    self.toastLabel.textColor = [UIColor whiteColor];
    self.toastLabel.textAlignment = NSTextAlignmentCenter;
    self.toastLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
    self.toastLabel.hidden = YES;
    [self.view addSubview:self.toastLabel];
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(@available(iOS 11.0, *)) {
        [[self.searchBar.heightAnchor constraintEqualToConstant:44.0] setActive:YES];
    }
    self.textView.text = [[BKConsoleManager shareManager] getLog];
    [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 1)];
    
    
}

-(void)closeThisPage
{
    if (self.hideBlock) {
        self.hideBlock();
    }
    
}

-(void)clearLog
{
    [[BKConsoleManager shareManager] clearLog];
    self.textView.text = nil;
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.textView.frame = CGRectMake(14, 14, self.view.bounds.size.width - 28, self.view.bounds.size.height - 28);
    
    self.upBtn.frame = CGRectMake(self.view.bounds.size.width - 70, 40, 60, 60);
    self.downBtn.frame = CGRectMake(self.view.bounds.size.width - 70, 100, 60, 60);
    self.toastLabel.frame = CGRectMake(0, 0, self.view.bounds.size.width, 30);
    
}

/// 每次编辑刷新搜索
-(void)refreshResultWithKeyText:(NSString *)text
{
    [self.ranges removeAllObjects];
    self.searchT = text;
    [self.textView.textStorage addAttribute:NSForegroundColorAttributeName value:[UIColor systemGreenColor] range:NSMakeRange(0, self.textView.text.length)];
    
    if (!text) {
        return;
    }
    if (text.length<1) {
        return;
    }
    NSScanner * scanner = [NSScanner scannerWithString:self.textView.text];
    [scanner setCaseSensitive:NO];
    BOOL found;
    NSMutableArray * temp = [NSMutableArray array];
    while (![scanner isAtEnd]) {
        found = [scanner scanString:text intoString:NULL];
        if (found) {
            NSRange keywordRange = NSMakeRange(scanner.scanLocation-text.length, text.length);
            [temp addObject:[NSValue valueWithRange:keywordRange]];
            [self.textView.textStorage addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:keywordRange];
        }else{
            scanner.scanLocation++;
        }
    }
    
    [self.ranges addObjectsFromArray:[temp reverseObjectEnumerator].allObjects];
    
    self.toastLabel.hidden = self.ranges.count>0?NO:YES;
    
    self.resultIndex = 0;
    
    
    
}

-(void)searchResultScanAction:(UIButton *)sender
{
    
    if (self.ranges.count<2) {
        return;
    }
    
    if (sender == self.upBtn) {
        // next
        if (self.resultIndex == self.ranges.count - 1) {
            self.resultIndex = 0;
        }else{
            self.resultIndex = self.resultIndex+1;
        }
        
    }else if (sender == self.downBtn){
        // last
        if (self.resultIndex == 0) {
            self.resultIndex = self.ranges.count - 1;
        }else{
            self.resultIndex = self.resultIndex - 1;
        }
    }
}

- (void)setResultIndex:(NSInteger)resultIndex
{
    _resultIndex = resultIndex;
    if (resultIndex < self.ranges.count) {
        NSRange range = [[self.ranges objectAtIndex:resultIndex] rangeValue];
        [self.textView scrollRangeToVisible:range];
    
        
        
        if (self.ranges.count>1) {
            self.upBtn.hidden = NO;
            self.downBtn.hidden = NO;
        }else{
            self.upBtn.hidden = YES;
            self.downBtn.hidden = YES;
        }
        
        
        self.toastLabel.text = [NSString stringWithFormat:@"搜索%@：第%ld/%ld条结果",self.searchT,(long)resultIndex+1,(long)self.ranges.count];
        
        
    }
    

}


#pragma mark - search bar deleagate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self refreshResultWithKeyText:searchBar.text];
    [searchBar resignFirstResponder];
}

#pragma mark - lazy
- (NSMutableArray *)ranges
{
    if (!_ranges) {
        _ranges = [NSMutableArray array];
    }
    return _ranges;
}

@end
