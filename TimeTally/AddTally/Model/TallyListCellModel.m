//
//  TallyListCellModel.m
//  TimeTally
//
//  Created by 赵瑞生 on 2017/1/14.
//  Copyright © 2017年 赵瑞生. All rights reserved.
//

#import "TallyListCellModel.h"

@implementation TallyListCellModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)tallyListCellModelWithDict:(NSDictionary *)dict {
    return  [[TallyListCellModel alloc] initWithDict:dict];
}


@end
