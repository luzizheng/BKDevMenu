//
//  BKDevMenuItem.h
//  BKDevMenu
//
//  Created by luzz on 2021/11/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger,BKDevMenuItemStyle) {
    BKDevMenuItemStyleDefault = 0,
    BKDevMenuItemStyleQuickLogin,
    BKDevMenuItemStyleSegment,
    BKDevMenuItemStyleCancel,
    BKDevMenuItemStyleDestructive
};

@interface BKDevMenuItem : NSObject
@property(nonatomic,copy)NSString * identifier;
@property(nonatomic,assign)BKDevMenuItemStyle style;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)void(^action)(id obj);

@property(nonatomic,strong)NSArray <NSString *>* segments;
@property(nonatomic,copy)void(^segAction)(NSInteger index,id nav);
@property(nonatomic,copy)NSInteger(^defaultIndexBlock)(void);

+ (instancetype)itemWithTitle:(NSString *)title andStyle:(BKDevMenuItemStyle)style andAction:(void (^)(id obj))action;

+ (instancetype)itemSegmentWithTitle:(NSString *)title segments:(NSArray <NSString *>*)segments defaultIndex:(NSInteger(^)(void))defaultIndexHandler segAction:(void(^)(NSInteger index,id nav))segAction;


@end

NS_ASSUME_NONNULL_END
