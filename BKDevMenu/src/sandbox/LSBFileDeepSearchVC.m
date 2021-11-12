//
//  LSBFileDeepSearchVC.m
//  LZZSandboxViewer
//
//  Created by zizheng lu on 2021/10/28.
//

#import "LSBFileDeepSearchVC.h"
#import "LSBFileManager.h"
#import "LSBFileModel.h"
#import "LSBFileDetailVC.h"
#import "LSBHelper.h"
@interface LSBFileDeepSearchVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) LSBFileManager * fileManager;
@property (nonatomic, weak) UITableView * tableView;
@property (nonatomic, copy) NSString * homePath;
@property (nonatomic, strong) NSMutableArray *files;
@end

@implementation LSBFileDeepSearchVC

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
    
    [self initViews];
}

- (void)initViews
{
    UITableView *tv = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tv.delegate = self;
    tv.dataSource = self;
    [self.view addSubview:tv];
    self.tableView = tv;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.files.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    LSBFileModel *file = self.files[indexPath.row];
    cell.textLabel.text = file.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UIImage *cellImage;
    if (file.fileType == LSBFileTypeDirectory) { // 文件夹
        cell.detailTextLabel.text = [NSString stringWithFormat:@"文件夹： %@ %@", file.creatTime, file.fileSize];
        cellImage = [LSBHelper imageWithName:@"file_floder"];
    } else {
        
        switch (file.fileType) {
            case LSBFileTypeImage:
            {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"图片： %@ %@", file.creatTime, file.fileSize];
                cellImage = [UIImage imageWithContentsOfFile:file.filePath];
            }
                break;
            case LSBFileTypeTxt:
            {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"文档： %@ %@", file.creatTime, file.fileSize];
                cellImage = [LSBHelper imageWithName:@"file_txt"];
            }
                break;
            case LSBFileTypeVoice:
            {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"音乐： %@ %@", file.creatTime, file.fileSize];
                cellImage = [LSBHelper imageWithName:@"file_mp3"];
            }
                break;
            case LSBFileTypeAudioVidio:
            {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"视频： %@ %@", file.creatTime, file.fileSize];
                cellImage = [LSBHelper imageWithName:@"file_avi"];
            }
                break;
            case LSBFileTypeApplication:
            {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"应用： %@ %@", file.creatTime, file.fileSize];
                cellImage = [LSBHelper imageWithName:@"file_ipa"];
            }
                break;
            case LSBFileTypeUnknown:
            {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"未知文件： %@ %@", file.creatTime, file.fileSize];
                cellImage = [LSBHelper imageWithName:@"file_webView_error"];
            }
                break;
            case LSBFileTypeWord:
            {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"word： %@ %@", file.creatTime, file.fileSize];
                cellImage = [LSBHelper imageWithName:@"file_word"];
            }
                break;
            case LSBFileTypePDF:
            {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"pdf： %@ %@", file.creatTime, file.fileSize];
                cellImage = [LSBHelper imageWithName:@"file_pdf"];
            }
                break;
            case LSBFileTypePPT:
            {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"ppt： %@ %@", file.creatTime, file.fileSize];
                cellImage = [LSBHelper imageWithName:@"file_ppt"];
            }
                break;
            case LSBFileTypeXLS:
            {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"xls： %@ %@", file.creatTime, file.fileSize];
                cellImage = [LSBHelper imageWithName:@"file_excel"];
            }
                break;
            default:
                break;
        }
        
    }
    
    // 设置cell图片大小
    CGSize imageSize = CGSizeMake(40, 40);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    CGRect imageRect = CGRectMake(0.0, 0.0, imageSize.width, imageSize.height);
    [cellImage drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSBFileModel *file = self.files[indexPath.row];

    LSBFileDetailVC *fileDetail = [[LSBFileDetailVC alloc] initWithFileModel:file];
    [self.navigationController pushViewController:fileDetail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
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
        _files = [NSMutableArray arrayWithArray:[self.fileManager getAllFileInPathWithDeepSearch:self.homePath]];
    }
    return _files;
}


@end
