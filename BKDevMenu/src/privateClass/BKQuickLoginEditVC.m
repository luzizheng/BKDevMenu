//
//  BKQuickLoginEditVC.m
//  BKDevMenu
//
//  Created by luzz on 2021/11/10.
//

#import "BKQuickLoginEditVC.h"
#import "BKDevQuickLoginUserModel.h"
@interface BKQuickLoginEditVC ()

@property(nonatomic,strong)UITextField * titleTf;
@property(nonatomic,strong)UITextField * userTf;
@property(nonatomic,strong)UITextField * pwdTf;

@end

@implementation BKQuickLoginEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.model?@"编辑":@"添加账号";
    [self setupUI];
}

-(void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    UIFont * font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    UIColor * textColor = [UIColor darkGrayColor];
    
    CGFloat mainWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat left = 15;
    
    UILabel * labelA = [[UILabel alloc] init];
    labelA.font = font;
    labelA.textColor = textColor;
    labelA.text = @"标题";
    [self.view addSubview:labelA];
    
    
    UILabel * labelB = [[UILabel alloc] init];
    labelB.font = font;
    labelB.textColor = textColor;
    labelB.text = @"账号/手机";
    [self.view addSubview:labelB];
    
    UILabel * labelC = [[UILabel alloc] init];
    labelC.font = font;
    labelC.textColor = textColor;
    labelC.text = @"密码";
    [self.view addSubview:labelC];
    
    
    [labelA sizeToFit];
    [labelB sizeToFit];
    [labelC sizeToFit];
    
    labelA.frame = CGRectMake(left, 80, labelA.frame.size.width, labelA.frame.size.height);
    labelB.frame = CGRectMake(left, labelA.frame.origin.y + labelA.frame.size.height + 30, labelB.frame.size.width, labelB.frame.size.height);
    labelC.frame = CGRectMake(left, labelB.frame.origin.y + labelB.frame.size.height + 30, labelC.frame.size.width, labelC.frame.size.height);
    
    
    CGFloat tf_left = labelB.frame.origin.x + labelB.frame.size.width + 20;
    CGFloat tf_w = mainWidth - tf_left - 15;
    CGFloat tf_h = 60;
    
    self.titleTf = [[UITextField alloc] init];
    self.titleTf.font= font;
    self.titleTf.textColor = textColor;
    self.titleTf.placeholder = @"请输入标题";
    [self.view addSubview:self.titleTf];
    
    self.userTf = [[UITextField alloc] init];
    self.userTf.font= font;
    self.userTf.textColor = textColor;
    self.userTf.autocorrectionType = UITextAutocorrectionTypeNo;
    self.userTf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.userTf.spellCheckingType = UITextSpellCheckingTypeNo;
    self.userTf.placeholder = @"请输入用户名/手机号";
    [self.view addSubview:self.userTf];
    
    self.pwdTf = [[UITextField alloc] init];
    self.pwdTf.font= font;
    self.pwdTf.textColor = textColor;
    self.pwdTf.autocorrectionType = UITextAutocorrectionTypeNo;
    self.pwdTf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.pwdTf.spellCheckingType = UITextSpellCheckingTypeNo;
    self.pwdTf.placeholder = @"请输入密码/验证码";
    [self.view addSubview:self.pwdTf];
    
    
    
    
    self.titleTf.frame = CGRectMake(tf_left, labelA.center.y - tf_h/2, tf_w, tf_h);
    self.userTf.frame = CGRectMake(tf_left, labelB.center.y - tf_h/2, tf_w, tf_h);
    self.pwdTf.frame = CGRectMake(tf_left, labelC.center.y - tf_h/2, tf_w, tf_h);
    
    UIButton * saveBtn = [[UIButton alloc] init];
    saveBtn.backgroundColor = [UIColor darkGrayColor];
    [saveBtn setAttributedTitle:[[NSAttributedString alloc] initWithString:@"加密保存" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor whiteColor]}] forState:UIControlStateNormal];
    saveBtn.frame = CGRectMake(20, self.pwdTf.frame.origin.y + self.pwdTf.frame.size.height + 25, mainWidth - 40, 45);
    [saveBtn addTarget:self action:@selector(summit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
        
    
    if (self.model) {
        BKDevQuickLoginUserModel * m = self.model;
        self.titleTf.text = m.title;
        self.userTf.text = m.title;
        self.pwdTf.text = m.pwd;
    }
    
}

-(void)summit:(id)sender
{
    [self.view endEditing:YES];
    
    if (self.userTf.text.length > 0 && self.pwdTf.text.length>0) {
        BKDevQuickLoginUserModel * model = [BKDevQuickLoginUserModel new];
        model.title = self.titleTf.text;
        model.userId = self.userTf.text;
        model.pwd = self.pwdTf.text;
        if ([model save]) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
        
    }else{
        UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"添加失败" message:@"请输入账号或密码" preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:ac animated:YES completion:nil];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
