//
//  LSBCocoaClsBrowserVC.m
//  BKDevMenu
//
//  Created by luzz on 2021/11/8.
//

#import "LSBCocoaClsBrowserVC.h"
#import "LSBHelper.h"
#import "LSBKeyValueCell.h"
#import "LSBObjectCell.h"

@interface LSBCocoaHeaderView : UIView
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * detailLabel;
@property(nonatomic,strong)UIImageView * imageView;
@end
@implementation LSBCocoaHeaderView
- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        self.titleLabel.textColor = [UIColor darkTextColor];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        
        self.detailLabel = [[UILabel alloc] init];
        self.detailLabel.font = [UIFont fontWithName:@"PingFangSC-SemiBold" size:14];
        self.detailLabel.textColor = [UIColor systemBlueColor];
        self.detailLabel.numberOfLines = 0;
        self.detailLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.detailLabel];
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imageView];
    }
    return self;
}
-(CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(size.width, [self sizeFitWithWidth:size.width]);
}
-(CGFloat)sizeFitWithWidth:(CGFloat)width
{
    CGFloat margin = 20.0f;
    CGFloat content_w = width - margin * 2;
    CGSize titleSize = [self.titleLabel sizeThatFits:CGSizeMake(content_w, CGFLOAT_MAX)];
    self.titleLabel.frame = CGRectMake(margin, margin, content_w, titleSize.height);
    CGSize detailSize = [self.detailLabel sizeThatFits:CGSizeMake(content_w, CGFLOAT_MAX)];
    self.detailLabel.frame = CGRectMake(margin, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 10, content_w, detailSize.height);
    CGFloat bottom = self.detailLabel.frame.origin.y + self.detailLabel.frame.size.height;
    if (self.imageView.image) {
        CGFloat img_height = self.imageView.image.size.height * content_w / self.imageView.image.size.width;
        self.imageView.frame = CGRectMake(margin, bottom + 10, content_w, img_height);
        bottom = self.imageView.frame.origin.y + self.imageView.frame.size.height;
    }
    return bottom + margin;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self sizeFitWithWidth:self.frame.size.width];
}
@end


@interface LSBCocoaClsBrowserVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)LSBObjectInfo * objInfo;
@property(nonatomic,strong)LSBCocoaHeaderView * header;
@property(nonatomic,strong)NSArray * dataSources;
@end

@implementation LSBCocoaClsBrowserVC

#pragma mark - view setup
-(instancetype)initWithObj:(id)obj
{
    if (self = [super init]) {
        self.obj = obj;
    }
    return self;
}

- (void)setObj:(id)obj
{
    _obj = obj;
    self.objInfo = [LSBObjectInfo infoWithValue:obj];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Cocoa类浏览器";
    
    
    UITableView *tv = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tv.delegate = self;
    tv.dataSource = self;
    [tv registerClass:[LSBKeyValueCell class] forCellReuseIdentifier:NSStringFromClass([LSBKeyValueCell class])];
    [tv registerClass:[LSBObjectCell class] forCellReuseIdentifier:NSStringFromClass([LSBObjectCell class])];
    [self.view addSubview:tv];
    tv.tableFooterView = [UIView new];
    self.tableView = tv;
    
    [self setupHeaderData];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
    [self layoutHeader];
}

-(void)layoutHeader
{
    CGSize headSize = [self.header sizeThatFits:CGSizeMake(self.view.frame.size.width, CGFLOAT_MAX)];
    self.header.frame = CGRectMake(0, 0, self.view.frame.size.width, headSize.height);
    self.tableView.tableHeaderView = self.header;
}

#pragma mark - data setup
-(void)setupHeaderData
{
    self.header.titleLabel.text = [NSString stringWithFormat:@"KEY <%@>: %@",self.objInfo.className,self.keyNameIfNeed?:@"default"];
    self.header.detailLabel.text = self.objInfo.valueDetail;
    
    LSBObjectClass cls = self.objInfo.objClass;
    
    if (cls == LSBObjectClassData || cls == LSBObjectClassImage) {
        id object = [self.objInfo tryToParseDataOrImage];
        if (object) {
            if ([object isKindOfClass:[NSString class]]) {
                self.header.detailLabel.text = object;
            }else if ([object isKindOfClass:[UIImage class]]){
                self.header.imageView.image = object;
            }
        }
    }else if(cls == LSBObjectClassNil || cls == LSBObjectClassNull || cls == LSBObjectClassString || cls == LSBObjectClassNumber){
        //
    }else if(cls == LSBObjectClassArray){
        self.dataSources = self.obj;
        
    }else if (cls == LSBObjectClassDictionary){
        NSMutableArray * temp = [NSMutableArray array];
        for (NSString * key in ((NSDictionary*)self.obj).allKeys) {
            LSBKeyValueStruct * model = [LSBKeyValueStruct new];
            model.key = key;
            model.value = ((NSDictionary*)self.obj)[key];
            [temp addObject:model];
        }
        self.dataSources = temp;
    }
    
    [self layoutHeader];
    [self.tableView reloadData];
    
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSources.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.objInfo.objClass == LSBObjectClassArray) {
        
        LSBObjectCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LSBObjectCell class])];
        cell.index = indexPath.row + 1;
    
        if (indexPath.row < self.dataSources.count) {
            cell.obj = self.dataSources[indexPath.row];
        }
        return cell;
    }else if (self.objInfo.objClass == LSBObjectClassDictionary){
        LSBKeyValueCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LSBKeyValueCell class])];
        if (indexPath.row < self.dataSources.count) {
            LSBKeyValueStruct * model = self.dataSources[indexPath.row];
            cell.model = model;
            return cell;
        }
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.objInfo.objClass == LSBObjectClassArray) {
        if (indexPath.row < self.dataSources.count) {
            id obj = self.dataSources[indexPath.row];
            LSBCocoaClsBrowserVC * vc = [[LSBCocoaClsBrowserVC alloc] initWithObj:obj];
            vc.keyNameIfNeed = @"NSArray Item";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (self.objInfo.objClass == LSBObjectClassDictionary){

        if (indexPath.row < self.dataSources.count) {
            LSBKeyValueStruct * model = self.dataSources[indexPath.row];
            LSBCocoaClsBrowserVC * vc = [[LSBCocoaClsBrowserVC alloc] initWithObj:model.value];
            vc.keyNameIfNeed =  model.key;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    
}

#pragma mark - lazy
- (NSArray *)dataSources
{
    if (!_dataSources) {
        _dataSources = [NSArray array];
    }
    return _dataSources;
}

- (LSBCocoaHeaderView *)header
{
    if (!_header) {
        _header = [LSBCocoaHeaderView new];
    }
    return _header;
}



@end
