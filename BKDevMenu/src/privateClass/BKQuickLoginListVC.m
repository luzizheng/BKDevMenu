//
//  BKQuickLoginListVC.m
//  BKDevMenu
//
//  Created by luzz on 2021/11/10.
//

#import "BKQuickLoginListVC.h"
#import "BKDevQuickLoginUserModel.h"
#import "BKQuickLoginEditVC.h"


@interface BKQuickLoginListVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView * tableView;
@property(nonatomic,strong)UIButton * addBtn;
@property(nonatomic,strong)NSArray * listData;
@end

@implementation BKQuickLoginListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账号列表";
    self.listData = @[];
    
    
    
    
    
    self.addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,80)];
    [self.addBtn setAttributedTitle:[[NSAttributedString alloc] initWithString:@"添加+" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:18],NSForegroundColorAttributeName:[UIColor darkGrayColor]}] forState:UIControlStateNormal];
    [self.addBtn addTarget:self action:@selector(addUser:) forControlEvents:UIControlEventTouchUpInside];
    
    

    UITableView *tv = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tv.delegate = self;
    tv.dataSource = self;
    [self.view addSubview:tv];
    tv.tableFooterView = self.addBtn;
    self.tableView = tv;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadData];
}

-(void)loadData
{
    self.listData = [BKDevQuickLoginUserModel modelArray]?:[NSArray array];
    
    if (self.listData.count>0) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(clearAllUser)];
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    [self.tableView reloadData];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}


-(void)addUser:(id)sender
{
    BKQuickLoginEditVC * vc = [BKQuickLoginEditVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)clearAllUser
{
    if ([BKDevQuickLoginUserModel clearAll]) {
        [self loadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"qlCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"qlCell"];
        cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.detailTextLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    if (indexPath.row < self.listData.count) {
        BKDevQuickLoginUserModel * model = self.listData[indexPath.row];
        cell.textLabel.text = model.title;
        cell.detailTextLabel.text = model.userId;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.listData.count) {
        BKDevQuickLoginUserModel * model = self.listData[indexPath.row];
        BKQuickLoginEditVC * vc = [BKQuickLoginEditVC new];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    UITableViewRowAction * deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull ip) {
        
        if (ip.row < self.listData.count) {
            BKDevQuickLoginUserModel * model = self.listData[ip.row];
            if ([model del]) {
                [weakSelf loadData];
            }
        }
        
    }];
    return @[deleteRowAction];
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


@end
