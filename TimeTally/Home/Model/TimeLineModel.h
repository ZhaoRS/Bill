//
//  TimeLineModel.h
//  TimeTally
//
//  Created by 赵瑞生 on 2017/1/12.
//  Copyright © 2017年 赵瑞生. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TallyMoneyType) {
    TallyMoneyTypeIn = 0,
    TallyMoneyTypeOut,
};

@interface TimeLineModel : NSObject


@property (nonatomic, copy) NSString *tallyIconName;
@property (nonatomic, assign) double tallyMoney;
@property (nonatomic, assign) TallyMoneyType tallyMoneyType;
@property (nonatomic, copy) NSString *talluDate;
@property (nonatomic, copy) NSString *tallyType;
@property (nonatomic, copy) NSString *identity;
@property (nonatomic, assign) double income;
@property (nonatomic, assign) double expense;


@end
