//
//  AddTallyViewController.m
//  TimeTally
//
//  Created by 赵瑞生 on 2017/1/14.
//  Copyright © 2017年 赵瑞生. All rights reserved.
//

#import "AddTallyViewController.h"
#import "TallyListView.h"
#import "CalculatorView.h"

@interface AddTallyViewController ()<TallyListViewDelegate, CalculatorViewDelegate, UIViewControllerTransitioningDelegate>


@property (nonatomic, strong) TallyListView *listView;
@property (nonatomic, strong) CalculatorView *calView;
@property (nonatomic, copy)   NSString *currentTawllyIdentity;
@property (nonatomic, assign) CGSize itemSize;


@end

//类型选择界面每行cell的个数
static int const aRowCellCount = 4;

@implementation AddTallyViewController

- (TallyListView *)listView {
    if (!_listView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 30;
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        CGFloat width = (self.view.frame.size.width - (aRowCellCount - 1) * layout.minimumInteritemSpacing - layout.sectionInset.left - layout.sectionInset.right) /aRowCellCount;
        CGFloat height = width * 1.2;
        layout.footerReferenceSize = CGSizeZero;
        layout.headerReferenceSize = CGSizeZero;
        layout.itemSize = CGSizeMake(width, height);
        _itemSize = CGSizeMake(width - 20, width - 20);
        
        //记账类型列表
        _listView = [[TallyListView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - self.view.frame.size.height * 0.4 / 5) collectionViewLayout:layout];
        _listView.customDelegate = self;
    }
    return _listView;
}

//计算器界面
- (CalculatorView *)calView {
    if (!_calView) {
        _calView = [[CalculatorView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.6, self.view.frame.size.width, self.view.frame.size.height * 0.4)];
        _calView.delegate = self;
        _calView.imageViewSize = _itemSize;
    }
    return _calView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.listView];
    [self.view addSubview:self.calView];
    self.title = @"新增";
    
    //修改临时计算界面传值
    if (_currentTawllyIdentity != nil) {
        [_calView modifyTallyWithIdentity:_currentTawllyIdentity];
        self.title = @"修改";
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

#pragma mark - TallyListViewDelegate
- (void)didSelectItem:(UIImage *)cellImage andTitle:(NSString *)title withRectInCollection:(CGRect)itemRect  {
    
    UIImageView *animateImage = [[UIImageView alloc] initWithFrame:itemRect];
    animateImage.image = cellImage;
    [self.view addSubview:animateImage];
    
    __block CGPoint imgPoint;
    _calView.positionInViewBlock = ^(CGPoint point) {
        imgPoint = point;
    };
    
    //给计算机界面传值
    _calView.imageViewSize = itemRect.size;
    _calView.image = cellImage;
    _calView.typeNamge = title;
    
    //设置贝塞尔曲线路径动画
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:animateImage.center];
    [path addCurveToPoint:imgPoint controlPoint1:CGPointMake(animateImage.frame.origin.x, animateImage.frame.origin.y - 100) controlPoint2:CGPointMake(animateImage.frame.origin.x, animateImage.frame.origin.y - 100)];
    CAKeyframeAnimation *animation0 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation0.path = path.CGPath;
    animation0.duration = 1;
    animation0.removedOnCompletion = NO;
    animation0.fillMode = kCAFillModeForwards;
    [animateImage.layer addAnimation:animation0 forKey:nil];
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer * _Nonnull timer) {
        [animateImage removeFromSuperview];
    }];
}

//计算界面下降
- (void)listScrollToBottom {
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _calView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - CGRectGetHeight(_calView.frame) / 5, _calView.frame.size.width, _calView.frame.size.height);
    } completion:nil];
}

#pragma mark - CalculatorViewDelegate
//保存成功
- (void)tallySaveCompleted {
    //随机转场动画
    NSArray *tanArray = @[@"pageCurl",@"pageUnCurl",@"rippleEffect",@"suckEffect",@"cube",@"oglFlip"];
    NSString *anStr = tanArray[arc4random()%tanArray.count];
    self.navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    CATransition *tran = [CATransition animation];
    tran.duration = 0.5;
    tran.type = anStr;
    tran.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:tran forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

//保存失败
- (void)tallySaveFailed {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入类别并输入金额" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

//返回位置
- (void)backPositionWithAnimation {
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _calView.frame = CGRectMake(0, self.view.frame.size.height * 0.6, self.view.frame.size.width, self.view.frame.size.height);
    } completion:nil];
}

- (void)setSelectTallyWithIdentity:(NSString *)identity {
    _currentTawllyIdentity = identity;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
