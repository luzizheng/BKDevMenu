//
//  LSBFileListCell.h
//  LZZSandboxViewer
//
//  Created by luzz on 2021/11/2.
//

#import "LSBBaseCell.h"

NS_ASSUME_NONNULL_BEGIN
@class LSBFileModel;
@interface LSBFileListCell : LSBBaseCell
@property(nonatomic,strong)LSBFileModel * model;
@end

NS_ASSUME_NONNULL_END
