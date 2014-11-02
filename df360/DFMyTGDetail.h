//
//  DFMyTGDetail.h
//  df360
//
//  Created by wangxl on 14/11/2.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFCustomViewController.h"


@interface DFMyTGDetail : DFCustomViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *noticeView;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
- (IBAction)payClick:(id)sender;

@property (nonatomic, retain) NSDictionary *senderDic;
@property (nonatomic, assign) BOOL isTG;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel2;
@property (weak, nonatomic) IBOutlet UIView *JFPayView;

@end
