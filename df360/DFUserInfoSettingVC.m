//
//  DFUserInfoSettingVC.m
//  df360
//
//  Created by wangxl on 14-9-28.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFUserInfoSettingVC.h"
#import "DFCustomTableViewCell.h"
#import "DFToolView.h"
#import "AFNetworking.h"


@interface DFUserInfoSettingVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,DFHudProgressDelegate>
{
    NSArray *_titleArr;
    NSString *_nameStr;
    NSString *_telStr;
    NSString *_QQStr;
    NSString *_emailStr;
    NSString *_addressStr;
    NSString *_uid;
    
    DFHudProgress *_hud;
}
@end

@implementation DFUserInfoSettingVC

- (void)viewDidLoad {
    self.WTitle = @"资料设置";
    self.WLeftBarStyle = LeftBarStyleDefault;
    self.WRightBarStyle = RightBarStyleNone;

    [self initParaData];
    
    _titleArr = [[NSArray alloc] initWithObjects:@"姓名         *",@"联系电话  *",@"联系QQ",@"联系邮箱",@"联系地址", nil];
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    
    _nameStr = [df objectForKey:@"username"];
    _emailStr = [df objectForKey:@"email"];
    _uid = [df objectForKey:@"uid"];
    
    _hud = [[DFHudProgress alloc] init];
    
    _hud.delegate = self;
    
    [self buildUI];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)initParaData
{
    _nameStr = @"";
    _telStr = @"";
    _QQStr = @"";
    _emailStr = @"";
    _addressStr = @"";
    _uid = @"";
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
    
    [btn addTarget:self action:@selector(modifyUserInfo) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
}

- (void)modifyUserInfo
{
    if ([_nameStr isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"姓名不能为空!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alert show];
    }
    if ([_telStr isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"联系电话不能为空!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alert show];

    }
    else
    {
        [_hud show];
        
        NSString *url = @"http://www.df360.cc/df360/api/info_member";
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        
        
        NSDictionary *para = @{@"member_uid":_uid,@"member_title":_nameStr,@"member_phone":_telStr,@"member_qq":_QQStr,@"member_address":_addressStr};
        
        
        
        NSLog(@"%@",para);
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        
        [manager POST:url parameters:para success:^(AFHTTPRequestOperation *operation,id responseObject){
            NSLog(@"json:%@",responseObject);
            
            [_hud dismiss];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"修改成功!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            
            [alert show];
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            
            [_hud dismiss];
            
            NSLog(@"operation:%@",operation);
            
            NSLog(@"error:%@",error);
        }];
    }

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
    if (indexPath.row == 0) {
        textField.text = _nameStr;
    }
    if (indexPath.row == 3) {
        textField.text = _emailStr;
    }
    return cell;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"%d",textField.tag);
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.tag == 1000)
    {
        _nameStr = textField.text;
    }
    if (textField.tag == 1001) {
        _telStr = textField.text;
    }
    if (textField.tag == 1002) {
        _QQStr = textField.text;
    }
    
    if (textField.tag == 1003) {
        _emailStr = textField.text;
    }
    
    if (textField.tag == 1004) {
        _addressStr = textField.text;
    }

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
