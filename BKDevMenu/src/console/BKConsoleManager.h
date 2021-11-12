//
//  BKConsoleManager.h
//  DSLinPedia-OC
//
//  Created by luzz on 2021/10/29.
//  Copyright © 2021 DaShenLin Pharmaceutical Group. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKConsoleManager : NSObject
+(BKConsoleManager*)shareManager;



@property(nonatomic,strong,nullable)UIWindow * window;


/// set YES in methor didFinishLaunchingWithOptions for installation
@property(nonatomic,assign)BOOL enable;


-(NSString *)getLog;

/// set inner log string nil
-(void)clearLog;




@end

NS_ASSUME_NONNULL_END
