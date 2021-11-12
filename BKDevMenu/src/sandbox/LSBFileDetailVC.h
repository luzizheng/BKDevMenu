//
//  LSBFileDetailVC.h
//  LZZSandboxViewer
//
//  Created by zizheng lu on 2021/10/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LSBFileModel;
@interface LSBFileDetailVC : UIViewController
- (instancetype)initWithFileModel:(LSBFileModel *)file;
@end

NS_ASSUME_NONNULL_END
