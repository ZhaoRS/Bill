//
//  TimeLineView.h
//  TimeTally
//
//  Created by 赵瑞生 on 2017/1/14.
//  Copyright © 2017年 赵瑞生. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TimeTally+CoreDataModel.h"
#import "AppDelegate.h"
#import "TimeLineModel.h"
#import <objc/runtime.h>


static CGFloat const kLineHight = 60;
static CGFloat const kLineWidth = 2;
static CGFloat const kBtnWidth = 30;
static CGFloat const kDateWidth = 10;

@protocol TimeLineViewDelegate <NSObject>

//准备删除
- (void)willDeleteCurrentTallyWithIndentity:(NSString *)identity;

//准备修改
- (void)willModifyCurrentTallyWithIdentity:(NSString *)identity;


@end


@interface TimeLineView : UIView

@property (nonatomic, strong) NSDictionary *timeLineModelsDict;
@property (nonatomic, strong) id <TimeLineViewDelegate> delegate;
@end


typedef NS_ENUM(NSInteger, PanelViewBtnType) {
    PanelViewBtnTypeLeft = 0,
    PanelViewBtnTypeRight,
};

@interface UIButton (BtnWithKey)

@property (nonatomic, copy) NSString *keyWithBtn;
@property (nonatomic, assign) PanelViewBtnType panelBtnType;

@end

static const void *kKeyWithBtn = @"keyWithBtn";
static const void *kPanelBtnType = @"panelBtnType";

@implementation UIButton (BtnWithKey)

- (NSString *)keyWithBtn
{
    return  objc_getAssociatedObject(self, kKeyWithBtn);
}

- (void)setKeyWithBtn:(NSString *)keyWithBtn
{
    objc_setAssociatedObject(self, kKeyWithBtn, keyWithBtn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (PanelViewBtnType)panelBtnType {
    return [objc_getAssociatedObject(self, kPanelBtnType) intValue];
}

- (void)setPanelBtnType:(PanelViewBtnType)panelBtnType {
    objc_setAssociatedObject(self, kPanelBtnType, [NSNumber numberWithUnsignedInteger:panelBtnType], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
