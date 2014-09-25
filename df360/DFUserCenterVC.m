//
//  DFUserCenterVC.m
//  df360
//
//  Created by wangxl on 14-9-2.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFUserCenterVC.h"
#import "DFToolClass.h"

@interface DFUserCenterVC()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *titleArr;
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

    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KCurrentWidth, 80)];
    topView.backgroundColor = [UIColor brownColor];
    [self.view addSubview:topView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    imageView.backgroundColor = [UIColor orangeColor];
    [topView addSubview:imageView];
    
    if ([DFToolClass isLogin]) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSString *name = [defaults objectForKey:@"username"];
        
        UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(80, 20, 100, 40)];
        [loginBtn setTitle:name forState:UIControlStateNormal];
        [topView addSubview:loginBtn];
        
        
    }
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(80, 20, 60, 40)];
    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:loginBtn];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, KCurrentWidth, 500) style:UITableViewStylePlain];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tableView];
    
    
}

- (void)login
{
    [self performSegueWithIdentifier:@"login" sender:nil];
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
