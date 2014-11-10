//
//  DFShoppingBuyVC.h
//  df360
//
//  Created by wangxl on 14/10/20.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFCustomViewController.h"

@interface DFShoppingBuyVC : DFCustomViewController
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
- (IBAction)subtractionSelected:(id)sender;
- (IBAction)plusSelected:(id)sender;
- (IBAction)buySelected:(id)sender;
@property (nonatomic, retain) NSDictionary *senderDic;
@property (weak, nonatomic) IBOutlet UIView *downView;
@property (weak, nonatomic) IBOutlet UILabel *gtitle;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@end
