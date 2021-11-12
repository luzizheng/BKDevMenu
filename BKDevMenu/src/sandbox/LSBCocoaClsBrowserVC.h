//
//  LSBCocoaClsBrowserVC.h
//  BKDevMenu
//
//  Created by luzz on 2021/11/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSBCocoaClsBrowserVC : UIViewController

@property(nonatomic,copy,nullable)NSString * keyNameIfNeed;
@property(nonatomic,strong)id obj;

-(instancetype)initWithObj:(id)obj;


@end

NS_ASSUME_NONNULL_END
