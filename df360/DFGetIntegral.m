//
//  DFGetIntegral.m
//  df360
//
//  Created by wangxl on 14/10/28.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFGetIntegral.h"
#import "DFToolView.h"
#import "DFRequestUrl.h"
#import "DFIntegralCell.h"
#import "AFNetworking.h"

@interface DFGetIntegral ()<UITableViewDataSource,UITableViewDelegate,DFHudProgressDelegate>
{
    NSMutableArray *_dataArr;
    
    NSInteger _page;
    
    DFHudProgress *_hud;
}
@end

@implementation DFGetIntegral

- (void)viewDidLoad {
    
    self.WTitle = @"挣取积分";
    self.WLeftBarStyle = LeftBarStyleDefault;
    self.WRightBarStyle = RightBarStyleNone;
    
    _hud = [[DFHudProgress alloc] init];
    
    _dataArr = [[NSMutableArray alloc] init];
    
    self.tableView.hidden = YES;
    
    [self getRole];
    [self.tableView registerNib:[DFIntegralCell nib] forCellReuseIdentifier:@"integralCell"];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)getRole
{
    [_hud show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[DFRequestUrl jifenrole] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [_hud dismiss];
        
        NSLog(@"TopJSON: %@", responseObject);
        
        _dataArr = [responseObject objectForKey:@"data"];
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self.tableView.hidden = NO;
        
        [self.tableView reloadData];
        

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSLog(@"operation: %@",operation);
        [_hud dismiss];
        
        
    }];
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DFIntegralCell *cell = [tableView dequeueReusableCellWithIdentifier:@"integralCell"];
    
    
    cell.titleLabel.text = [[_dataArr objectAtIndex:indexPath.row] objectForKey:@"rulename"];
    
    cell.fwLabel.text = [[_dataArr objectAtIndex:indexPath.row] objectForKey:@"cycletype"];
    
    cell.timeLabel.text = [[_dataArr objectAtIndex:indexPath.row] objectForKey:@"rewardnum"];
    
    cell.momeyLabel.text = [[_dataArr objectAtIndex:indexPath.row] objectForKey:@"extcredits2"];
    
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

@end
