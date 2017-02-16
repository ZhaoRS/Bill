//
//  TallyListView.h
//  TimeTally
//
//  Created by 赵瑞生 on 2017/1/17.
//  Copyright © 2017年 赵瑞生. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TimeTally+CoreDataModel.h"
#import "AppDelegate.h"
#import "CoreDataOperations.h"
#import "TallyListCell.h"

@protocol TallyListViewDelegate <NSObject>

//选择对应的cell 传递image title cell 的实际位置
- (void)didSelectItem:(UIImage *)cellImage andTitle:(NSString *)title withRectInCollection:(CGRect)itemRect;

//滚动到底
- (void)listScrollToBottom;

@end


@interface TallyListView : UICollectionView

@property (nonatomic, strong) id<TallyListViewDelegate> customDelegate;

@end
