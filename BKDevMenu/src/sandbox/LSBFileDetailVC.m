//
//  LSBFileDetailVC.m
//  LZZSandboxViewer
//
//  Created by zizheng lu on 2021/10/28.
//

#import "LSBFileDetailVC.h"
#import "LSBFileModel.h"
#import <QuickLook/QuickLook.h>
#import <WebKit/WebKit.h>
@interface LSBFileDetailVC ()<UIDocumentInteractionControllerDelegate>
@property (nonatomic, strong) LSBFileModel * file;
@property (nonatomic, strong) UIDocumentInteractionController * documentInteraction;
@property (nonatomic, strong)UITextView * textView;
@property (nonatomic, strong)WKWebView * webView;
@property (nonatomic, strong)UIButton * openInOtherAppBtn;
@end

@implementation LSBFileDetailVC

- (instancetype)initWithFileModel:(LSBFileModel *)file
{
    if (self = [super init]) {
        self.file = file;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"文件详情";
    [self setupUI];
    [self loadFile];
}

-(void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
 
    // text view
    self.textView = [[UITextView alloc] initWithFrame:CGRectZero];
    self.textView.editable = NO;
    self.textView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    self.textView.textColor = [UIColor darkTextColor];
    self.textView.hidden = YES;
    [self.view addSubview:self.textView];
    
    // web
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero];
    self.webView.hidden = YES;
    [self.view addSubview:self.webView];
    
    // can't open btn
    self.openInOtherAppBtn = [[UIButton alloc] init];
    [self.openInOtherAppBtn setAttributedTitle:[[NSAttributedString alloc] initWithString:@"无法读取，使用其他app打开" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:14],NSForegroundColorAttributeName:[UIColor redColor]}] forState:UIControlStateNormal];
    [self.openInOtherAppBtn addTarget:self action:@selector(openInOtherApp) forControlEvents:UIControlEventTouchUpInside];
    self.openInOtherAppBtn.hidden = YES;
    [self.view addSubview:self.openInOtherAppBtn];
}


-(void)loadFile
{
    NSString *urlStr = self.file.filePath;
    NSURL *url = [NSURL fileURLWithPath:urlStr];
    
    UIDocumentInteractionController *documentC = [UIDocumentInteractionController interactionControllerWithURL:url];
    documentC.delegate = self;
    
    BOOL canOpen = [documentC presentPreviewAnimated:YES];
    
    if (canOpen == NO) {
        
        NSError * error = nil;
        if ([urlStr hasSuffix:@".html"] || [urlStr hasSuffix:@".htm"]) {
            
            self.textView.hidden = YES;
            self.openInOtherAppBtn.hidden = YES;
            NSString* content = [NSString stringWithContentsOfFile:urlStr encoding:NSUTF8StringEncoding error:&error];
            if (error) {
                self.webView.hidden = YES;
                self.openInOtherAppBtn.hidden = NO;
            }else{
                self.webView.hidden = NO;
                [self.webView loadHTMLString:content baseURL:nil];
            }
            
            
        }else{
            self.webView.hidden = YES;
            
            NSError * error = nil;
            NSString* content = [NSString stringWithContentsOfFile:urlStr encoding:NSUTF8StringEncoding error:&error];
            if (error) {
                self.textView.hidden = YES;
                self.openInOtherAppBtn.hidden = NO;
            }else{
                self.textView.hidden = NO;
                self.textView.text = content;
            }
        }
        
        
        
    }else{
        self.textView.hidden = YES;
        self.webView.hidden = YES;
        self.openInOtherAppBtn.hidden = YES;
    }
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.webView.frame = self.view.bounds;
    self.textView.frame = CGRectMake(14, 14, self.view.bounds.size.width - 28, self.view.bounds.size.height - 28);
    self.openInOtherAppBtn.frame = CGRectMake(0, self.view.bounds.size.height/2 - 50, self.view.bounds.size.width, 100);
}



- (void)openInOtherApp
{
    NSString *urlStr = self.file.filePath;
    NSURL *url = [NSURL fileURLWithPath:urlStr];
    //创建实例
    UIDocumentInteractionController *documentController = [UIDocumentInteractionController interactionControllerWithURL:url];
    
    //设置代理
    documentController.delegate = self;
    BOOL canOpen = [documentController presentOpenInMenuFromRect:CGRectZero
                                                          inView:self.view
                                                        animated:YES];
    if (!canOpen) {
    
    }
}

#pragma mark - UIDocumentInteractionController 代理方法
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
{
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller
{
    return self.view.bounds;
}

- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
