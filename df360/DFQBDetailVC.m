//
//  DFQBDetailVC.m
//  df360
//
//  Created by wangxl on 14-9-18.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFQBDetailVC.h"
#import "AFNetworking.h"
#import "DFRequestUrl.h"
#import "DFToolView.h"
#import "DFToolClass.h"
#import "DFCustomTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "DFQBMessageVC.h"

@interface DFQBDetailVC ()<UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate,DFHudProgressDelegate>
{
    DFHudProgress *_hud;
    
    NSDictionary *_infoDic;
    
    NSMutableArray *_messageArr;
    
    NSString *_message;
}
@end

@implementation DFQBDetailVC

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
    
    _message = [[NSString alloc] init];
    
    self.WTitle = @"帖子详情";
    self.WLeftBarStyle = LeftBarStyleDefault;
    self.WRightBarStyle = RightBarStyleClick;
    
    [self getInfo];
    
    [self registerForKeyboardNotifications];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)getInfo
{
    [_hud show];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[DFRequestUrl getQBInfoWithTid:self.tid] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        _infoDic = [[NSDictionary alloc] initWithDictionary:[responseObject objectForKey:@"data"]];
        _messageArr = [[NSMutableArray alloc] initWithArray:[_infoDic objectForKey:@"liuyan"]];

        
        [self buildUI];
        
        [_hud dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        
        [_hud dismiss];
    }];
}

- (void)buildUI
{
    
    /******************** 帖子详细 **********************/
    
    UITextView *detailView = [[UITextView alloc] initWithFrame:CGRectMake(10, 20, KCurrentWidth - 20, 120)];
    
    detailView.text = [_infoDic objectForKey:@"message"];
    
    detailView.backgroundColor = [UIColor whiteColor];
    
    detailView.layer.masksToBounds = YES;
    detailView.layer.cornerRadius = 6.0;
    detailView.layer.borderWidth = 1.0;
    detailView.layer.borderColor = [[UIColor whiteColor] CGColor];
    detailView.editable = false;

    
    [self.view addSubview:detailView];
    
    /******************** 支持 **********************/
    
    UIButton *upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [upBtn setFrame:CGRectMake(10, 150, 60, 30)];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 20, 20)];
    
    image.image = [UIImage imageNamed:@"movdet_btn_good"];
    
    [upBtn addSubview:image];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 40, 30)];
    
    label.backgroundColor = [UIColor clearColor];
    
    label.text = @"支持2";
    
    label.font = [UIFont systemFontOfSize:13];
    
    [upBtn addSubview:label];
    
    [upBtn addTarget:self action:@selector(sendGood) forControlEvents:UIControlEventTouchUpInside];
    
    upBtn.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:upBtn];
    
    /******************** 反对 **********************/
    
    UIButton *downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [downBtn setFrame:CGRectMake(80, 150, 60, 30)];
    
    [downBtn addTarget:self action:@selector(sendBad) forControlEvents:UIControlEventTouchUpInside];
    
    downBtn.backgroundColor = [UIColor whiteColor];
    
    image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 20, 20)];
    
    image.image = [UIImage imageNamed:@"movdet_btn_bad"];
    
    [downBtn addSubview:image];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 40, 30)];
    
    label.backgroundColor = [UIColor clearColor];
    
    label.text = @"反对2";
    
    label.font = [UIFont systemFontOfSize:13];
    
    [downBtn addSubview:label];
    
    [self.view addSubview:downBtn];

    /******************** 评论 **********************/
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 190, KCurrentWidth - 20, KCurrentHeight - 230) style:UITableViewStylePlain];
    
    
    tableView.backgroundColor = [UIColor clearColor];
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    tableView.tag = 10001;
    
    [self setExtraCellLineHidden:tableView];
    
    [self.view addSubview:tableView];
    
    /******************** 底部更多按钮 **********************/
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 464, KCurrentWidth, 0.5)];
    
    line.tag = 20001;
    
    line.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:line];
    
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, 464.5, KCurrentWidth, KCurrentHeight - 464.5)];
    
    downView.tag = 30001;
    
    downView.backgroundColor = [UIColor whiteColor];
    
    UITextField *messageField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, KCurrentWidth - 110, 30)];
    
    messageField.placeholder = @"请输入留言";
    
    messageField.delegate = self;
    
    messageField.borderStyle = UITextBorderStyleRoundedRect;
    
    messageField.tag = 40001;
    
    [downView addSubview:messageField];
    
    UIButton *messageBtn = [[UIButton alloc] initWithFrame:CGRectMake(KCurrentWidth - 90, 5, 80, 30)];
    
    messageBtn.backgroundColor = [UIColor orangeColor];
    
    [messageBtn setTitle:@"留言" forState:UIControlStateNormal];
    
    [messageBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    
    [downView addSubview:messageBtn];
    
    [self.view addSubview:downView];
        
    
    
    
                                                                         
}

#pragma mark - 点赞
- (void)sendGood
{
    
}

- (void)sendBad
{
    
}

#pragma mark - 留言
- (void)sendMessage
{
    
    if ([_message isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入留言" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    if ([DFToolClass isLogin]) {
        [_hud show];
        
        NSString *url = @"http://www.df360.cc/df360/api/form_liuyanpublish";
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSString *fid = [_infoDic objectForKey:@"fid"];
        
        NSString *tid = [_infoDic objectForKey:@"tid"];
        
        NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
        
        NSString *author = [df objectForKey:@"username"];
        
        NSString *authored = [df objectForKey:@"uid"];
        
        NSString *subject = @"1";
        
        NSString *ipAddress = [self getIPAddress];
        
        NSDictionary *para = @{@"fid":fid,@"tid":tid,@"author":author,@"authorid":authored,@"subject":subject,@"message":_message,@"useip":ipAddress};
        
        NSLog(@"%@",para);
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        
        [manager POST:url parameters:para success:^(AFHTTPRequestOperation *operation,id responseObject){
            NSLog(@"json:%@",responseObject);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"留言成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alert show];
            
            UITextField *textField = (UITextField *)[self.view viewWithTag:40001];
            textField.text = @"";
            
            [_messageArr addObject:[responseObject objectForKey:@"data"]];
            
            UITableView *tableView = (UITableView *)[self.view viewWithTag:10001];
            
            [tableView reloadData];
            
            [_hud dismiss];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            NSLog(@"error:%@",error);
            [_hud dismiss];
        }];

    }
    else
    {
        [self performSegueWithIdentifier:@"QBLYNotLogin" sender:nil];
    }

}

- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}

#pragma mark - UITableViewDelegate
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

    
    if (_messageArr.count >5) {
        return 5;
    }
    return [_messageArr count];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(20, KCurrentHeight - 30, KCurrentWidth - 20, 30)];
    
    footerView.backgroundColor = [UIColor whiteColor];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KCurrentWidth - 20, 0.5)];
    
    line.backgroundColor = [UIColor lightGrayColor];
    
    line.alpha = 0.6;
    
    [footerView addSubview:line];
    
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [moreBtn setFrame:CGRectMake(0, 0.5, KCurrentWidth - 20, 29.5)];
    
    moreBtn.backgroundColor = [UIColor whiteColor];
    
    [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [moreBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];

    [moreBtn addTarget:self action:@selector(getMore) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:moreBtn];
    
    if (_messageArr.count == 0) {
        footerView.hidden = YES;
    }
    
    return footerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
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

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    float height = keyboardSize.height;
    
    UIView *line = [self.view viewWithTag:20001];
    
    [line setFrame:CGRectMake(0, 464 - height, KCurrentWidth, 0.5)];
    
    UIView *downView = [self.view viewWithTag:30001];
    
    [downView setFrame:CGRectMake(0, 464.5 - height, KCurrentWidth, KCurrentHeight - 464.5)];
    
    NSLog(@"keyBoard:%f", keyboardSize.height);  //216
    ///keyboardWasShown = YES;
}
- (void) keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    
    UIView *line = [self.view viewWithTag:20001];
    
    [line setFrame:CGRectMake(0, 464, KCurrentWidth, 0.5)];
    
    UIView *downView = [self.view viewWithTag:30001];
    
    [downView setFrame:CGRectMake(0, 464.5, KCurrentWidth, KCurrentHeight - 464.5)];
    
    // keyboardWasShown = NO;
    
}

#pragma  mark - textFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    _message = textField.text;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)getMore
{
    [self performSegueWithIdentifier:@"QBMessage" sender:[_infoDic objectForKey:@"tid"]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"QBMessage"]) {
        DFQBMessageVC *message = (DFQBMessageVC *)segue.destinationViewController;
        message.tid = sender;
    }
}

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [DFToolClass getColor:@"f4f4f4"];
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
