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

@interface DFTopInfoVC ()<DFHudProgressDelegate>
{
    DFHudProgress *_hud;
    
    NSDictionary *_dataDic;
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

    _dataDic = [[NSDictionary alloc] init];
    
    _hud = [[DFHudProgress alloc] init];
    
    _hud.delegate = self;
    
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
    self.titleLabel.text = [_dataDic objectForKey:@"post_title"];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[_dataDic objectForKey:@"post_end_time"] floatValue]];
    
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yy-MM-dd"];
    NSString *regStr = [df stringFromDate:confromTimesp];
    
    self.timeLabel.text = [NSString stringWithFormat:@"结束时间%@",regStr];
    
    self.viewLabel.text = [NSString stringWithFormat:@"浏览次数%@",[_dataDic objectForKey:@"post_view"]];
    
    self.infoTextView.text = [_dataDic objectForKey:@"post_text"];
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
        
        BOOL success = [responseObject objectForKey:@"status"];
        
        if (success) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"举报成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        
        [_hud dismiss];
        
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
        [_hud dismiss];
    }];
}
@end
