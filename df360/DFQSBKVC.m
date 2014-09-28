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

@interface DFQSBKVC ()<UITableViewDataSource,UITableViewDelegate,DFHudProgressDelegate,UIActionSheetDelegate>
{
    NSInteger _page;
    
    NSArray *_fidArr;
    
    NSMutableArray *_QSArr;
    
    DFHudProgress *_hud;
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
    
    _fidArr = [[NSArray alloc] initWithObjects:@"2",@"36",@"37",@"38", nil];
    
    UISearchBar *search = (UISearchBar *)[self.navigationController.navigationBar viewWithTag:1];
    search.hidden = YES;
    
    self.WTitle = @"夜猫基地";
    self.WLeftBarStyle = LeftBarStyleDefault;
    self.WRightBarStyle = RightBarStyleNone;
    
    
    _hud = [[DFHudProgress alloc] init];
    
    _hud.delegate = self;
    
    [self requestQSWithFid:@"2"];
    
//    [self buildUI];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)buildUI
{
    /****** 顶部tabBar ******/
    
    NSArray *titleArr = @[@"糗事爆料",@"笑话百科",@"情感私密",@"不能说的秘密"];
    
    for (int i = 0; i < 4 ; i++) {
        UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [topBtn setFrame:CGRectMake((KCurrentWidth/4)*i, 0, KCurrentWidth/4, 40)];
        topBtn.tag = i;
        topBtn.backgroundColor = [UIColor whiteColor];
        [topBtn addTarget:self action:@selector(topBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 20 , 20)];
        
        image.backgroundColor = [UIColor lightGrayColor];
        
        [topBtn addSubview:image];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, KCurrentWidth/4-20, 40)];
        
        title.text = [titleArr objectAtIndex:i];
        
        title.font = [UIFont systemFontOfSize:12];
        
        title.numberOfLines = 2;
        
        title.textAlignment = NSTextAlignmentCenter;
        
        [topBtn addSubview:title];
        
        [self.view addSubview:topBtn];
        
        
    }
    
    for (int i = 1; i < 4; i ++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((KCurrentWidth/4)*i, 0, 0.5, 40)];
        
        lineView.backgroundColor = [UIColor blackColor];
        
        [self.view addSubview:lineView];
    }
    
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, KCurrentWidth, 0.5)];
    
    line.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:line];
    
    
    /****** 底部发布按钮 ******/
    UIButton *downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [downBtn setFrame:CGRectMake(0, KCurrentHeight - 40, KCurrentWidth, 40)];
    
    downBtn.backgroundColor = [UIColor redColor];
    
    [downBtn setTitle:@"投稿" forState:UIControlStateNormal];
    
    [downBtn addTarget:self action:@selector(sendQS) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:downBtn];
    
    
    /************ tableView ************/
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, KCurrentWidth, KCurrentHeight - 154) style:UITableViewStylePlain];
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    tableView.backgroundColor = [UIColor clearColor];
    

    
    [self.view addSubview:tableView];
    
}

#pragma mark - 请求糗事信息
- (void)requestQSWithFid:(NSString *)fid
{
    
    [_hud show];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[DFRequestUrl getQBInfoWithFid:fid withPage:_page] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        _QSArr = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"data"]];
        
        
        [self buildUI];
        
        [_hud dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        
        [_hud dismiss];
    }];
}

#pragma mark - 导航栏按钮事件
- (void)topBtnSelected:(UIButton *)sender
{
    
}

#pragma mark - 发布糗事
- (void)sendQS
{
    UIActionSheet *action  = [[UIActionSheet alloc] initWithTitle:@"分类" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"糗事爆料",@"笑话百科",@"情感私密",@"不能说的秘密", nil];
    [action showInView:self.view];
    
    
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self performSegueWithIdentifier:@"sendQB" sender:[_fidArr objectAtIndex:buttonIndex]];

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
