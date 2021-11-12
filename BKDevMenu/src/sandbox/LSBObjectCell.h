//
//  LSBObjectCell.h
//  BKDevMenu
//
//  Created by luzz on 2021/11/5.
//

#import "LSBBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSBObjectCell : LSBBaseCell

@property(nonatomic,assign)NSInteger index;

@property(nonatomic,strong,nullable)id obj;
@end

NS_ASSUME_NONNULL_END
