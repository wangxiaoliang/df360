//
//  DFUserInfoSettingVC.m
//  df360
//
//  Created by wangxl on 14-9-28.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFUserInfoSettingVC.h"
#import "DFCustomTableViewCell.h"

@interface DFUserInfoSettingVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSArray *_titleArr;
}
@end

@implementation DFUserInfoSettingVC

- (void)viewDidLoad {
    self.WTitle = @"资料设置";
    self.WLeftBarStyle = LeftBarStyleDefault;
    self.WRightBarStyle = RightBarStyleNone;

    _titleArr = [[NSArray alloc] initWithObjects:@"姓名         *",@"联系电话  *",@"联系QQ",@"联系邮箱",@"联系地址", nil];
    
    [self buildUI];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)buildUI
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, KCurrentWidth, 220) style:UITableViewStylePlain];
    
    tableView.backgroundColor = [UIColor whiteColor];
    
    tableView.allowsSelection = NO;
    
    tableView.scrollEnabled = NO;
    
    tableView.dataSource = self;
    
    tableView.delegate = self;
    
    [self.view addSubview:tableView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(60, 260, KCurrentWidth - 120, 30);
    
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    btn.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:btn];
    
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"ModifyInfoCell";
    
    DFCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[DFCustomTableViewCell alloc] init];
        [cell initModifyUserInfoCellWithTitleArray:_titleArr Index:indexPath.row];
    }
    
    UITextField *textField = (UITextField *)[cell viewWithTag:indexPath.row + 1000];
    textField.delegate = self;
    return cell;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"%ld",textField.tag);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
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
