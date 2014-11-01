//
//  DFLoginVC.m
//  df360
//
//  Created by wangxl on 14-9-14.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFLoginVC.h"
#import "DFToolClass.h"
#import "AFNetworking.h"
#import "DFRequestUrl.h"
#import "DFToolView.h"

@interface DFLoginVC ()<UITextFieldDelegate,DFHudProgressDelegate>
{
    UITextField *_userNameTextField;
    UITextField *_passwordTextField;
    
    DFHudProgress *_hud;
}
@end

@implementation DFLoginVC

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
    _hud = [[DFHudProgress alloc] init];
    
    _hud.delegate = self;
    
    self.WTitle = @"登陆";
    self.WLeftBarStyle = LeftBarStyleDefault;
    self.WRightBarStyle = RightBarStyleNone;

    UISearchBar *search = (UISearchBar *)[self.navigationController.navigationBar viewWithTag:1];
    search.hidden = YES;
    
    [self buildUI];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)buildUI
{
    CGFloat deltaHeight = 0;
    if (kOSVersion >= 7.0) {
        deltaHeight = 64;
    }

    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIButton *registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];

    
    
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    
    [registerBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    [registerBtn addTarget:self action:@selector(registe) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarItm = [[UIBarButtonItem alloc] initWithCustomView:registerBtn];
    
    self.navigationItem.rightBarButtonItem = rightBarItm;
    
    
    UIImageView *backImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KCurrentWidth, KCurrentHeight)];
    [backImgView setImage:[UIImage imageNamed:@"login_bg"]];
    [self.view addSubview:backImgView];
    
    UIView *bgTextView = [[UIView alloc] initWithFrame:CGRectMake(20, 40 + deltaHeight, 280, 80)];
    
    bgTextView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:bgTextView];
    
    _userNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, 260, 39.5)];
    _userNameTextField.placeholder = @"用户名:  用户名/邮箱";
    _userNameTextField.font = [UIFont systemFontOfSize:16];
    _userNameTextField.returnKeyType = UIReturnKeyNext;
    _userNameTextField.delegate = self;
    [bgTextView addSubview:_userNameTextField];
    
    UIView *textLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, 280, 0.5)];
    textLineView.backgroundColor = [DFToolClass getColor:@"bfbfbf"];
    [bgTextView addSubview:textLineView];
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 40, 260, 39.5)];
    _passwordTextField.placeholder = @"密码:     请输入密码";
    _passwordTextField.font = [UIFont systemFontOfSize:16];
    _passwordTextField.returnKeyType = UIReturnKeyDone;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.delegate = self;
    [bgTextView addSubview:_passwordTextField];
    
    textLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 79.5, 280, 0.5)];
    textLineView.backgroundColor = [DFToolClass getColor:@"bfbfbf"];
    [bgTextView addSubview:textLineView];

    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(20, 250, 280, 36);
    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"movdet_btn.png"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"movdet_btn_press.png"] forState:UIControlStateHighlighted];
    loginBtn.backgroundColor = [UIColor lightGrayColor];
    [loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:loginBtn];
    
    UIButton *otherLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    otherLoginBtn.frame = CGRectMake(20, 300, 280, 36);
    [otherLoginBtn setTitle:@"QQ登录(使用百度的第三方登录)" forState:UIControlStateNormal];
    [otherLoginBtn setBackgroundImage:[UIImage imageNamed:@"movdet_btn.png"] forState:UIControlStateNormal];
    [otherLoginBtn setBackgroundImage:[UIImage imageNamed:@"movdet_btn_press.png"] forState:UIControlStateHighlighted];
    otherLoginBtn.backgroundColor = [UIColor lightGrayColor];
    [otherLoginBtn addTarget:self action:@selector(otherLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:otherLoginBtn];

    
}

#pragma mark - 注册
- (void)registe
{
    [self performSegueWithIdentifier:@"register" sender:nil];
}

#pragma mark - 登陆
- (void)login:(UIButton *)sender
{
    
    [_hud show];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *para = @{@"username":_userNameTextField.text,@"password":_passwordTextField.text};
    
    NSLog(@"%@",para);
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager POST:[DFRequestUrl loginUrl] parameters:para success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSLog(@"json:%@",responseObject);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[[responseObject objectForKey:@"data"] objectForKey:@"uid"] forKey:@"uid"];
        [defaults setObject:[[responseObject objectForKey:@"data"] objectForKey:@"email"] forKey:@"email"];
        
        
        [self saveUserInfo];
        
        [_hud dismiss];
        
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error:%@",error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登陆失败" message:@"用户名或密码错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        [_hud dismiss];
    }];
}

#pragma mark - 第三方登陆
- (void)otherLogin:(UIButton *)sender
{
    [_hud show];
    
    NSString *url = @"http://www.df360.cc/df360/api/ptest";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *para = @{@"username":_userNameTextField.text,@"password":_passwordTextField.text};
    
    NSLog(@"%@",para);
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager POST:url parameters:para success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSLog(@"json:%@",responseObject);
        
        [_hud dismiss];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error:%@",error);
        [_hud dismiss];
    }];

}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _userNameTextField) {
        [_passwordTextField becomeFirstResponder];
    }
        else
    {
        [_passwordTextField resignFirstResponder];
    }
    return YES;
}

- (void)saveUserInfo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:_userNameTextField.text forKey:@"username"];
    [defaults setObject:_passwordTextField.text forKey:@"password"];
        
    [self.navigationController popViewControllerAnimated:YES];
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
