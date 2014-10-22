//
//  DFShoppingDetailVC.h
//  df360
//
//  Created by wangxl on 14-10-19.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFCustomViewController.h"

@interface DFShoppingDetailVC : DFCustomViewController
@property (nonatomic ,retain) NSString *catId;
@property (nonatomic ,retain) NSString *goodPic;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *haveSeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;
@property (weak, nonatomic) IBOutlet UITextView *introductionTextView;
@property (weak, nonatomic) IBOutlet UITextView *noticeTextView;
@property (weak, nonatomic) IBOutlet UILabel *nowPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
- (IBAction)buySelected:(id)sender;

@end
