//
//  BKDevQuickLoginUserModel.h
//  BKDevMenu
//
//  Created by luzz on 2021/11/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKDevQuickLoginUserModel : NSObject

@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * userId;
@property(nonatomic,copy)NSString * pwd;


+(NSArray <BKDevQuickLoginUserModel *>*)modelArray;
-(BOOL)save;
-(BOOL)del;
+(BOOL)clearAll;
@end

NS_ASSUME_NONNULL_END
