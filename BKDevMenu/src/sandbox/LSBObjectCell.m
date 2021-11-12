//
//  LSBObjectCell.m
//  BKDevMenu
//
//  Created by luzz on 2021/11/5.
//

#import "LSBObjectCell.h"
#import "LSBHelper.h"

@interface LSBObjectCell()

@property(nonatomic,strong)UILabel * sortLabel;

@end

@implementation LSBObjectCell

- (void)didInitUI
{
    [super didInitUI];
    self.sortLabel = [[UILabel alloc] init];
    self.sortLabel.font = self.firstLineLabel.font;
    self.sortLabel.textColor = self.firstLineLabel.textColor;
    [self.contentView addSubview:self.sortLabel];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.sortLabel.text) {
        CGFloat left = self.icon.frame.origin.x;
        CGSize labelSize = [self.sortLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        self.sortLabel.frame = CGRectMake(left, (self.contentView.frame.size.height - labelSize.height)/2, labelSize.width, labelSize.height);
        CGFloat move = labelSize.width + 8;
        [self moveRightWithView:self.icon offset:move];
        [self moveRightWithView:self.firstLineLabel offset:move];
        [self moveRightWithView:self.secondLineLabel offset:move];
    }
}

-(void)moveRightWithView:(UIView *)view offset:(CGFloat)offset
{
    CGRect frame = view.frame;
    frame.origin.x = frame.origin.x + offset;
    view.frame = frame;
}


- (void)setIndex:(NSInteger)index
{
    _index = index;
    self.sortLabel.text = [NSString stringWithFormat:@"%ld",(long)index];
}


- (void)setObj:(id)obj
{
    _obj = obj;
    
    LSBObjectInfo * info = [LSBObjectInfo infoWithValue:obj];
    
    self.firstLineLabel.text = info.className;
    self.secondLineLabel.attributedText = [[NSAttributedString alloc] initWithString:info.valueDetail attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-SemiBold" size:14],NSForegroundColorAttributeName:[UIColor systemBlueColor]}];
    self.icon.image = [LSBHelper imageWithName:info.iconName];

    
}

@end
