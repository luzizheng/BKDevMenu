//
//  BKDevMenuItem.m
//  BKDevMenu
//
//  Created by luzz on 2021/11/3.
//

#import "BKDevMenuItem.h"

@implementation BKDevMenuItem
+ (instancetype)itemWithTitle:(NSString *)title andStyle:(BKDevMenuItemStyle)style andAction:(nonnull void (^)(id _Nonnull))action
{
    BKDevMenuItem *i = [self new];
    i.title = title;
    i.style = style;
    i.action = action;
    return i;
}

+ (instancetype)itemSegmentWithTitle:(NSString *)title segments:(NSArray<NSString *> *)segments defaultIndex:(NSInteger (^)(void))defaultIndexHandler segAction:(void (^)(NSInteger, id _Nonnull))segAction
{
    BKDevMenuItem *i = [self new];
    i.title = title;
    i.style = BKDevMenuItemStyleSegment;
    i.defaultIndexBlock = defaultIndexHandler;
    i.segments = segments;
    i.segAction = segAction;
    return i;
}


- (NSString *)identifier
{
    if (!_identifier) {
        _identifier = @"";
    }
    return _identifier;
}
@end
