//
//  DFUserCenterVC.m
//  df360
//
//  Created by wangxl on 14-9-2.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFUserCenterVC.h"
#import "DFToolClass.h"
#import "DFSelectFatherCateVC.h"

#define loginTag   2001
#define logoutTag  2002
#define nameTag    2003

@interface DFUserCenterVC()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSArray *titleArr;
    
    UIView *_topView;
}
@end

@implementation DFUserCenterVC

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
    self.WLeftBarStyle = LeftBarStyleDefault;
    self.WRightBarStyle = RightBarStyleNone;
    self.WTitle = @"个人中心";
    [self buildUI];
    titleArr = [[NSArray alloc] initWithObjects:@"发布消息",@"我发布的消息",@"我的置顶信息",@"资料设置",@"积分充值",@"赚取人民币说明", nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)buildUI
{
    
    UISearchBar *search = (UISearchBar *)[self.navigationController.navigationBar viewWithTag:1];
    search.hidden = YES;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KCurrentWidth, 80)];
    _topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_topView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    imageView.backgroundColor = [UIColor clearColor];
    
    imageView.image = [UIImage imageNamed:@"personImg"];
    
    [_topView addSubview:imageView];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(60, 20, 100, 40)];
    loginBtn.tag = loginTag;
    
    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:loginBtn];

    
    UIButton *nameBtn = [[UIButton alloc] initWithFrame:CGRectMake(60, 20, 100, 40)];
    nameBtn.tag = nameTag;
    [nameBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *name = [defaults objectForKey:@"username"];
    
    [nameBtn setTitle:name forState:UIControlStateNormal];
    [_topView addSubview:nameBtn];
    
    UIButton *logout = [UIButton buttonWithType:UIButtonTypeCustom];
    logout.tag = logoutTag;
    logout.frame = CGRectMake(20, 400, 280, 36);
    [logout setTitle:@"注销" forState:UIControlStateNormal];
    [logout setBackgroundImage:[UIImage imageNamed:@"movdet_btn.png"] forState:UIControlStateNormal];
    [logout setBackgroundImage:[UIImage imageNamed:@"movdet_btn_press.png"] forState:UIControlStateHighlighted];
    logout.backgroundColor = [UIColor lightGrayColor];
    [logout addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logout];



    if ([DFToolClass isLogin]) {
        loginBtn.hidden = YES;
        
    }
    
    else
    {
        nameBtn.hidden = YES;
        logout.hidden = YES;
    }
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, KCurrentWidth, 44 * 6) style:UITableViewStylePlain];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tableView];
    
    
}

- (void)login
{
    [self performSegueWithIdentifier:@"login" sender:nil];
}

- (void)logout
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要注销吗？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消",nil];
    
    [alert show];
    
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSUserDefaults *defult = [NSUserDefaults standardUserDefaults];
        
        [defult removeObjectForKey:@"username"];
        [defult removeObjectForKey:@"passwork"];
        [defult removeObjectForKey:@"uid"];
        
        UIButton *nameBtn = (UIButton *)[_topView viewWithTag:nameTag];
        
        nameBtn.hidden = YES;
        
        UIButton *loginBtn = (UIButton *)[_topView viewWithTag:loginTag];
        
        loginBtn.hidden = NO;
        
        UIButton *logoutBtn = (UIButton *)[self.view viewWithTag:logoutTag];
        
        logoutBtn.hidden = YES;
    }
    
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"userCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    cell.textLabel.text = [titleArr objectAtIndex:indexPath.row];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *identifyArr = @[@"userCenterPushSelectFather",@"myMessage",@"myTopMessage",@"userInfoSetting",@"supplement"];
    
    if (indexPath.row == 0) {
        
        [self performSegueWithIdentifier:[identifyArr objectAtIndex:indexPath.row] sender:self.allCates];
        
    }
    
    else if (indexPath.row == 5)
    {
        
    }
    
    else
    {
        [self performSegueWithIdentifier:[identifyArr objectAtIndex:indexPath.row] sender:nil];
    }

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"userCenterPushSelectFather"]) {
        DFSelectFatherCateVC *selectFather = (DFSelectFatherCateVC *)segue.destinationViewController;
        selectFather.allCates = sender;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    
    UIButton *nameBtn = (UIButton *)[_topView viewWithTag:nameTag];
    
    
    UIButton *loginBtn = (UIButton *)[_topView viewWithTag:loginTag];
    
    
    UIButton *logoutBtn = (UIButton *)[self.view viewWithTag:logoutTag];
    
    if ([DFToolClass isLogin]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSString *name = [defaults objectForKey:@"username"];
        
        [nameBtn setTitle:name forState:UIControlStateNormal];

        loginBtn.hidden = YES;
        logoutBtn.hidden = NO;
        nameBtn.hidden = NO;
    }
    
    else
    {
        nameBtn.hidden = YES;
        logoutBtn.hidden = YES;
        loginBtn.hidden = NO;
    }

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
