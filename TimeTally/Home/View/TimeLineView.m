//
//  TimeLineView.m
//  TimeTally
//
//  Created by 赵瑞生 on 2017/1/14.
//  Copyright © 2017年 赵瑞生. All rights reserved.
//

#import "TimeLineView.h"

@interface TimeLineView ()

@property (nonatomic, strong) UIView *panelView;

@end

@implementation TimeLineView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    int keyInex = 0;
    CGFloat aDateAllLine = 0;
    for (NSString *key in self.timeLineModelsDict.allKeys) {
        //读取字典对应key的数组
        NSArray<TimeLineModel *> *modelArray = self.timeLineModelsDict[key];
        if (modelArray.count == 0) {
            return;
        }
        
        //画线
        CGRect dateRect = CGRectMake(self.center.x - kDateWidth / 2, aDateAllLine, kDateWidth, kDateWidth);
        CGContextAddEllipseInRect(context, dateRect);
        CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
        CGContextFillPath(context);
        CGContextStrokePath(context);
        CGRect dateLabRect = CGRectMake(0, aDateAllLine, self.frame.size.width / 2 - kBtnWidth, kBtnWidth / 2);
        
        //日期lab
        UILabel *dateLab = [[UILabel alloc] initWithFrame:dateLabRect];
        dateLab.textAlignment = NSTextAlignmentRight;
        dateLab.text = key;
        [dateLab setTextColor:[UIColor blueColor]];
        [self addSubview:dateLab];
        
        for (int i = 0; i < modelArray.count; i ++) {
            //画竖线
            CGFloat start = aDateAllLine + kDateWidth + i * (kLineHight + kBtnWidth);
            CGFloat end = aDateAllLine + kDateWidth + kLineHight + i * (kLineHight + kLineWidth);
            CGContextMoveToPoint(context, self.center.x, start);
            CGContextAddLineToPoint(context, self.center.x, end);
            CGContextSetLineWidth(context, kLineWidth);
            CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
            CGContextStrokePath(context);
            
            //收支类型btn
            CGRect btnRect = CGRectMake(self.center.x - kBtnWidth / 2, end, kBtnWidth, kBtnWidth);
            UIButton *btn = [[UIButton alloc] initWithFrame:btnRect];
            btn.tag = i;
            btn.keyWithBtn = key;
            TimeLineModel *subModel = modelArray[i];
            NSLog(@"%@", subModel.tallyIconName);
            [btn setImage:[UIImage imageNamed:modelArray[i].tallyIconName] forState:UIControlStateNormal];
            btn.layer.masksToBounds = YES;
            [btn addTarget:self action:@selector(clickTallyTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
            //收支情况
            CGFloat labX = modelArray[i].tallyMoneyType == TallyMoneyTypeIn ? 0 : self.center.x + kBtnWidth;
            CGFloat labY = btnRect.origin.y;
            CGFloat labWidth = self.frame.size.width / 2 - kBtnWidth;
            CGFloat labHeight = btnRect.size.height;
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labX, labY, labWidth, labHeight)];
            label.textAlignment  = modelArray[i].tallyMoneyType == TallyMoneyTypeIn ? NSTextAlignmentRight: NSTextAlignmentLeft;
            label.text = [NSString stringWithFormat:@"%@ %.2f", modelArray[i].tallyType, modelArray[i].tallyMoney];
            [self addSubview:label];
            
            
            //最后一条线 最后一条账单不画线
            if (keyInex < self.timeLineModelsDict.allKeys.count) {
                CGFloat lastStart = aDateAllLine;
                CGFloat lastEnd = kLineHight;
                CGContextMoveToPoint(context, self.center.x, lastStart);
                CGContextAddLineToPoint(context, self.center.x, lastEnd);
                CGContextSetLineWidth(context, kLineWidth);
                CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
                CGContextStrokePath(context);
            }
        }
        //当前时间线总长
        aDateAllLine = aDateAllLine + kDateWidth + (kBtnWidth + kLineHight) * modelArray.count + kLineHight;
        keyInex ++;
    }
    
}

//刷新view时清空UI  setNeedsLayout和setNeedsDisplay都是异步执行 setNeedsDisplay会自动调用drawRect方法， 这样就可以拿到UIGraphicsGetCurrentContext就可以画画了， 而layoutSubViews会默认调用layoutSubViews，这样就可以处理姿势图中的一些数据  layoutSubViews方便处理数据 layoutSubViews方便绘图
- (void)setNeedsDisplay {
    [super setNeedsDisplay];
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}


//点击账单类型按钮
- (void)clickTallyTypeBtn:(UIButton *)btn {

    NSLog(@"%@", btn.keyWithBtn);
    
    //清空控制板
    if (self.panelView) {
        [self.panelView removeFromSuperview];
    }
    
    //控制板出现
    _panelView = [[UIView alloc] initWithFrame:CGRectMake(0, btn.frame.origin.y, self.frame.size.width, btn.frame.size.height)];
    _panelView.backgroundColor = [UIColor whiteColor];
    _panelView.userInteractionEnabled = YES;
    [self addSubview:_panelView];
    
    //左按钮  删除
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width / 4 - kBtnWidth / 2, 0, kBtnWidth, kBtnWidth)];
    leftBtn.backgroundColor = [UIColor clearColor];
    leftBtn.panelBtnType = PanelViewBtnTypeLeft;
    leftBtn.tag = btn.tag;
    leftBtn.keyWithBtn = btn.keyWithBtn;
    [leftBtn setImage:[UIImage imageNamed:@"删除#时光轴_25x25_"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(deleteCurrentTallly:) forControlEvents:UIControlEventTouchUpInside];
    [_panelView addSubview:leftBtn];
    [self btnShowAnimation:leftBtn];
    
    //右按钮
    UIButton *righBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width *3 / 4 - kBtnWidth / 2, 0, kBtnWidth, kBtnWidth)];
    righBtn.backgroundColor = [UIColor clearColor];
    righBtn.backgroundColor = [UIColor clearColor];
    righBtn.panelBtnType = PanelViewBtnTypeRight;
    righBtn.tag = btn.tag;
    righBtn.keyWithBtn = btn.keyWithBtn;
    [righBtn setImage:[UIImage imageNamed:@"修改#时光轴_25x25_"] forState:UIControlStateNormal];
    [righBtn addTarget:self action:@selector(modifyCurrentTally:) forControlEvents:UIControlEventTouchUpInside];
    [_panelView addSubview:righBtn];
    [self btnShowAnimation:righBtn];
    
    //中间按钮
    UIButton *middleBtn = [[UIButton alloc] initWithFrame:CGRectMake(btn.frame.origin.x, 0, kBtnWidth, kBtnWidth)];
    [middleBtn setImage:btn.imageView.image forState:UIControlStateNormal];
    [middleBtn addTarget:self action:@selector(clickMiddleBtn) forControlEvents:UIControlEventTouchUpInside];
    middleBtn.backgroundColor = [UIColor clearColor];
    [_panelView addSubview:middleBtn];
}

//btn出现时动画
- (void)btnShowAnimation:(UIButton *)btn {
    btn.backgroundColor = [UIColor whiteColor];
    CABasicAnimation *an = [CABasicAnimation animation];
    an.keyPath = @"position";
    CGFloat x = btn.panelBtnType ? self.frame.size.width * 3/4 : self.frame.size.width / 4;
    an.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, btn.center.y)];
    an.toValue = [NSValue valueWithCGPoint:CGPointMake(x, btn.center.y)];
    an.duration = 0.5;
    an.removedOnCompletion = NO;
    an.fillMode = kCAFillModeForwards;
    [btn.layer addAnimation:an forKey:nil];
}

//点击中间按钮  控制板收回
- (void)clickMiddleBtn {
    for (UIButton *btn in _panelView.subviews) {
        [self btnDismissAnimation:btn];
    }
    [NSTimer scheduledTimerWithTimeInterval:0.5 repeats:NO block:^(NSTimer * _Nonnull timer) {
        [_panelView removeFromSuperview];
    }];
}

//btn消失动画
- (void)btnDismissAnimation:(UIButton *)btn {
    btn.backgroundColor = [UIColor clearColor];
    CABasicAnimation *an = [CABasicAnimation animation];
    an.keyPath = @"position";
    an.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, btn.center.y)];
    an.duration = 0.5;
    an.removedOnCompletion = NO;
    an.fillMode = kCAFillModeForwards;
    [btn.layer addAnimation:an forKey:nil];
}

//删除当前账单  回调给controller处理
- (void)deleteCurrentTallly:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(willChangeValueForKey:)]) {
        
        NSArray<TimeLineModel *> *array = self.timeLineModelsDict[btn.keyWithBtn];
        [_delegate willDeleteCurrentTallyWithIndentity:array[btn.tag].identity];
    }
}

//修改当前账单  回调给controller处理
- (void)modifyCurrentTally:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(willModifyCurrentTallyWithIdentity:)]) {
        NSArray<TimeLineModel *> *array = self.timeLineModelsDict[btn.keyWithBtn];
        [_delegate willModifyCurrentTallyWithIdentity:array[btn.tag].identity];
    }
    
}

@end
