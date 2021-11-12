//
//  BKDevQuickLoginUserModel.m
//  BKDevMenu
//
//  Created by luzz on 2021/11/10.
//

#import "BKDevQuickLoginUserModel.h"


@implementation BKDevQuickLoginUserModel

-(id)initWithCoder:(NSCoder *)aDecoder{

    if (self = [super init]) {
        _title = [[aDecoder decodeObjectForKey:@"title"] copy];
        _userId = [[aDecoder decodeObjectForKey:@"userId"] copy];
        _pwd = [[aDecoder decodeObjectForKey:@"pwd"] copy];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_userId forKey:@"userId"];
    [aCoder encodeObject:_pwd forKey:@"pwd"];
}


+(NSString *)filePath
{
    //归档文件的路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"6ddj&dj$jdk.archiver"];
    return filePath;
}

+(NSArray <BKDevQuickLoginUserModel *>*)modelArray
{
    NSData *contentData = [NSData dataWithContentsOfFile:[self filePath]];
    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:contentData];
    NSArray * list = [unArchiver decodeObjectForKey:@"list"];
    return list;
}
+(BOOL)clearAll
{
    NSError * error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:[self filePath] error:&error];
    return error?NO:YES;
}

-(BOOL)save
{
    if (!(self.userId.length > 0)) {
        return NO;
    }
    if (!(self.pwd.length > 0)) {
        return NO;
    }
    if (!(self.title.length > 0)) {
        self.title = @"untitle";
    }
    NSMutableArray * arr = [BKDevQuickLoginUserModel modelArray].mutableCopy;
    if (!arr) {
        arr = @[].mutableCopy;
    }
    BOOL contain = NO;
    for (BKDevQuickLoginUserModel * model in arr) {
        if ([model.userId isEqualToString:self.userId]) {
            
            model.title = self.title;
            model.pwd = self.pwd;
            contain = YES;
            break;
        }
    }
    
    if (contain == NO) {
        [arr addObject:self];
    }
    
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:arr forKey:@"list"];
    
    [archiver finishEncoding];
    
    return [data writeToFile:[BKDevQuickLoginUserModel filePath] atomically:YES];
    
}
-(BOOL)del
{
    if (!(self.userId.length > 0)) {
        return NO;
    }
    if (!(self.pwd.length > 0)) {
        return NO;
    }
    if (!(self.title.length > 0)) {
        self.title = @"untitle";
    }
    NSMutableArray * arr = [BKDevQuickLoginUserModel modelArray].mutableCopy;
    if (!arr) {
        arr = @[].mutableCopy;
    }
    NSInteger targetIndex = -1;
    for (int i = 0;i<arr.count;i++) {
        BKDevQuickLoginUserModel * model = arr[i];
        if ([model.userId isEqualToString:self.userId]) {
            targetIndex = i;
            break;
        }
    }
    if (targetIndex >= 0) {
        [arr removeObjectAtIndex:targetIndex];
        NSMutableData *data = [NSMutableData data];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        
        [archiver encodeObject:arr forKey:@"list"];
        
        [archiver finishEncoding];
        
        return [data writeToFile:[BKDevQuickLoginUserModel filePath] atomically:YES];
    }else{
        return YES;
    }
    
}
@end
