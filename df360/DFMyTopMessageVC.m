//
//  DFMyTopMessageVC.m
//  df360
//
//  Created by wangxl on 14-9-28.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFMyTopMessageVC.h"
#import "DFCustomTableViewCell.h"
#import "DFRequestUrl.h"
#import "DFToolView.h"
#import "AFNetworking.h"

@interface DFMyTopMessageVC ()<UITableViewDelegate,UITableViewDataSource,DFHudProgressDelegate>
{
    DFHudProgress *_hud;
    NSMutableArray *_topArr;
    NSInteger _page;
}
@end

@implementation DFMyTopMessageVC

- (void)viewDidLoad {
    
    self.WTitle = @"我的置顶信息";
    self.WLeftBarStyle = LeftBarStyleDefault;
    self.WRightBarStyle = RightBarStyleNone;

    _page = 0;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)buildUI
{
    UITableView *tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KCurrentWidth, KCurrentHeight) style:UITableViewStylePlain];
    
    tabelView.backgroundColor = [UIColor whiteColor];
    
    tabelView.dataSource = self;
    
    tabelView.delegate = self;
    
    [self.view addSubview:tabelView];
}

- (void)getMyMessageData
{
    [_hud show];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    [manager GET:[DFRequestUrl getInfoUpWithUid:[ud objectForKey:@"uid"] withPage:[NSString stringWithFormat:@"%ld", _page]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"TopJSON: %@", responseObject);
        _topArr = [responseObject objectForKey:@"data"];
        [_hud dismiss];
        [self buildUI];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSLog(@"operation: %@",operation);
        [_hud dismiss];
        
        
    }];
    
}


#pragma mark - tableViewDetelate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _topArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"MyTopMessageCell";
    
    DFCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[DFCustomTableViewCell alloc] init];
        [cell initMySendMessageCell];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell reloadMySendMessageWithArray:_topArr WithIndex:indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
