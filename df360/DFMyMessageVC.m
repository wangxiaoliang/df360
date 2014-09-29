//
//  DFMyMessageVC.m
//  df360
//
//  Created by wangxl on 14-9-28.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFMyMessageVC.h"
#import "DFCustomTableViewCell.h"
#import "AFNetworking.h"
#import "DFRequestUrl.h"
#import "DFToolView.h"

@interface DFMyMessageVC ()<UITableViewDataSource,UITableViewDelegate,DFHudProgressDelegate>
{
    DFHudProgress *_hud;
    
    NSMutableArray *_myMessageArr;
    
    NSInteger _page;
}
@end

@implementation DFMyMessageVC

- (void)viewDidLoad {
    self.WTitle = @"我发布的信息";
    self.WLeftBarStyle = LeftBarStyleDefault;
    self.WRightBarStyle = RightBarStyleNone;

    _myMessageArr = [[NSMutableArray alloc] init];
    _hud = [[DFHudProgress alloc] init];
    _hud.delegate = self;
    _page = 0;

    [self getMyMessageData];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)getMyMessageData
{
    [_hud show];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    [manager GET:[DFRequestUrl getMyInfoWithPage:[NSString stringWithFormat:@"%ld", _page] withUid:[ud objectForKey:@"uid"]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"TopJSON: %@", responseObject);
        _myMessageArr = [responseObject objectForKey:@"data"];
        [_hud dismiss];
        [self buildUI];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSLog(@"operation: %@",operation);
        [_hud dismiss];
        
        
    }];

}

- (void)buildUI
{
    UITableView *tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KCurrentWidth, KCurrentHeight) style:UITableViewStylePlain];
    
    tabelView.backgroundColor = [UIColor whiteColor];
    
    tabelView.dataSource = self;
    
    tabelView.delegate = self;
    
    [self.view addSubview:tabelView];
}

#pragma mark - tableViewDetelate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _myMessageArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"MyMessageCell";
    
    DFCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[DFCustomTableViewCell alloc] init];
        [cell initMySendMessageCell];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell reloadMySendMessageWithArray:_myMessageArr WithIndex:indexPath.row];
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
