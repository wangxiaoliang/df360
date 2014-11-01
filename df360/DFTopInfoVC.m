//
//  DFTopInfoVC.m
//  df360
//
//  Created by wangxl on 14/10/20.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFTopInfoVC.h"
#import "DFToolView.h"
#import "DFRequestUrl.h"
#import "AFNetworking.h"
#import "UMSocial.h"
#import "DFToolClass.h"

@interface DFTopInfoVC ()<DFHudProgressDelegate,WCustomVCDelegate,UITableViewDataSource,UITableViewDelegate>
{
    DFHudProgress *_hud;
    
    NSDictionary *_dataDic;
    
    NSString *_shareText;
    
    NSArray *_listArr;
    
    float _addHeight;
}

@end

@implementation DFTopInfoVC

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
    UISearchBar *search = (UISearchBar *)[self.navigationController.navigationBar viewWithTag:1];
    search.hidden = YES;
    
    self.WTitle = @"详情";
    self.WLeftBarStyle = LeftBarStyleDefault;
    self.WRightBarStyle = RightBarStyleDefault;

    _backScrollView.contentSize = CGSizeMake(KCurrentWidth, 490);

    
    _dataDic = [[NSDictionary alloc] init];
    
    _hud = [[DFHudProgress alloc] init];
    
    _hud.delegate = self;
    
    self.delegate = self;
    
    [self getInfoData];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)getInfoData
{
    [_hud show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[DFRequestUrl getInfoPostWithPostId:[self.sendDic objectForKey:@"post_id"]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"TopJSON: %@", responseObject);
        
        _dataDic = [responseObject objectForKey:@"data"];
        _listArr = [[NSArray alloc] initWithArray:[_dataDic objectForKey:@"list"]];
        [self buildUI];
    
        [_hud dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"operation: %@",operation);
        
        NSLog(@"Error: %@", error);
        [_hud dismiss];
    }];
}

- (void)buildUI
{
    self.titleLabel.text = [DFToolClass stringISNULL:[_dataDic objectForKey:@"post_title"]];
    
    if ([[_dataDic objectForKey:@"post_end_time"] isEqual:[NSNull null]]) {
        self.timeLabel.text = @"";
    }
    
    else
    {
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[_dataDic objectForKey:@"post_end_time"] floatValue]];
        
        NSDateFormatter * df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yy-MM-dd"];
        NSString *regStr = [df stringFromDate:confromTimesp];
        
        self.timeLabel.text = [NSString stringWithFormat:@"结束时间%@",regStr];
    }
    
    self.viewLabel.text = [NSString stringWithFormat:@"浏览次数%@",[DFToolClass stringISNULL:[_dataDic objectForKey:@"post_view"]]];
    
    self.infoTextView.text = [DFToolClass stringISNULL:[_dataDic objectForKey:@"post_text"]];
    
    _addHeight = _listArr.count * 44 + 10;
    
    if (_listArr.count >0) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 147, 300, 44*_listArr.count) style:UITableViewStylePlain];
        
        tableView.delegate = self;
        
        tableView.dataSource = self;
        
        tableView.allowsSelection = NO;
        
        [self.backScrollView addSubview:tableView];
    }
    
    _backScrollView.contentSize = CGSizeMake(KCurrentWidth, 468+_addHeight);
    
    CGRect detailRect = self.detailView.frame;
    
    detailRect.origin.y += _addHeight;
    
    [self.detailView setFrame:detailRect];
    
    CGRect noticeRect = self.noticeView.frame;
    
    noticeRect.origin.y += _addHeight;
    
    [self.noticeView setFrame:noticeRect];
    
    CGRect reportRect = self.reportBtn.frame;
    
    reportRect.origin.y += _addHeight;
    
    [self.reportBtn setFrame:reportRect];
    
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, KCurrentHeight - 55, KCurrentWidth, 55)];
    
    downView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    
    nameLabel.text = [DFToolClass stringISNULL:[_dataDic objectForKey:@"member_title"]];
    
    nameLabel.font = [UIFont systemFontOfSize:15];
    
    nameLabel.textAlignment = NSTextAlignmentLeft;
    
    [downView addSubview:nameLabel];
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 200, 25)];
    
    phoneLabel.text = @"15323456543(测试)";
    
    phoneLabel.textColor = [UIColor lightGrayColor];
    
    phoneLabel.font = [UIFont systemFontOfSize:14];
    
    [downView addSubview:phoneLabel];
    
    
    UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [phoneBtn setFrame:CGRectMake(KCurrentWidth - 80, 5, 25, 25)];
    
    [phoneBtn setBackgroundColor:[UIColor clearColor]];
    
    [phoneBtn setImage:[UIImage imageNamed:@"icon_personal_call"] forState:UIControlStateNormal];
    
    [phoneBtn addTarget:self action:@selector(callPeople) forControlEvents:UIControlEventTouchUpInside];
    
    [downView addSubview:phoneBtn];
    
    
    UILabel *phoneTitle = [[UILabel alloc] initWithFrame:CGRectMake(KCurrentWidth - 80, 30, 30, 25)];
    
    phoneTitle.text = @"手机";
    
    phoneTitle.textColor = [UIColor lightGrayColor];
    
    phoneTitle.font = [UIFont systemFontOfSize:14];
    
    [downView addSubview:phoneTitle];
    
    UIButton *msmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [msmBtn setBackgroundColor:[UIColor clearColor]];

    
    [msmBtn setImage:[UIImage imageNamed:@"icon_personal_message"] forState:UIControlStateNormal];
    
    [msmBtn addTarget:self action:@selector(msmPeople) forControlEvents:UIControlEventTouchUpInside];
    
    [msmBtn setFrame:CGRectMake(KCurrentWidth - 40, 5, 25, 25)];

    
    [downView addSubview:msmBtn];
    
    UILabel *msmTitle = [[UILabel alloc] initWithFrame:CGRectMake(KCurrentWidth - 40, 30, 30, 25)];
    
    msmTitle.text = @"短信";
    
    msmTitle.textColor = [UIColor lightGrayColor];
    
    msmTitle.font = [UIFont systemFontOfSize:14];
    
    [downView addSubview:msmTitle];

    [self.view addSubview:downView];
    
}

- (void)callPeople
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://15323456543"]];

}

- (void)msmPeople
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms://15323456543"]];

}

#pragma mark - tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"topDetailCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    cell.textLabel.text = [[_listArr objectAtIndex:indexPath.row] objectForKey:@"profile_setting_title"];
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.text = [[_listArr objectAtIndex:indexPath.row] objectForKey:@"post_profile_title"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
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

- (IBAction)reportSelected:(id)sender {
    
    [_hud show];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDate *dateNow = [NSDate date];
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[dateNow timeIntervalSince1970]];
    
    
    
    NSDictionary *para = @{@"post_id":[_dataDic objectForKey:@"post_id"],@"post_title":[_dataDic objectForKey:@"post_title"],@"jubao_time":timeSp};
    
    NSLog(@"%@",para);
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager POST:[DFRequestUrl report] parameters:para success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSLog(@"json:%@",responseObject);
        
        BOOL success = [[responseObject objectForKey:@"status"] boolValue];
        
        if (success) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"举报成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        
        [_hud dismiss];
        
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
        [_hud dismiss];
    }];
}

- (void)share:(UIButton *)sender
{
    
    _shareText =[DFToolClass stringISNULL:[_dataDic objectForKey:@"post_text"]];
    
    [UMSocialData defaultData].extConfig.title = @"登封360";
    
    NSInteger shareTag = [sender tag];
    
    switch (shareTag) {
        case 0:
        {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:_shareText image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                    [self alertWithTitle:@"分享成功!"];
                }
                else
                {
                    [self alertWithTitle:@"分享失败!"];
                }
            }];
            
        }
            break;
        case 1:
        {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:_shareText image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                    [self alertWithTitle:@"分享成功!"];
                }
                else
                {
                    [self alertWithTitle:@"分享失败!"];
                }
            }];
        }
            break;
        case 2:
        {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:_shareText image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                    [self alertWithTitle:@"分享成功!"];
                }
                else
                {
                    [self alertWithTitle:@"分享失败!"];
                }
            }];
        }
            break;
        case 3:
        {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:_shareText image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                    [self alertWithTitle:@"分享成功!"];
                }
                else
                {
                    [self alertWithTitle:@"分享失败!"];
                }
            }];
        }
            break;
        case 4:
        {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:_shareText image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                    [self alertWithTitle:@"分享成功!"];
                }
                else
                {
                    [self alertWithTitle:@"分享失败!"];
                }
            }];
        }
            break;
        default:
            break;
    }
}
- (void)alertWithTitle:(NSString *)str
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}


@end
