//
//  LSBHelper.m
//  LZZSandboxViewer
//
//  Created by zizheng lu on 2021/10/28.
//

#import "LSBHelper.h"
#import "LSBFileManager.h"

@interface LSBObjectInfo()

@property(nonatomic,strong)id value;

@end

@implementation LSBObjectInfo

+(instancetype)infoWithValue:(id)value
{
    LSBObjectInfo * info = [LSBObjectInfo new];
    info.value = value;
    info.valueDetail = @"";
    if (value) {
        if ([value isKindOfClass:[NSNull class]]) {
            info.className = @"null";
            info.objClass = LSBObjectClassNull;
        }else{
            info.className = NSStringFromClass([value class]);
            
            if ([value isKindOfClass:[NSString class]]) {
                info.className = @"NSString";
                info.valueDetail = value;
                info.objClass = LSBObjectClassString;
            }else if ([value isKindOfClass:[NSNumber class]]){
                if ([NSStringFromClass([value class]) isEqualToString:@"__NSCFBoolean"]) {
                    info.className = @"Boolean";
                    info.valueDetail = [value boolValue]?@"True":@"False";
                    info.objClass = LSBObjectClassBoolean;
                }else{
                    info.className = @"NSNumber";
                    info.valueDetail = [NSString stringWithFormat:@"%@",value];
                    info.objClass = LSBObjectClassNumber;
                }
                
            }else if ([value isKindOfClass:[NSArray class]]){
                info.className = @"NSArray";
                info.valueDetail = [NSString stringWithFormat:@"%ld items",((NSArray *)value).count];
                info.objClass = LSBObjectClassArray;
            }else if ([value isKindOfClass:[NSDictionary class]]){
                info.className = @"NSDictionary";
                info.valueDetail =[NSString stringWithFormat:@"%ld keys/values",((NSDictionary *)value).allKeys.count];
                info.objClass = LSBObjectClassDictionary;
            }else if([value isKindOfClass:[NSData class]]){
                info.className = @"NSData";
                NSData * data = value;
                double bytes = (double)data.length;
                NSString * kbStr = nil;
                if (bytes > 1000.0) {
                    if (bytes > 1000.0 * 1024.0) {
                        kbStr = [NSString stringWithFormat:@"%ld m",(long)(bytes/(1000.0 * 1024.0))];
                    }else{
                        kbStr = [NSString stringWithFormat:@"%ld kb",(long)(bytes/1000.0)];
                    }
                }else{
                    kbStr = [NSString stringWithFormat:@"%ld bytes",(long)bytes];
                }
                info.valueDetail = kbStr;
                info.objClass = LSBObjectClassData;
            }else if ([value isKindOfClass:[UIImage class]]){
                info.className = @"UIImage";
                NSData * imgData = UIImagePNGRepresentation(value);
                info.valueDetail = [NSString stringWithFormat:@"%ld bytes",imgData.length];
                info.objClass = LSBObjectClassImage;
            }else{
                
                if ([NSStringFromClass([value class]) isEqualToString:@"__NSTaggedDate"]) {
                    NSDateFormatter * fm = [[NSDateFormatter alloc] init];
                    [fm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    info.className = @"NSDate";
                    info.valueDetail = [fm stringFromDate:value];
                    info.objClass = LSBObjectClassDate;
                }else{
                    info.valueDetail = @"Cocoa Class";
                    info.objClass = LSBObjectClassOther;
                }
                

            }
        }
    }else{
        info.className = @"nil";
        info.objClass = LSBObjectClassNil;
    }

    
    return info;
}




- (NSString *)iconName
{
    switch (self.objClass) {
        case LSBObjectClassNil:
            return @"cocoa_icon_nil";
            break;
        case LSBObjectClassNull:
            return @"cocoa_icon_nil";
            break;
        case LSBObjectClassString:
            return @"cocoa_icon_str";
            break;
        case LSBObjectClassNumber:
            return @"cocoa_icon_num";
            break;
        case LSBObjectClassBoolean:
            return @"cocoa_icon_bool";
            break;
        case LSBObjectClassArray:
            return @"cocoa_icon_arr";
            break;
        case LSBObjectClassDictionary:
            return @"cocoa_icon_dic";
            break;
        case LSBObjectClassOther:
            return @"cocoa_icon_obj";
            break;
        case LSBObjectClassData:
            return @"cocoa_icon_data";
            break;
        case LSBObjectClassDate:
            return @"cocoa_icon_date";
            break;
        case LSBObjectClassImage:
            return @"cocoa_icon_img";
            break;
        default:
            break;
    }
}
-(id)tryToParseDataOrImage
{
    if (self.objClass == LSBObjectClassData) {
        UIImage * img = [UIImage imageWithData:self.value];
        if (img) {
            return img;
        }else{
            NSString * string = [[NSString alloc] initWithData:self.value encoding:NSUTF8StringEncoding];
            if (string) {
                return string;
            }
        }
    }else if (self.objClass == LSBObjectClassImage){
        return self.value;
    }
    return nil;
}


@end


@implementation LSBHelper

+(CGFloat)adapt:(CGFloat)fValue
{
    return fValue * [UIScreen mainScreen].bounds.size.width/375.0;
}


+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message onVc:(UIViewController *)onVc btnTitle:(NSString *)btnTitle leftAction:(void (^)(UIAlertAction * _Nonnull))action
{
    UIAlertController * ac = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (btnTitle) {
        [ac addAction:[UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleDefault handler:action]];
    }
    [onVc presentViewController:ac animated:YES completion:nil];
}

+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message onVc:(UIViewController *)onVc leftBtnTitle:(NSString *)leftBtnTitle leftAction:(void (^)(UIAlertAction * _Nonnull))leftAction rightBtnTitle:(NSString *)rightBtnTitle rightAction:(void (^)(UIAlertAction * _Nonnull))rightAction
{
    UIAlertController * ac = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (leftBtnTitle) {
        [ac addAction:[UIAlertAction actionWithTitle:leftBtnTitle style:UIAlertActionStyleDestructive handler:leftAction]];
    }
    if (rightBtnTitle) {
        [ac addAction:[UIAlertAction actionWithTitle:rightBtnTitle style:UIAlertActionStyleCancel handler:rightAction]];
    }
    [onVc presentViewController:ac animated:YES completion:nil];
}


+(NSBundle *)getResourceBundle
{
    NSBundle * mainBundle = [NSBundle bundleForClass:[self class]];
    NSString * resourcePath = [mainBundle pathForResource:@"LSBResources" ofType:@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:resourcePath];
    return resourceBundle?:mainBundle;
}
+(UIImage *)imageWithName:(NSString *)imageName
{
    NSBundle * resBundle = [self getResourceBundle];
    UIImage * image = [[UIImage alloc] initWithContentsOfFile:[resBundle pathForResource:imageName ofType:@"png"]];
    return image;
}

@end
