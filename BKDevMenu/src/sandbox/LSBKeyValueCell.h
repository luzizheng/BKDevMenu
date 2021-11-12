//
//  LSBKeyValueCell.h
//  BKDevMenu
//
//  Created by luzz on 2021/11/5.
//

#import "LSBBaseCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface LSBKeyValueStruct : NSObject
@property(nonatomic,copy)NSString * key;
@property(nonatomic,strong)id value;
@end



@interface LSBKeyValueCell : LSBBaseCell

@property(nonatomic,strong)LSBKeyValueStruct * model;

@end

NS_ASSUME_NONNULL_END
