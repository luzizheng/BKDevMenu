//
//  LSBBaseCell.h
//  BKDevMenu
//
//  Created by luzz on 2021/11/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSBBaseCell : UITableViewCell
@property(nonatomic,strong)UIImageView * icon;
@property(nonatomic,strong)UILabel * firstLineLabel;
@property(nonatomic,strong)UILabel * secondLineLabel;

-(void)didInitUI NS_REQUIRES_SUPER;
@end

NS_ASSUME_NONNULL_END
