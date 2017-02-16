//
//  TallyListCell.h
//  TimeTally
//
//  Created by 赵瑞生 on 2017/1/17.
//  Copyright © 2017年 赵瑞生. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TallyListCellModel.h"

@interface TallyListCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *imageLab;

@property (nonatomic, strong) TallyListCellModel *cellModel;

@end
