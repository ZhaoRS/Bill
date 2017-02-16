//
//  CoreDataOperations.h
//  TimeTally
//
//  Created by 赵瑞生 on 2017/1/12.
//  Copyright © 2017年 赵瑞生. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TimeTally+CoreDataModel.h"
#import "TimeLineModel.h"
#import "AppDelegate.h"

@interface CoreDataOperations : NSObject

@property (nonatomic, strong) NSManagedObjectContext *manageObjectContex;

//单例
+ (instancetype)sharedInstance;

//从数据库中删除Tally表中对用的identity字段
- (void)deleateTally:(Tally *)object;

//保存
- (void)saveTally;

//读取对应的字段
- (Tally *)getTallyWithIdentity:(NSString *)identity;

//获取对应类型
- (TallyType *)getTallyTypeWithTypeName:(NSString *)typeName;

//读取数据库中的数据，以点的形式key： @“日期” object：[账单信息]
- (NSDictionary *)getAllDataWithDict;

@end
