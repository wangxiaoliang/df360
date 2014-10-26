//
//  DFQSBKVC.m
//  df360
//
//  Created by wangxl on 14-9-14.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFQSBKVC.h"
#import "DFCustomTableViewCell.h"
#import "AFNetworking.h"
#import "DFRequestUrl.h"
#import "DFToolView.h"
#import "RefreshView.h"
#import "DFSendQBVC.h"
#import "DFQBDetailVC.h"
#import "DFToolClass.h"

@interface DFQSBKVC ()<UITableViewDataSource,UITableViewDelegate,DFHudProgressDelegate,UIActionSheetDelegate>
{
    NSInteger _page;
    
    NSArray *_fidArr;
    
    NSMutableArray *_QSArr;
    
    DFHudProgress *_hud;
    
    NSInteger _requestCounts;
    
    NSMutableArray *_btnArr;
}
@end

@implementation DFQSBKVC

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
    
    _requestCounts = 2;
    
    _fidArr = [[NSArray alloc] init];
    
    _btnArr = [[NSMutableArray alloc] init];
    
    UISearchBar *search = (UISearchBar *)[self.navigationController.navigationBar viewWithTag:1];
    search.hidden = YES;
    
    self.WTitle = @"夜猫基地";
    self.WLeftBarStyle = LeftBarStyleDefault;
    self.WRightBarStyle = RightBarStyleNone;
    
    
    _hud = [[DFHudProgress alloc] init];
    
    _hud.delegate = self;
    
    [self requestQSWithFid:@"2"];
    
    [self requestQBFid];
    
//    [self buildUI];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)buildUI
{
    /****** 顶部tabBar ******/
    
    self.view.backgroundColor = [UIColor whiteColor];

    
    NSArray *titleImg = @[@"QSBL",@"XHBK",@"QGSM",@"BNSDMM"];
    
    for (int i = 0; i < 4 ; i++) {
        
        UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [topBtn setFrame:CGRectMake((KCurrentWidth/4)*i, 0, KCurrentWidth/4, 40)];
        topBtn.tag = i;
        if (i == 0) {
            topBtn.backgroundColor = [DFToolClass getColor:@"f4f4f4"];
        }
        else
        {
            topBtn.backgroundColor = [UIColor whiteColor];
        }
        [topBtn addTarget:self action:@selector(topBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        [_btnArr addObject:topBtn];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake((KCurrentWidth/4)/2 - 10, 0, 20 , 20)];
        
        image.backgroundColor = [UIColor clearColor];
        
        [image setImage:[UIImage imageNamed:[titleImg objectAtIndex:i]]];
        
        [topBtn addSubview:image];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, KCurrentWidth/4, 20)];
        
        title.text = [[_fidArr objectAtIndex:i] objectForKey:@"c_name"];
        
        title.font = [UIFont systemFontOfSize:12];
        
        title.numberOfLines = 2;
        
        title.textAlignment = NSTextAlignmentCenter;
        
        [topBtn addSubview:title];
        
        [self.view addSubview:topBtn];
        
        
    }
    
//    for (int i = 1; i < 4; i ++) {
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((KCurrentWidth/4)*i, 0, 0.5, 40)];
//        
//        lineView.backgroundColor = [UIColor lightGrayColor];
//        
//        [self.view addSubview:lineView];
//    }
    
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, KCurrentWidth, 0.5)];
    
    line.backgroundColor = [UIColor lightGrayColor];
    
    line.alpha = 0.2f;
    
    [self.view addSubview:line];
    
    
    /****** 底部发布按钮 ******/
    UIButton *downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [downBtn setFrame:CGRectMake(0, KCurrentHeight - 40, KCurrentWidth, 40)];
    
    downBtn.backgroundColor = [UIColor orangeColor];
    
    [downBtn setTitle:@"投稿" forState:UIControlStateNormal];
    
    [downBtn addTarget:self action:@selector(sendQS) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:downBtn];
    
    
    /************ tableView ************/
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40.5, KCurrentWidth, KCurrentHeight - 144) style:UITableViewStylePlain];
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    tableView.tag = 110;
    
    tableView.backgroundColor = [UIColor clearColor];
    
    [self setExtraCellLineHidden:tableView];

    
    [self.view addSubview:tableView];
    
}

#pragma mark - 请求糗事信息
- (void)requestQBFid
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[DFRequestUrl getQBFid] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        _fidArr = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"data"]];
        
        _requestCounts -= 1;
        
        if (_requestCounts == 0) {
            [self buildUI];

            [_hud dismiss];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);

        _requestCounts -= 1;
        
        if (_requestCounts == 0) {
            
            [_hud dismiss];
        }

        
    }];
}

#pragma mark - 请求糗事信息
- (void)requestQSWithFid:(NSString *)fid
{
    
    [_hud show];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[DFRequestUrl getQBInfoWithFid:fid withPage:_page] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        _QSArr = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"data"]];
        
        
        _requestCounts -= 1;
        
        if (_requestCounts == 0) {
            [self buildUI];
            [_hud dismiss];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        _requestCounts -= 1;
        
        if (_requestCounts == 0) {
            [_hud dismiss];
            
        }
    }];
}

- (void)requestQSAgainWithFid:(NSString *)fid
{
    [_hud show];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[DFRequestUrl getQBInfoWithFid:fid withPage:_page] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        [_QSArr removeAllObjects];
        
        _QSArr = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"data"]];
        
        UITableView *tableView = (UITableView *)[self.view viewWithTag:110];
        
        [tableView reloadData];
        
        [_hud dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
            [_hud dismiss];
            
    }];

}

#pragma mark - 导航栏按钮事件
- (void)topBtnSelected:(UIButton *)sender
{
    NSInteger tag = [sender tag];
    
    for (UIButton *btn in _btnArr) {
        btn.backgroundColor = [UIColor whiteColor];
    }
    sender.backgroundColor = [DFToolClass getColor:@"f4f4f4"];
    
    _page = 0;
    
    [self requestQSAgainWithFid:[[_fidArr objectAtIndex:tag] objectForKey:@"c_id"]];
    
    
}

#pragma mark - 发布糗事
- (void)sendQS
{
    
    UIActionSheet *action  = [[UIActionSheet alloc] initWithTitle:@"分类" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:[[_fidArr objectAtIndex:0] objectForKey:@"c_name"],[[_fidArr objectAtIndex:1] objectForKey:@"c_name"],[[_fidArr objectAtIndex:2] objectForKey:@"c_name"],[[_fidArr objectAtIndex:3] objectForKey:@"c_name"], nil];
    [action showInView:self.view];
    
    
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 4) {
        [self performSegueWithIdentifier:@"sendQB" sender:[_fidArr objectAtIndex:buttonIndex]];
    }

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"sendQB"]) {
        DFSendQBVC *sendQB = (DFSendQBVC *)segue.destinationViewController;
        sendQB.fid = sender;
    }
    
    if ([segue.identifier isEqualToString:@"QBDetail"]) {
        DFQBDetailVC *detail = (DFQBDetailVC *)segue.destinationViewController;
        detail.tid = sender;
    }

}

#pragma mark - tableViewDelegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_QSArr count] == 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else
    {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return [_QSArr count];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identfy = @"QSCell";
    DFCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identfy];
    if (!cell) {
        cell = [[DFCustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfy];
        [cell initQBCell];
    }
    [cell reloadQBCellWithArray:_QSArr withIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"QBDetail" sender:[[_QSArr objectAtIndex:indexPath.row] objectForKey:@"tid"]];
}

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
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
