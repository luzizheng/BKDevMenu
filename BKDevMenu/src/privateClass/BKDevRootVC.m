//
//  BKDevRootVC.m
//  BKDevMenu
//
//  Created by luzz on 2021/11/3.
//

#import "BKDevRootVC.h"
#import "BKDevMenuItem.h"


@interface BKDevMenuCell : UITableViewCell
@property(nonatomic,strong)UISegmentedControl * segControl;
@end

@implementation BKDevMenuCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.segControl) {
        [self.segControl sizeToFit];
        CGSize segSize = self.segControl.frame.size;
        self.segControl.frame = CGRectMake(self.contentView.frame.size.width - 15 - segSize.width, (self.contentView.frame.size.height - segSize.height)/2, segSize.width, segSize.height);
    }
}

@end

@interface BKDevRootVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation BKDevRootVC
@synthesize menuItem = _menuItem;
#define kCellHeight 50.0f
#define kMaxRowNum 7

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.actionView = [[BKDevTransformView alloc] initWithFrame:CGRectMake(0, 0, kDevBtnWidth, kDevBtnWidth)];
    self.devBtn.frame = self.actionView.bounds;
    [self.actionView addSubview:self.devBtn];
    
    self.tableView.alpha = 0;
    [self.actionView addSubview:self.tableView];
    
    
    [self.view addSubview:self.actionView];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.actionView.bounds;
}


-(CGFloat)listHeight
{
    CGFloat height = self.menuItem.count <= kMaxRowNum?self.menuItem.count * kCellHeight:kCellHeight * kMaxRowNum;
    return MAX(kCellHeight, height);
    
}

    


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.minimizeActionBlock) {
        self.minimizeActionBlock();
    }
}


-(void)segAction:(UISegmentedControl *)seg
{
    NSInteger index = seg.accessibilityLabel.integerValue;
    if (index < self.menuItem.count ) {
        BKDevMenuItem * item = [self.menuItem objectAtIndex:index];
        if (item.segAction) {
            item.segAction(seg.selectedSegmentIndex, self.currentTopNav);
        }
    }
    
    seg.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.minimizeActionBlock) {
            self.minimizeActionBlock();
        }
    });
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuItem.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BKDevMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BKDevMenuCell class])];
    
    
    if (indexPath.row < self.menuItem.count) {
        BKDevMenuItem * item = [self.menuItem objectAtIndex:indexPath.row];
        cell.textLabel.text = item.title;
        
        if (cell.segControl) {
            [cell.segControl removeFromSuperview];
            cell.segControl = nil;
        }
        
        switch (item.style) {
            case BKDevMenuItemStyleDefault:cell.textLabel.textColor = [UIColor whiteColor];
                break;
            case BKDevMenuItemStyleCancel:cell.textLabel.textColor = [UIColor lightGrayColor];
                break;
            case BKDevMenuItemStyleDestructive:cell.textLabel.textColor = [UIColor systemRedColor];
                break;
            case BKDevMenuItemStyleQuickLogin:
            {
                cell.textLabel.textColor = [UIColor systemBlueColor];
                cell.textLabel.text = [NSString stringWithFormat:@"[快速登陆] %@",item.title];
            }
                break;
            case BKDevMenuItemStyleSegment:{
                cell.textLabel.textColor = [UIColor whiteColor];
                
                cell.segControl = [[UISegmentedControl alloc] initWithItems:item.segments];
                cell.segControl.selectedSegmentIndex = item.defaultIndexBlock();
                cell.segControl.backgroundColor = [UIColor whiteColor];

                [cell.segControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:13],NSForegroundColorAttributeName:[UIColor darkGrayColor]} forState:UIControlStateNormal];
                [cell.segControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-SemiBold" size:14],NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateSelected];
                [cell.segControl addTarget:self action:@selector(segAction:) forControlEvents:UIControlEventValueChanged];
                cell.segControl.accessibilityLabel = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
                [cell.contentView addSubview:cell.segControl];
                
            }
                break;
            default:
                break;
        }
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.minimizeActionBlock) {
        self.minimizeActionBlock();
    }
    if (indexPath.row < self.menuItem.count) {
        BKDevMenuItem * item = [self.menuItem objectAtIndex:indexPath.row];
        if (item.action) {
            item.action(self.currentTopNav);
        }
        
    }
}

#pragma mark - lazy
- (UIButton *)devBtn
{
    if (!_devBtn) {
        _devBtn = [[UIButton alloc] init];
        _devBtn.backgroundColor = [UIColor clearColor];
        [_devBtn setAttributedTitle:[[NSAttributedString alloc] initWithString:@"DEV" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:15],NSForegroundColorAttributeName:[UIColor whiteColor]}] forState:UIControlStateNormal];
    }
    return _devBtn;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _tableView.separatorColor = [UIColor lightGrayColor];
        [_tableView registerClass:[BKDevMenuCell class] forCellReuseIdentifier:NSStringFromClass([BKDevMenuCell class])];
    }
    return _tableView;
}

- (NSArray *)menuItem
{
    if (!_menuItem) {
        _menuItem = [NSArray array];
    }
    return _menuItem;
}

@end
