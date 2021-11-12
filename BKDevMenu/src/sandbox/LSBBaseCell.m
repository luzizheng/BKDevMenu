//
//  LSBBaseCell.m
//  BKDevMenu
//
//  Created by luzz on 2021/11/8.
//

#import "LSBBaseCell.h"
#import "LSBHelper.h"
@implementation LSBBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.icon = [[UIImageView alloc] init];
    self.icon.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.icon];
    
    self.firstLineLabel = [[UILabel alloc] init];
    self.firstLineLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    self.firstLineLabel.textColor = [UIColor darkTextColor];
    [self.contentView addSubview:self.firstLineLabel];
    
    self.secondLineLabel = [[UILabel alloc] init];
    self.secondLineLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    self.secondLineLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.secondLineLabel];
    
    [self didInitUI];
}

-(void)didInitUI{}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat margin = 15;
    CGFloat icon_w = [LSBHelper adapt:40];
    self.icon.frame = CGRectMake(margin, (self.contentView.bounds.size.height - icon_w)/2, icon_w, icon_w);
    CGFloat t_left = margin+ icon_w+margin;
    CGFloat t_w = self.contentView.bounds.size.width - 30 - t_left;
    CGSize nameSize = [self.firstLineLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    if (self.secondLineLabel.text.length > 0) {
        CGSize detailSize = [self.secondLineLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        CGFloat t_h = nameSize.height + 8 + detailSize.height;
        self.firstLineLabel.frame = CGRectMake(t_left, (self.contentView.bounds.size.height - t_h)/2, t_w, nameSize.height);
        self.secondLineLabel.frame = CGRectMake(t_left, self.contentView.bounds.size.height - (self.contentView.bounds.size.height - t_h)/2 - detailSize.height, detailSize.width, detailSize.height);
    }else{
        
        self.firstLineLabel.frame = CGRectMake(t_left, (self.contentView.bounds.size.height - nameSize.height)/2, t_w, nameSize.height);
        
    }
    
}

@end
