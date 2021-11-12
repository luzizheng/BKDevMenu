//
//  LSBFileListVC.m
//  LZZSandboxViewer
//
//  Created by zizheng lu on 2021/10/28.
//

#import "LSBFileListVC.h"
#import "LSBFileManager.h"
#import "LSBFileModel.h"
#import "LSBFileDetailVC.h"
#import "LSBHelper.h"
#import "LSBFileListCell.h"
@interface LSBFileListVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) LSBFileManager * fileManager;
@property (nonatomic, weak) UITableView * tableView;
@property (nonatomic, copy) NSString * homePath;
@property (nonatomic, strong) NSMutableArray *files;
@property(nonatomic,strong)UILabel * noDataView;
@property(nonatomic,strong)UIButton * editBtn;
@end

@implementation LSBFileListVC

static NSString * const kCellId = @"LSBFileListVCCell";

- (instancetype)initWithPath:(NSString *)path
{
    if (self = [super init]) {
        self.homePath = path;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (![self.fileManager fileExistsAtPath:self.homePath]) {
        [self.fileManager createFolderToFullPath:self.homePath];
    }
    LSBFileModel *floder = [self.fileManager getFileWithPath:self.homePath];
    self.title = floder.name;
    
    [self initViews];
}

- (void)initViews
{
    self.editBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 25)];
    [self.editBtn setAttributedTitle:[[NSAttributedString alloc] initWithString:@"编辑" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:14],NSForegroundColorAttributeName:[UIColor systemRedColor]}] forState:UIControlStateNormal];
    [self.editBtn setAttributedTitle:[[NSAttributedString alloc] initWithString:@"完成" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:14],NSForegroundColorAttributeName:[UIColor systemBlueColor]}] forState:UIControlStateSelected];
    
    [self.editBtn addTarget:self action:@selector(editBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.editBtn];
    

    
    UITableView *tv = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [tv registerClass:[LSBFileListCell class] forCellReuseIdentifier:kCellId];
    tv.delegate = self;
    tv.dataSource = self;
    [self.view addSubview:tv];
    self.tableView = tv;
    
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self checkHasDataRefreshUI];
    
}

-(void)checkHasDataRefreshUI
{
    if (self.files.count == 0) {
        self.noDataView.frame = self.tableView.bounds;
        self.tableView.tableFooterView = self.noDataView;
    }else{
        self.tableView.tableFooterView = [UIView new];
    }
}

-(void)editBtnClickAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.tableView.editing = sender.selected;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.files.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSBFileListCell * cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    if (!cell) {
        [tableView registerClass:[LSBFileListCell class] forCellReuseIdentifier:kCellId];
    }
    cell.model = self.files[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSBFileModel *file = self.files[indexPath.row];
    if (file.fileType == LSBFileTypeDirectory) { // 文件夹
        LSBFileListVC *vc = [[LSBFileListVC alloc] initWithPath:file.filePath];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        LSBFileDetailVC *fileDetail = [[LSBFileDetailVC alloc] initWithFileModel:file];
        [self.navigationController pushViewController:fileDetail animated:YES];
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
        // 删除
        [LSBHelper showAlertWithTitle:@"注意" message:@"删除文件有可能会造成app崩溃，确认要删除吗" onVc:weakSelf leftBtnTitle:@"删除" leftAction:^(UIAlertAction * _Nonnull action) {
            //删除
            LSBFileModel *file = weakSelf.files[ip.row];
            BOOL success = [weakSelf.fileManager deleteFileWithPath:file.filePath];
            if (success) {
                [weakSelf reloadFileList];
                [weakSelf checkHasDataRefreshUI];
            }else{
                [LSBHelper showAlertWithTitle:@"错误" message:@"删除文件出错" onVc:weakSelf btnTitle:@"确定" leftAction:nil];
            }
        } rightBtnTitle:@"取消" rightAction:nil];
        
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

-(void)reloadFileList
{
    _files = nil;
    [self.tableView reloadData];
}
#pragma mark - lazy
- (LSBFileManager *)fileManager
{
    if (!_fileManager) {
        _fileManager = [LSBFileManager shareManager];
    }
    return _fileManager;
}

- (NSMutableArray *)files
{
    if (!_files) {
        _files = [NSMutableArray arrayWithArray:[self.fileManager getAllFileWithPath:self.homePath]];
    }
    return _files;
}
- (UILabel *)noDataView
{
    if (!_noDataView) {
        _noDataView = [[UILabel alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _noDataView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _noDataView.textColor = [UIColor lightGrayColor];
        _noDataView.textAlignment = NSTextAlignmentCenter;
        _noDataView.text = @"暂无文件";
    }
    return _noDataView;
}



@end
