//
//  DFMyChangeVC.m
//  df360
//
//  Created by wangxl on 14/11/2.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFMyChangeVC.h"
#import "DFToolClass.h"
#import "DFToolView.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "DFMyTGDetail.h"
#import "DFCustomTableViewCell.h"

@interface DFMyChangeVC ()<UITableViewDataSource,UITableViewDelegate,DFHudProgressDelegate>
{
    UIButton *tgBtn;
    
    UIButton *jfBtn;
    
    BOOL _isTG;
    
    UITableView *_tableView;
    
    NSMutableArray *_dataSource;
    
    NSInteger _page;
    
    DFHudProgress *_hud;
    
    BOOL _firstRequest;
    
    BOOL _needRequest;
    

}
@end

@implementation DFMyChangeVC

- (void)viewDidLoad {
    
    self.WTitle = @"收支明细";
    self.WLeftBarStyle = LeftBarStyleDefault;
    self.WRightBarStyle = RightBarStyleNone;
    
    _dataSource = [[NSMutableArray alloc] init];
    
    _hud = [[DFHudProgress alloc] init];
    
    _isTG = YES;
    
    _firstRequest = YES;
    
    _needRequest = YES;
    
    [self getdataSource];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)buildUI
{
    tgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [tgBtn setFrame:CGRectMake(0, 0, KCurrentWidth/2, 40)];
    
    [tgBtn setTitle:@"团购订单" forState:UIControlStateNormal];
    
    [tgBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    tgBtn.backgroundColor = [UIColor lightGrayColor];
    
    
    tgBtn.selected = YES;
    
    [tgBtn addTarget:self action:@selector(tgBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:tgBtn];
    
    
    jfBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [jfBtn setFrame:CGRectMake(KCurrentWidth/2, 0, KCurrentWidth/2, 40)];
    
    [jfBtn setTitle:@"积分兑换" forState:UIControlStateNormal];
    
    [jfBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    jfBtn.backgroundColor = [UIColor whiteColor];
    
    [jfBtn addTarget:self action:@selector(jfBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:jfBtn];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, KCurrentWidth, KCurrentHeight - 40) style:UITableViewStylePlain];
    
    _tableView.dataSource = self;
    
    _tableView.delegate = self;
    
    __block DFMyChangeVC *blockSelf = self;
    [_tableView addHeaderWithCallback:^{
        blockSelf -> _page = 0;
        blockSelf -> _needRequest = YES;
        
        [blockSelf -> _dataSource removeAllObjects];
        
        [blockSelf getdataSource];
    }];
    
    
    [_tableView addFooterWithCallback:^{
        if (blockSelf -> _needRequest) {
            blockSelf -> _page++;
            [blockSelf getdataSource];
        }
        else
        {
            [blockSelf -> _tableView footerEndRefreshing];
        }
    }];

    [self setExtraCellLineHidden:_tableView];
    
    [self.view addSubview:_tableView];
    
    
    
}

- (void)tgBtnClick
{
    if (tgBtn.selected) {
        return;
    }
    else
    {
        _isTG = YES;
        tgBtn.backgroundColor = [UIColor lightGrayColor];
        
        
        jfBtn.backgroundColor = [UIColor whiteColor];
        
        _dataSource = [NSMutableArray array];
        
        tgBtn.selected = YES;
        
        jfBtn.selected = NO;
        
        [self getdataSource];
        
        
    
    }
}

- (void)jfBtnClick
{
    if (jfBtn.selected) {
        return;
    }
    else
    {
        _isTG = NO;
        
        tgBtn.backgroundColor = [UIColor whiteColor];
        
        jfBtn.backgroundColor = [UIColor lightGrayColor];
        
        _dataSource = [NSMutableArray array];
        
        jfBtn.selected = YES;
        
        tgBtn.selected = NO;
        
        [self getdataSource];
        
        
        
    }
}

- (void)getdataSource
{
    if (_isTG) {
        
        [_hud show];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
        
        NSString *urlStr = [NSString stringWithFormat:@"http://www.df360.cc/df360/api/my_tuanorderlist?member_uid=%@&page=%@",[df objectForKey:@"uid"],[NSString stringWithFormat:@"%d",_page]];
        
        [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [_hud dismiss];
            
            NSLog(@"TopJSON: %@", responseObject);
            
            BOOL status = [[responseObject objectForKey:@"status"] boolValue];
            
            if (!status) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"error"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                
                [alert show];

            }
            
            NSArray *dataArr = [responseObject objectForKey:@"data"];
    
            if (dataArr.count < 10) {
                _needRequest = NO;
            }
            
            for (NSDictionary *dic in dataArr) {
                [_dataSource addObject:dic];
            }
            
            if (_firstRequest) {
                [self buildUI];
                _firstRequest = NO;
            }
            else
            {
                [_tableView reloadData];
            }
            
            [_tableView headerEndRefreshing];
            [_tableView footerEndRefreshing];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            NSLog(@"operation: %@",operation);
            [_hud dismiss];
            [_tableView headerEndRefreshing];
            [_tableView footerEndRefreshing];
            
        }];
    }
    else
    {
        [_hud show];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
        
        NSString *urlStr = [NSString stringWithFormat:@"http://www.df360.cc/df360/api/my_payorderlist?uid=%@&page=%@",[df objectForKey:@"uid"],[NSString stringWithFormat:@"%d",_page]];
        
        [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [_hud dismiss];
            
            NSLog(@"TopJSON: %@", responseObject);
            
            BOOL status = [[responseObject objectForKey:@"status"] boolValue];
            
            if (!status) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"error"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                
                [alert show];
                
            }

            
            NSArray *dataArr = [responseObject objectForKey:@"data"];
            
            if (dataArr.count < 10) {
                _needRequest = NO;
            }
            
            for (NSDictionary *dic in dataArr) {
                [_dataSource addObject:dic];
            }
            
            if (_firstRequest) {
                [self buildUI];
            }
            else
            {
                [_tableView reloadData];
            }
            
            [_tableView headerEndRefreshing];
            [_tableView footerEndRefreshing];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            NSLog(@"operation: %@",operation);
            [_hud dismiss];
            [_tableView headerEndRefreshing];
            [_tableView footerEndRefreshing];
            
        }];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_dataSource count] == 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else
    {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return [_dataSource count];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *identify = @"changeCell";
    
    static NSString *indetify1 = @"jifenCell";
    
    
    if (_isTG) {
        
        DFCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        
        if (!cell) {
            cell = [[DFCustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            [cell initMyTGCell];
        }
        [cell initTGCellWithArray:_dataSource withIndex:indexPath.row];

        return cell;
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indetify1];
        
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetify1];
        [self initJFCell:cell withIndex:indexPath.row];
        if (indexPath.row%2==0) {
            cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        }
    }
    
    return cell;
    
}

- (void)initTGCell:(UITableViewCell *)cell withIndex:(NSInteger)index
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, KCurrentWidth-30, 10)];
    
    [titleLabel setNumberOfLines:0];
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 测试字串
    NSString *s =[DFToolClass stringISNULL:[[_dataSource objectAtIndex:index] objectForKey:@"goods_title"]];
    
    titleLabel.text = s;
    
    CGFloat height = [DFToolClass heightOfLabel:s forFont:[UIFont systemFontOfSize:14] labelLength:160];
    
    [titleLabel setFrame:CGRectMake(15, 5, KCurrentWidth - 30, height + 15)];
   
    [cell addSubview:titleLabel];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, height + 15, 80, 15)];
    
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[DFToolClass stringISNULL:[[_dataSource objectAtIndex:index] objectForKey:@"orderlist_time"]] floatValue]];
    
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yy-MM-dd"];
    NSString *regStr = [df stringFromDate:confromTimesp];
    
    if ([[DFToolClass stringISNULL:[[_dataSource objectAtIndex:index] objectForKey:@"orderlist_time"]] isEqualToString:@""]) {
        regStr = @"";
    }
    
    timeLabel.text = regStr;
    
    timeLabel.textColor = [UIColor lightGrayColor];
    
    timeLabel.font = [UIFont systemFontOfSize:14];
    
    timeLabel.backgroundColor = [UIColor clearColor];
    
    [cell addSubview:timeLabel];
    
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, height + 15, 60, 15)];
    
    NSString *typeStr = @"";
    
    NSString *listStatus = [DFToolClass stringISNULL:[[_dataSource objectAtIndex:index] objectForKey:@"orderlist_usestatus"]];
    
    if ([listStatus isEqualToString:@"2"]) {
        typeStr = @"已支付未消费";
    }
    if ([listStatus isEqualToString:@"1"]) {
        typeStr = @"未支付";
    }
    if ([listStatus isEqualToString:@"3"]) {
        typeStr = @"已付款已消费";
    }
    if ([listStatus isEqualToString:@"4"]) {
        typeStr = @"申请退款中";
    }
    if ([listStatus isEqualToString:@"5"]) {
        typeStr = @"已退款";
    }
    
    typeLabel.text = typeStr;
    
    typeLabel.textColor = [UIColor orangeColor];
    
    typeLabel.font = [UIFont systemFontOfSize:14];
    
    typeLabel.backgroundColor = [UIColor clearColor];
    
    [cell addSubview:typeLabel];
    
    UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, height + 35, 80, 15)];
    
    totalLabel.textColor = [UIColor lightGrayColor];
    
    totalLabel.text = [NSString stringWithFormat:@"总价:%@",[DFToolClass stringISNULL:[[_dataSource objectAtIndex:index] objectForKey:@"goods_price"]]];
    
    totalLabel.font = [UIFont systemFontOfSize:14];
    
    totalLabel.backgroundColor = [UIColor clearColor];
    
    [cell addSubview:totalLabel];
    
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, height + 35, 60, 15)];
    
    numLabel.textColor = [UIColor lightGrayColor];
    
    numLabel.text = [NSString stringWithFormat:@"数量:%@",[DFToolClass stringISNULL:[[_dataSource objectAtIndex:index] objectForKey:@"goods_sum"]]];
    
    numLabel.font = [UIFont systemFontOfSize:14];
    
    numLabel.backgroundColor = [UIColor clearColor];
    
    [cell addSubview:numLabel];
    
    [cell setFrame:CGRectMake(0, 0, KCurrentWidth, height + 60)];

}

- (void)initJFCell:(UITableViewCell *)cell withIndex:(NSInteger)index
{
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 50, 44)];
    numLabel.text = [NSString stringWithFormat:@"%d",index];
    
    numLabel.font = [UIFont systemFontOfSize:14];
    
    [cell addSubview:numLabel];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 100, 44)];
    
    
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[DFToolClass stringISNULL:[[_dataSource objectAtIndex:index] objectForKey:@"submitdate"]] floatValue]];
    
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yy-MM-dd"];
    NSString *regStr = [df stringFromDate:confromTimesp];
    
    if ([[DFToolClass stringISNULL:[[_dataSource objectAtIndex:index] objectForKey:@"submitdate"]] isEqualToString:@""]) {
        regStr = @"";
    }
    
    timeLabel.text = regStr;
    
    timeLabel.font = [UIFont systemFontOfSize:14];
    
    [cell addSubview:timeLabel];
    
    UILabel *momeyLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 50, 44)];
    
    momeyLabel.font = [UIFont systemFontOfSize:14];
    
    momeyLabel.text = [DFToolClass stringISNULL:[[_dataSource objectAtIndex:index] objectForKey:@"price"]];
    
    [cell addSubview:momeyLabel];
    
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(KCurrentWidth - 70, 0, KCurrentWidth - 170, 44)];
    
    typeLabel.font = [UIFont systemFontOfSize:14];
    
    typeLabel.text = [DFToolClass stringISNULL:[[_dataSource objectAtIndex:index] objectForKey:@"status_name"]];
    
    [cell addSubview:typeLabel];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
        
    UIStoryboard *storyboard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DFMyTGDetail *detail = [storyboard instantiateViewControllerWithIdentifier:@"MyTGDetail"];
        
    detail.senderDic = [_dataSource objectAtIndex:indexPath.row];
        
    detail.isTG = _isTG;
        
    [self.navigationController pushViewController:detail animated:YES];
    
}

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
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

@end
