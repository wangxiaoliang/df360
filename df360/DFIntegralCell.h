//
//  DFIntegralCell.h
//  df360
//
//  Created by wangxl on 14/11/1.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DFIntegralCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fwLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *momeyLabel;

+(UINib *)nib;

@end
