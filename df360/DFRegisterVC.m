//
//  DFRegisterVC.m
//  df360
//
//  Created by wangxl on 14-9-14.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFRegisterVC.h"
#import "DFToolClass.h"
#import "DFRequestUrl.h"
#import "AFNetworking.h"

@interface DFRegisterVC ()<UITextFieldDelegate>
{
    UITextField *_userNameTextField;
    UITextField *_emailTextField;
    UITextField *_telTextField;
    UITextField *_passwordTextField;
    UITextField *_confirmPasswordTextField;
}
@end

@implementation DFRegisterVC

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
    self.WTitle = @"注册";
    self.WLeftBarStyle = LeftBarStyleDefault;
    self.WRightBarStyle = RightBarStyleNone;

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
    UIImageView *backImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KCurrentWidth, KCurrentHeight)];
    [backImgView setImage:[UIImage imageNamed:@"login_bg"]];
    [self.view addSubview:backImgView];
    
    UIView *bgTextView = [[UIView alloc] initWithFrame:CGRectMake(20, 20 + deltaHeight, 280, 160)];
    
    bgTextView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:bgTextView];
    
    _userNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, 280, 39.5)];
    _userNameTextField.placeholder = @"用户名:";
    _userNameTextField.font = [UIFont systemFontOfSize:16];
    _userNameTextField.returnKeyType = UIReturnKeyNext;
    _userNameTextField.delegate = self;
    [bgTextView addSubview:_userNameTextField];
    
    UIView *textLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, 280, 0.5)];
    textLineView.backgroundColor = [DFToolClass getColor:@"bfbfbf"];
    [bgTextView addSubview:textLineView];
    
    _emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 40, 280, 39.5)];
    _emailTextField.placeholder = @"邮箱:";
    _emailTextField.font = [UIFont systemFontOfSize:16];
    _emailTextField.returnKeyType = UIReturnKeyNext;
    _emailTextField.delegate = self;
    [bgTextView addSubview:_emailTextField];
    
    textLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 79.5, 280, 0.5)];
    textLineView.backgroundColor = [DFToolClass getColor:@"bfbfbf"];
    [bgTextView addSubview:textLineView];
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, 280, 39.5)];
    _passwordTextField.placeholder = @"密码:";
    _passwordTextField.font = [UIFont systemFontOfSize:16];
    _passwordTextField.returnKeyType = UIReturnKeyNext;
    _passwordTextField.delegate = self;
    _passwordTextField.secureTextEntry = YES;
    [bgTextView addSubview:_passwordTextField];
    
    textLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 119.5, 280, 0.5)];
    textLineView.backgroundColor = [DFToolClass getColor:@"bfbfbf"];
    [bgTextView addSubview:textLineView];
    
    _confirmPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 120, 280, 39.5)];
    _confirmPasswordTextField.placeholder = @"确认密码:";
    _confirmPasswordTextField.font = [UIFont systemFontOfSize:16];
    _confirmPasswordTextField.delegate = self;
    _confirmPasswordTextField.returnKeyType = UIReturnKeyDone;
    _confirmPasswordTextField.secureTextEntry = YES;
    [bgTextView addSubview:_confirmPasswordTextField];
    
    UIButton *btnRegiser = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRegiser.frame = CGRectMake(20, 300, 280, 36);
    [btnRegiser setTitle:@"注册" forState:UIControlStateNormal];
    [btnRegiser setBackgroundImage:[UIImage imageNamed:@"movdet_btn.png"] forState:UIControlStateNormal];
    [btnRegiser setBackgroundImage:[UIImage imageNamed:@"movdet_btn_press.png"] forState:UIControlStateHighlighted];
    btnRegiser.backgroundColor = [UIColor lightGrayColor];
    [btnRegiser addTarget:self action:@selector(regiser:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:btnRegiser];

    
}

- (void)regiser:(UIButton *)sender
{
    
    NSString *url = @"http://www.df360.cc/df360/api/register";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *para = @{@"email":_emailTextField.text,@"password":_passwordTextField.text,@"username":_userNameTextField.text};
    

    
    NSLog(@"%@",para);
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];

    [manager POST:url parameters:para success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSLog(@"json:%@",responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
        NSLog(@"operation:%@",operation);
        
        NSLog(@"error:%@",error);
    }];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _userNameTextField) {
        [_emailTextField becomeFirstResponder];
    }
    if (textField == _emailTextField) {
        if ([DFToolClass validateEmail:textField.text]) {
            [_passwordTextField becomeFirstResponder];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"邮箱格式不正确!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    if (textField == _passwordTextField) {
        [_confirmPasswordTextField becomeFirstResponder];
    }
    else
    {
        [_confirmPasswordTextField resignFirstResponder];
    }
    return YES;
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
