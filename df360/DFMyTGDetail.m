//
//  DFMyTGDetail.m
//  df360
//
//  Created by wangxl on 14/11/2.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFMyTGDetail.h"
#import "DFToolClass.h"
#import "DFToolView.h"
#import "AFNetworking.h"

@interface DFMyTGDetail ()<UITableViewDataSource,UITableViewDelegate,DFHudProgressDelegate>
{
    NSArray *titleArr;
    
    float tableViewHeight;
    
    DFHudProgress *_hud;
}
@end

@implementation DFMyTGDetail

- (void)viewDidLoad {
    
    self.WTitle = @"团购订单";
    self.WLeftBarStyle = LeftBarStyleDefault;
    self.WRightBarStyle = RightBarStyleNone;

    _hud = [[DFHudProgress alloc] init];
    
    _hud.delegate =self;
    
    if (_isTG) {
        self.JFPayView.hidden = YES;
        
        titleArr = [[NSArray alloc] initWithObjects:@"标题",@"单价",@"数量",@"总价",nil];
        
        self.tableView.scrollEnabled = NO;
        
        self.tableView.allowsSelection = NO;
        
        CGFloat height = [DFToolClass heightOfLabel:[_senderDic objectForKey:@"goods_title"] forFont:[UIFont systemFontOfSize:14] labelLength:160];
        
        tableViewHeight = 44 * 3 + height + 20;
        
        [self.tableView setFrame:CGRectMake(16, 20, 288, tableViewHeight)];
        
        [self.noticeView setFrame:CGRectMake(16, 40 + tableViewHeight, 288, 59)];
        
        [self.payBtn setFrame:CGRectMake(52, 119 + tableViewHeight, 217, 30)];
        
        if ([[_senderDic objectForKey:@"orderlist_usestatus"] isEqualToString:@"1"]) {
            
            
            [self.payBtn setTitle:@"确认无误，立即支付" forState:UIControlStateNormal];
        }
        
        else if ([[_senderDic objectForKey:@"orderlist_usestatus"] isEqualToString:@"2"]) {
            
            
            [self.payBtn setTitle:@"申请退款" forState:UIControlStateNormal];
        }
        else
        {
            self.payBtn.hidden = YES;
        }
        
    }
    
    else {
        
        self.WTitle = @"积分订单";

        titleArr = [[NSArray alloc] initWithObjects:@"订单",@"数量",@"总价",nil];
        
        self.tableView.scrollEnabled = NO;
        
        self.tableView.allowsSelection = NO;
        
        tableViewHeight = 44 * 3;
        
        [self.tableView setFrame:CGRectMake(16, 20, 288, tableViewHeight)];
        
        [self.noticeView setFrame:CGRectMake(16, 40 + tableViewHeight, 288, 59)];
        
        [self.payBtn setFrame:CGRectMake(52, 119 + tableViewHeight, 217, 30)];
        
        if ([[_senderDic objectForKey:@"status"] isEqualToString:@"1"]) {
            
            [self.JFPayView setFrame:CGRectMake(16, 40 + tableViewHeight, 288, 91)];
            
            [self.payBtn setFrame:CGRectMake(52, 151 + tableViewHeight, 217, 30)];
            
            self.noticeView.hidden = YES;
            
            
            
            [self.payBtn setTitle:@"支付" forState:UIControlStateNormal];
        }
        
        else if ([[_senderDic objectForKey:@"status"] isEqualToString:@"2"]) {
            
            _lineLabel.text =[NSString stringWithFormat:@"订单当前状态:%@",[DFToolClass stringISNULL:[_senderDic objectForKey:@"status_name"]]];
            
            _lineLabel2.text = [DFToolClass stringISNULL:[_senderDic objectForKey:@"message"]];
            
            _JFPayView.hidden = YES;

            
            [self.payBtn setTitle:@"申请退款" forState:UIControlStateNormal];
        }
        else
        {
            _lineLabel.text =[NSString stringWithFormat:@"订单当前状态:%@",[DFToolClass stringISNULL:[_senderDic objectForKey:@"status_name"]]];
            
            _lineLabel2.text = [DFToolClass stringISNULL:[_senderDic objectForKey:@"message"]];
            
            _JFPayView.hidden = YES;
            
            self.payBtn.hidden = YES;
        }
    }
    
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

}



#pragma mark - tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"MyTGDetailCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    cell.textLabel.text = [titleArr objectAtIndex:indexPath.row];
    if (_isTG) {
        if (indexPath.row == 0) {
            
            [cell.detailTextLabel setNumberOfLines:0];
            cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
            
            // 测试字串
            NSString *s =[self.senderDic objectForKey:@"goods_title"];
            
            cell.detailTextLabel.text = s;
            
            CGFloat height = [DFToolClass heightOfLabel:s forFont:[UIFont systemFontOfSize:14] labelLength:160];
            
            [cell.detailTextLabel setFrame:CGRectMake(15, 5, KCurrentWidth - 30, height + 15)];
            [cell setFrame:CGRectMake(0, 0, KCurrentWidth, height + 20)];
            
        }
        if (indexPath.row == 1) {
            cell.detailTextLabel.text = [self.senderDic objectForKey:@"goods_price"];
        }
        
        if (indexPath.row == 2) {
            cell.detailTextLabel.text = [self.senderDic objectForKey:@"goods_sum"];
        }
        
        if (indexPath.row == 3) {
            cell.detailTextLabel.text = [self.senderDic objectForKey:@"orderlist_allprice"];
        }

    }
    else
    {
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = @"登封360积分兑换";
        }
        if (indexPath.row == 1) {
            cell.detailTextLabel.text = [_senderDic objectForKey:@"amount"];
        }
        if (indexPath.row == 2) {
            cell.detailTextLabel.text = [_senderDic objectForKey:@"price"];
        }
    }
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)payClick:(id)sender {
    
    if ([[_senderDic objectForKey:@"orderlist_usestatus"] isEqualToString:@"1"]) {
        [_hud show];
        
        NSString *url = @"http://www.df360.cc/df360/api/tuang_order_use";
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *para = @{@"orderid":[_senderDic objectForKey:@"orderlist_id"],@"orderlist_usestatus":[_senderDic objectForKey:@"orderlist_usestatus"]};
        
        [manager GET:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[responseObject objectForKey:@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            
            [alert show];
            
            
            [_hud dismiss];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [_hud dismiss];
        }];

    }
    else
    {
        [_hud show];
        
        NSString *url = @"http://www.df360.cc/df360/api/back_payorder";
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *para = @{@"orderid":[_senderDic objectForKey:@"orderlist_id"]};
        
        NSLog(@"%@",para);
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        
        [manager POST:url parameters:para success:^(AFHTTPRequestOperation *operation,id responseObject){
            NSLog(@"json:%@",responseObject);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[responseObject objectForKey:@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            
            [alert show];
            [self.navigationController popViewControllerAnimated:YES];

            [_hud dismiss];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            NSLog(@"error:%@",error);
            [_hud dismiss];
        }];
    }
}
@end
