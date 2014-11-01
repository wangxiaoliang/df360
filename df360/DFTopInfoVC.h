//
//  DFTopInfoVC.h
//  df360
//
//  Created by wangxl on 14/10/20.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFCustomViewController.h"

@interface DFTopInfoVC : DFCustomViewController
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UIView *noticeView;
@property (weak, nonatomic) IBOutlet UILabel *viewLabel;
@property (weak, nonatomic) IBOutlet UIButton *reportBtn;
@property (nonatomic, retain) NSDictionary *sendDic;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;
- (IBAction)reportSelected:(id)sender;
@end
