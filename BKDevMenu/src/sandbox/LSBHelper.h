//
//  LSBHelper.h
//  LZZSandboxViewer
//
//  Created by zizheng lu on 2021/10/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,LSBObjectClass) {
    LSBObjectClassNil,
    LSBObjectClassNull,
    LSBObjectClassString,
    LSBObjectClassNumber,
    LSBObjectClassBoolean,
    LSBObjectClassArray,
    LSBObjectClassDictionary,
    LSBObjectClassData,
    LSBObjectClassDate,
    LSBObjectClassImage,
    LSBObjectClassOther
};


@interface LSBObjectInfo : NSObject

+(instancetype)infoWithValue:(id)value;
@property(nonatomic,copy)NSString * className;
@property(nonatomic,assign)LSBObjectClass objClass;
@property(nonatomic,copy,nullable)NSString * valueDetail;
@property(nonatomic,copy)NSString * iconName;

-(id)tryToParseDataOrImage;
@end


@interface LSBHelper : NSObject



+(CGFloat)adapt:(CGFloat)fValue;

/// 弹窗 一个选择
+(void)showAlertWithTitle:(NSString * _Nullable)title message:(NSString * _Nullable)message onVc:(UIViewController *)onVc btnTitle:(NSString * _Nullable)btnTitle leftAction:(void (^__nullable)(UIAlertAction * _Nonnull))action;

///  弹窗 两个选择
+(void)showAlertWithTitle:(NSString * _Nullable)title message:(NSString * _Nullable)message onVc:(UIViewController *)onVc leftBtnTitle:(NSString *_Nullable)leftBtnTitle leftAction:(void (^ __nullable)(UIAlertAction *action))leftAction rightBtnTitle:(NSString * _Nullable)rightBtnTitle rightAction:(void (^ __nullable)(UIAlertAction *action))rightAction;



+(NSBundle *)getResourceBundle;
+(UIImage *)imageWithName:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
