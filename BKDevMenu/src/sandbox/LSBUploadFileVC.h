//
//  LSBUploadFileVC.h
//  LZZSandboxViewer
//
//  Created by zizheng lu on 2021/10/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^LSBUploadFileBlock)(NSArray *fileArray);

@interface LSBUploadFileVC : UIViewController

- (instancetype)initWithPath:(NSString *)path maxCount:(NSInteger)maxCount uploadBlock:(LSBUploadFileBlock)uploadBlock;

@end

NS_ASSUME_NONNULL_END
