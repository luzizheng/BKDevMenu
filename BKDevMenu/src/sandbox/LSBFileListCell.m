//
//  LSBFileListCell.m
//  LZZSandboxViewer
//
//  Created by luzz on 2021/11/2.
//

#import "LSBFileListCell.h"
#import "LSBFileModel.h"
#import "LSBHelper.h"

@implementation LSBFileListCell



- (void)setModel:(LSBFileModel *)model
{
    _model = model;
    
    self.firstLineLabel.text = model.name;
    if (model.fileType == LSBFileTypeDirectory) {
        self.icon.image = [LSBHelper imageWithName:@"folder"];
        self.secondLineLabel.text = [NSString stringWithFormat:@"%@：%@ - %@ - %ld项",model.fileTypeName,model.creatTime,model.fileSize,(long)model.fileCount];
    }else{
        self.icon.image = [LSBHelper imageWithName:model.fileDes.iconName];
        self.secondLineLabel.text = [NSString stringWithFormat:@"%@：%@ - %@",model.fileDes.fileTypeName,model.creatTime,model.fileSize];
    }
}

@end
