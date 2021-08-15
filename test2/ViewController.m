//
//  ViewController.m
//  test2
//
//  Created by liuyaozong on 2021/8/15.
//

#import "ViewController.h"
#import "UITableView+placeHolder.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) UIButton *changeStatusBtn;
@property (strong,nonatomic) NSMutableArray *dataList;
@end

@implementation ViewController
-(UIButton *)changeStatusBtn
{
    if (!_changeStatusBtn) {
        _changeStatusBtn = [[UIButton alloc] init];
        [_changeStatusBtn setTitle:@"切换状态" forState:UIControlStateNormal];
        [_changeStatusBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_changeStatusBtn addTarget:self action:@selector(clickChange) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _changeStatusBtn;
}
-(NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return  _dataList;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UILabel *label = [[UILabel alloc] init];
        label.text = @"暂无数据";
        label.textColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentCenter;
        _tableView.placeHolder = label;
    }
    return _tableView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.changeStatusBtn];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tableView.frame = self.view.bounds;
        self.changeStatusBtn.frame = CGRectMake(100, 100, 100, 100);
        [self.tableView reloadData];
    });
}

-(void)clickChange
{
    if (self.dataList.count == 0) {
        [self.dataList addObject:@"1"];
        [self.dataList addObject:@"1"];
        [self.dataList addObject:@"1"];
        [self.dataList addObject:@"1"];
        [self.dataList addObject:@"1"];
        [self.dataList addObject:@"1"];
    } else {
        [self.dataList removeAllObjects];
    }
    [self.tableView reloadData];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return  cell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}



@end
