//
//  TallyListCell.m
//  TimeTally
//
//  Created by 赵瑞生 on 2017/1/17.
//  Copyright © 2017年 赵瑞生. All rights reserved.
//

#import "TallyListCell.h"

@implementation TallyListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


- (void)setCellModel:(TallyListCellModel *)cellModel {
    _cellModel = cellModel;
    _imageLab.text = cellModel.tallyCellName;
    _imageView.image = [UIImage imageNamed:cellModel.tallyCellImage];
}

@end
