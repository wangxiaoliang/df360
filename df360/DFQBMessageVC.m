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

@interface DFQBMessageVC ()<DFHudProgressDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _page;
    
    DFHudProgress *_hud;
    
    NSArray *_messageArr;
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
    
    _messageArr = [[NSArray alloc] init];
    
    self.WTitle = @"留言";
    self.WLeftBarStyle = LeftBarStyleDefault;
    self.WRightBarStyle = RightBarStyleClick;
    
    [self getMessage];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)getMessage
{
    [_hud show];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[DFRequestUrl getQBMessageWithTid:self.tid withPage:[NSString stringWithFormat:@"%ld",_page]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        _messageArr = [responseObject objectForKey:@"data"];
    
        
        [self buildUI];
        
        [_hud dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        
        [_hud dismiss];
    }];

}

- (void)buildUI
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KCurrentWidth, KCurrentHeight) style:UITableViewStylePlain];
    
    tableView.backgroundColor = [UIColor whiteColor];
    
    tableView.dataSource = self;
    
    tableView.delegate = self;
    
    tableView.tag = 10001;
    
    [self setExtraCellLineHidden:tableView];
    
    [self.view addSubview:tableView];
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
