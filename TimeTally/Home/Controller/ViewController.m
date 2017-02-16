//
//  ViewController.m
//  TimeTally
//
//  Created by 赵瑞生 on 2017/1/12.
//  Copyright © 2017年 赵瑞生. All rights reserved.
//

#import "ViewController.h"
#import "TimeLineView.h"
#import "AddTallyViewController.h"

@interface ViewController () <TimeLineViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSDictionary *timeLineModelsDict;
@property (nonatomic, assign) CGFloat allDateAllLine;
@property (weak, nonatomic) IBOutlet UILabel *incomLab;
@property (weak, nonatomic) IBOutlet UILabel *expenseLab;


@end

@implementation ViewController


- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64 + 80, self.view.frame.size.width, self.view.frame.size.height - 64 - 80)];
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@", NSHomeDirectory());
    self.title = @"我的账本";
    [self.view addSubview:self.scrollView];
    
}

//增加一条账单
- (IBAction)clickAddTally:(UIButton *)sender {
    
    AddTallyViewController *addVC = [[AddTallyViewController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
    
}

//出现时 刷新整个时间线
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showTimeLineView];
}

- (void)showTimeLineView {
    
    //先去读取数据库中的内容  封装成字典
    [self readSqliteData];
    
    //移除上一个timeLinrView
    for (UIView *view in self.scrollView.subviews) {
        if (view.tag == 1990) {
            [view removeFromSuperview];
        }
    }
    
    //计算收支
    double incomeTotal = 0;
    double expresTotal = 0;
    _allDateAllLine = 0;
    
    //计算时间长度
    for (NSString *key in _timeLineModelsDict.allKeys) {
        NSArray<TimeLineModel *> *modelArray = _timeLineModelsDict[key];
        //一天的时间线总长
        _allDateAllLine = _allDateAllLine + kDateWidth + (kBtnWidth + kLineHight) *modelArray.count + kLineHight;
        for (TimeLineModel *model in modelArray) {
            incomeTotal = incomeTotal + model.income;
            expresTotal = expresTotal + model.expense;
        }
    }
    
    _incomLab.text = [NSString stringWithFormat:@"%.2f", incomeTotal];
    _expenseLab.text = [NSString stringWithFormat:@"%.2f", expresTotal];
    
    //设置时间线试图timeLineView
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, _allDateAllLine);
    TimeLineView *view = [[TimeLineView alloc] initWithFrame:rect];
    view.tag = 1990;
    view.delegate = self;
    view.backgroundColor = [UIColor whiteColor];
    view.timeLineModelsDict = _timeLineModelsDict;
    [_scrollView addSubview:view];
    _scrollView.contentSize = CGSizeMake(0, _allDateAllLine);
    [_scrollView  setContentOffset:CGPointZero animated:YES];
}

//读取数据库中的数据
- (void)readSqliteData {
    _timeLineModelsDict = nil;
    _timeLineModelsDict = [[CoreDataOperations sharedInstance] getAllDataWithDict];
}

//删除前的确认
- (void)willDeleteCurrentTallyWithIndentity:(NSString *)identity {

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //操作数据库  从数据库中删除对应identity字段行
        Tally *tally = [[CoreDataOperations sharedInstance] getTallyWithIdentity:identity];
        [[CoreDataOperations sharedInstance] deleateTally:tally];
        //删除后刷新试图
        [self showTimeLineView];
        
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertVC animated:YES completion:nil];
}


//TimeLineViewDelegate delegate修改前的准备
- (void)willModifyCurrentTallyWithIdentity:(NSString*)identity  {
    AddTallyViewController *addVC = [[AddTallyViewController alloc] init];
    [addVC setSelectTallyWithIdentity:identity];
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
