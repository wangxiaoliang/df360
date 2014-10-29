//
//  DFChildDetailVC.h
//  df360
//
//  Created by wangxl on 14-9-24.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFCustomViewController.h"

@interface DFChildDetailVC : DFCustomViewController
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;

@property (weak, nonatomic) IBOutlet UIImageView *image_1;
@property (weak, nonatomic) IBOutlet UIImageView *image_2;
@property (weak, nonatomic) IBOutlet UIImageView *image_3;
@property (weak, nonatomic) IBOutlet UIImageView *image_4;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewsLabel;
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
- (IBAction)reportClick:(id)sender;
@property (nonatomic, retain) NSDictionary *sendDic;

@end
