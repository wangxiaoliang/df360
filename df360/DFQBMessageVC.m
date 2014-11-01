//
//  DFQBMessageVC.m
//  df360
//
//  Created by wangxl on 14/10/22.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFQBMessageVC.h"
#import "DFToolView.h"
#import "DFToolClass.h"
#import "AFNetworking.h"
#import "DFRequestUrl.h"
#import "DFCustomTableViewCell.h"
#import "MJRefresh.h"

@interface DFQBMessageVC ()<DFHudProgressDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _page;
    
    DFHudProgress *_hud;
    
    NSMutableArray *_messageArr;
    
    BOOL _firstRequest;
    
    BOOL _needRequest;
    
    UITableView *_tableView;

}
@end

@implementation DFQBMessageVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    _page = 0;
    
    _hud = [[DFHudProgress alloc] init];
    
    _hud.delegate = self;
    
    _messageArr = [[NSMutableArray alloc] init];
    
    _firstRequest = YES;
    _needRequest = YES;

    
    self.WTitle = @"留言";
    self.WLeftBarStyle = LeftBarStyleDefault;
    self.WRightBarStyle = RightBarStyleClick;
    
    [self getMessage];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)getMessage
{
    if (_firstRequest) {
        [_hud show];
    }

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[DFRequestUrl getQBMessageWithTid:self.tid withPage:[NSString stringWithFormat:@"%d",_page]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSArray *moreArr = [responseObject objectForKey:@"data"];
        
        for (NSDictionary *dic in moreArr) {
            [_messageArr addObject:dic];
        }
        
        if (moreArr.count != 10) {
            _needRequest = false;
        }
        if (_firstRequest) {
            _firstRequest = false;
            
            [self buildUI];
        }
        else
        {
            [_tableView reloadData];
        }
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        [_hud dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        
        [_hud dismiss];
    }];

}

- (void)buildUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KCurrentWidth, KCurrentHeight) style:UITableViewStylePlain];
    
    _tableView.backgroundColor = [UIColor whiteColor];
    
    _tableView.dataSource = self;
    
    _tableView.delegate = self;
    
    _tableView.tag = 10001;
    
    [self setExtraCellLineHidden:_tableView];
    
    __block DFQBMessageVC *blockSelf = self;
    [_tableView addHeaderWithCallback:^{
        blockSelf -> _page = 0;
        blockSelf -> _needRequest = YES;
        [blockSelf -> _messageArr removeAllObjects];
        [blockSelf getMessage];
    }];
    
    
    [_tableView addFooterWithCallback:^{
        if (blockSelf -> _needRequest) {
            blockSelf -> _page++;
            [blockSelf getMessage];
        }
        else
        {
            [blockSelf -> _tableView footerEndRefreshing];
        }
    }];
    
    [self.view addSubview:_tableView];
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_messageArr count] == 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else
    {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    
    return [_messageArr count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:(UITableView *)[self.view viewWithTag:10001] cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"QBDetailCell";
    
    DFCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[DFCustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        
        [cell initQBMessageCell];
        
    }
    
    [cell reloadQBMessageWithArray:_messageArr withIndex:indexPath.row];
    
    UILabel *message = (UILabel *)[cell viewWithTag:103];
    
    float height = message.frame.size.height;
    
    [cell setFrame:CGRectMake(0, 0, cell.frame.size.width, 50 + height)];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
