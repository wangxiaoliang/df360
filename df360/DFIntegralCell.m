//
//  DFIntegralCell.m
//  df360
//
//  Created by wangxl on 14/11/1.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFIntegralCell.h"

@implementation DFIntegralCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+(UINib *)nib{
    return [UINib nibWithNibName:NSStringFromClass(self) bundle:nil];
}

@end
