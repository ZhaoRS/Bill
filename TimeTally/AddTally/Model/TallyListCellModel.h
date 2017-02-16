//
//  TallyListCellModel.h
//  TimeTally
//
//  Created by 赵瑞生 on 2017/1/14.
//  Copyright © 2017年 赵瑞生. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TallyListCellModel : NSObject

@property (nonatomic, copy) NSString *tallyCellImage;
@property (nonatomic, copy) NSString *tallyCellName;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)tallyListCellModelWithDict:(NSDictionary *)dict;

@end
