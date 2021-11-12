//
//  LZZSandboxViewerVC.m
//  LZZSandboxViewer
//
//  Created by luzz on 2021/11/2.
//

#import "LZZSandboxViewerVC.h"
#import "LSBFileListVC.h"
#import "LSBFileListCell.h"
#import "LSBFileModel.h"
#import "LSBHelper.h"
#import "LSBCocoaClsBrowserVC.h"
#import <objc/runtime.h>
@interface LZZSandboxViewerVC ()
@property(nonatomic,strong)NSArray <LSBFileModel *>* list;
@end

@implementation LZZSandboxViewerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"沙盒";
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[LSBFileListCell class] forCellReuseIdentifier:NSStringFromClass([LSBFileListCell class])];
    [self.tableView registerClass:[LSBBaseCell class] forCellReuseIdentifier:NSStringFromClass([LSBBaseCell class])];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.list.count + 1 + self.additionalUserDefaults.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < self.list.count) {
        LSBFileListCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LSBFileListCell class])];
        cell.model = self.list[indexPath.row];
        return cell;
    }else{
        LSBBaseCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LSBBaseCell class])];
        cell.icon.image = [LSBHelper imageWithName:@"cocoa_icon_dic"];
        NSDictionary * dict = nil;
        if (indexPath.row == self.list.count) {
            
            cell.firstLineLabel.text = @"NSUserDefaults(Standare)";
            dict = [NSUserDefaults standardUserDefaults].dictionaryRepresentation;
            
        }else{
            // additional userdefaults
            NSUserDefaults * df = self.additionalUserDefaults[indexPath.row - self.list.count - 1];
            for (NSString * domainName in df.volatileDomainNames) {
                id value = [df volatileDomainForName:domainName];
                NSLog(@"%@",value);
            }
            cell.firstLineLabel.text = [NSString stringWithFormat:@"NSUserDefaults(additional %ld)",(long)(indexPath.row - self.list.count)];
            
            dict = df.dictionaryRepresentation;
        }
        cell.secondLineLabel.text = [NSString stringWithFormat:@"%ld keys/values",(long)dict.allKeys.count];
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.list.count) {
        LSBFileModel * model = self.list[indexPath.row];
        LSBFileListVC * vc = [[LSBFileListVC alloc] initWithPath:model.filePath];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSDictionary * dict = nil;
        if (indexPath.row == self.list.count) {
            dict = [NSUserDefaults standardUserDefaults].dictionaryRepresentation;
        }else{
            NSUserDefaults * df = self.additionalUserDefaults[indexPath.row - self.list.count - 1];
            dict = df.dictionaryRepresentation;
        }
        
        LSBCocoaClsBrowserVC * vc = [[LSBCocoaClsBrowserVC alloc] initWithObj:dict];
        vc.keyNameIfNeed = @"NSUserDefaults";
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(id)getPrivateProperty:(id)obj propertyName:(NSString *)propertyName
{
    Ivar iVar = class_getInstanceVariable([obj class], [@"address" UTF8String]);
    if (iVar == nil) {
        iVar = class_getInstanceVariable([obj class], [[NSString stringWithFormat:@"_%@",@"address"] UTF8String]);
    }
    id propertyVal = object_getIvar(obj, iVar);
    return propertyVal;
}

#pragma mark - lazy

- (NSArray<LSBFileModel *> *)list
{
    if (!_list) {
        NSString * documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)[0];
        NSString * libPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES)[0];
        NSString * cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)[0];
        NSString * tmpPath = NSTemporaryDirectory();
        
        LSBFileModel * document = [[LSBFileModel alloc] initWithFilePath:documentPath];
        LSBFileModel * lib = [[LSBFileModel alloc] initWithFilePath:libPath];
        LSBFileModel * caches = [[LSBFileModel alloc] initWithFilePath:cachesPath];
        LSBFileModel * tmp = [[LSBFileModel alloc] initWithFilePath:tmpPath];
        
        _list = @[document,lib,caches,tmp];
    }
    return _list;
}
- (NSArray<NSUserDefaults *> *)additionalUserDefaults
{
    if (!_additionalUserDefaults) {
        _additionalUserDefaults = [NSArray array];
    }
    return _additionalUserDefaults;
}
@end
