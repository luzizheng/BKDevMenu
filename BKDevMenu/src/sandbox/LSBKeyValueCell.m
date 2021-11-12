//
//  LSBKeyValueCell.m
//  BKDevMenu
//
//  Created by luzz on 2021/11/5.
//

#import "LSBKeyValueCell.h"
#import "LSBHelper.h"
@implementation LSBKeyValueStruct

@end

@interface LSBKeyValueCell()
@end
@implementation LSBKeyValueCell


- (void)setModel:(LSBKeyValueStruct *)model
{
    _model = model;
    self.firstLineLabel.attributedText = [[NSAttributedString alloc] initWithString:model.key attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-SemiBold" size:14],NSForegroundColorAttributeName:[UIColor darkTextColor]}];
    LSBObjectInfo * info = [LSBObjectInfo infoWithValue:model.value];
    
    NSString * strA = [NSString stringWithFormat:@"[%@]",info.className];
    NSString * strB = [NSString stringWithFormat:@" : %@",info.valueDetail];
    NSString * str = [strA stringByAppendingString:strB];
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:str];
    [string addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:12],NSForegroundColorAttributeName:[UIColor systemOrangeColor]} range:[str rangeOfString:strA]];
    [string addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-SemiBold" size:14],NSForegroundColorAttributeName:[UIColor systemBlueColor]} range:[str rangeOfString:strB]];
    self.secondLineLabel.attributedText = string;
    self.icon.image = [LSBHelper imageWithName:info.iconName];
}


@end
