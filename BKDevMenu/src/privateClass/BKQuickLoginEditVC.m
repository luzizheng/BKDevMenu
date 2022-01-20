//
//  BKQuickLoginEditVC.m
//  BKDevMenu
//
//  Created by luzz on 2021/11/10.
//

#import "BKQuickLoginEditVC.h"
#import "BKDevQuickLoginUserModel.h"

@interface InfoTableView : UITableView

@end

@implementation InfoTableView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    id view = [super hitTest:point withEvent:event];
    if (![view isKindOfClass:[UITextView class]]) {
        [self.superview endEditing:YES];
        [self endEditing:YES];
    }
    return view;
}

@end

@interface InfoCell : UITableViewCell

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UITextField * textField;
@end

@implementation InfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIFont * font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        UIColor * textColor = [UIColor darkGrayColor];
        
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = font;
        self.titleLabel.textColor = textColor;
        self.titleLabel.text = @"标题";
        [self.contentView addSubview:self.titleLabel];
        
        
        self.textField = [[UITextField alloc] init];
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.textField.font= font;
        self.textField.textColor = textColor;
        self.textField.placeholder = @"请输入标题";
        [self.contentView addSubview:self.textField];
        
        
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(20, 0, 110, self.contentView.bounds.size.height);
    self.textField.frame = CGRectMake(130, 0, self.contentView.bounds.size.width - 100, self.contentView.bounds.size.height);
}

@end



@interface BKQuickLoginEditVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) InfoCell *cell1;
@property (nonatomic, strong) InfoCell *cell2;
@property (nonatomic, strong) InfoCell *cell3;
@property (nonatomic, strong) InfoTableView *tableView;
@property (nonatomic, strong) UIView *footer;

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
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footer];
        
    
    if (self.model) {
        BKDevQuickLoginUserModel * m = self.model;
        self.cell1.textField.text = m.title;
        self.cell2.textField.text = m.userId;
        self.cell3.textField.text = m.pwd;
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGFloat top = 0;
    CGFloat bottom = 0;
    if (@available(iOS 11, *)){
        top = self.view.safeAreaInsets.top;
        bottom = self.view.safeAreaInsets.bottom;
    }
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    CGFloat foot_h = 80;
    
    self.footer.frame = CGRectMake(0, height - bottom - foot_h, width, foot_h);
    __kindof UIView * btn = [self.footer viewWithTag:123];
    btn.frame = CGRectMake(15, 15, self.footer.frame.size.width - 30, self.footer.frame.size.height - 30);
    
    self.tableView.frame = CGRectMake(0, top, width, height - bottom - foot_h - top);
}

-(void)summit:(id)sender
{
    [self.view endEditing:YES];
    
    if (self.cell2.textField.text.length > 0 && self.cell3.textField.text.length>0) {
        BKDevQuickLoginUserModel * model = [BKDevQuickLoginUserModel new];
        model.title = self.cell1.textField.text;
        model.userId = self.cell2.textField.text;
        model.pwd = self.cell3.textField.text;
        if ([model save]) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
        
    }else{
        UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"添加失败" message:@"请输入账号或密码" preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:ac animated:YES completion:nil];
    }
    
}


#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        return self.cell1;
    }else if (indexPath.row == 1){
        return self.cell2;
    }else if (indexPath.row == 2){
        return self.cell3;
    }else{
        return [UITableViewCell new];
    }
}

#pragma mark - lazy

- (InfoCell *)cell1
{
    if (!_cell1) {
        _cell1 = [[InfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        _cell1.titleLabel.text = @"标题";
        _cell1.textField.placeholder = @"请输入标题";
    }
    return _cell1;
}
- (InfoCell *)cell2
{
    if (!_cell2) {
        _cell2 = [[InfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        _cell2.titleLabel.text = @"账号/手机";
        _cell2.textField.placeholder = @"请输入用户名/手机号";
    }
    return _cell2;
}
- (InfoCell *)cell3
{
    if (!_cell3) {
        _cell3 = [[InfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
        _cell3.titleLabel.text = @"密码";
        _cell3.textField.placeholder = @"请输入密码/验证码";
    }
    return _cell3;
}


- (InfoTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[InfoTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.allowsSelection = NO;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (UIView *)footer
{
    if (!_footer) {
        _footer = [UIView new];
        UIButton * saveBtn = [[UIButton alloc] init];
        saveBtn.backgroundColor = [UIColor darkGrayColor];
        [saveBtn setAttributedTitle:[[NSAttributedString alloc] initWithString:@"加密保存" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:16],NSForegroundColorAttributeName:[UIColor whiteColor]}] forState:UIControlStateNormal];
        [saveBtn addTarget:self action:@selector(summit:) forControlEvents:UIControlEventTouchUpInside];
        [_footer addSubview:saveBtn];
        saveBtn.tag = 123;
    }
    return _footer;
}



@end
