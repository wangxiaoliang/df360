//
//  DFChildDetailVC.m
//  df360
//
//  Created by wangxl on 14-9-24.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFChildDetailVC.h"
#import "DFToolView.h"
#import "DFToolClass.h"
#import "AFNetworking.h"
#import "DFRequestUrl.h"
#import "UIImageView+WebCache.h"

#define baseURL @"http://www.df360.cc/"

@interface DFChildDetailVC ()<DFHudProgressDelegate,UITableViewDataSource,UITableViewDelegate>
{
    DFHudProgress *_hud;
    
    NSDictionary *dataDic;
    
    NSArray *listArr;
}
@end

@implementation DFChildDetailVC

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
    
    dataDic = [[NSDictionary alloc] init];
    
    listArr = [[NSArray alloc] init];
    
    self.WLeftBarStyle = LeftBarStyleDefault;
    self.WRightBarStyle = RightBarStyleDefault;
    
    self.WTitle = @"详情";
    
    UISearchBar *search = (UISearchBar *)[self.navigationController.navigationBar viewWithTag:1];
    search.hidden = YES;
    
    self.backScrollView.contentSize = CGSizeMake(KCurrentWidth, 900);
    
    self.view.backgroundColor = [DFToolClass getColor:@"e5e5e5"];
    
    [self setExtraCellLineHidden:self.detailTableView];
    
    [self getData];

    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)buildUI
{

    
    NSString *imageStr = [DFToolClass stringISNULL:[dataDic objectForKey:@"post_img_1"]];
    [self.image_1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL, imageStr]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    imageStr = [DFToolClass stringISNULL:[dataDic objectForKey:@"post_img_2"]];
    
    [self.image_2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL, imageStr]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    imageStr = [DFToolClass stringISNULL:[dataDic objectForKey:@"post_img_3"]];
    
    [self.image_3 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL, imageStr]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    imageStr = [DFToolClass stringISNULL:[dataDic objectForKey:@"post_img_4"]];
    
    [self.image_4 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL, imageStr]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    self.titleLabel.text = [dataDic objectForKey:@"post_title"];
    
    NSDate *beginDate = [NSDate dateWithTimeIntervalSince1970:[[dataDic objectForKey:@"post_begin_time"] floatValue]];
    
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:[[dataDic objectForKey:@"post_end_time"] floatValue]];
    
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yy-MM-dd"];
    
    NSString *beginTime = [df stringFromDate:beginDate];
    
    NSString *endTime = [df stringFromDate:endDate];
    
    self.beginLabel.text = [NSString stringWithFormat:@"开始时间:%@",beginTime];
    
    self.endLabel.text = [NSString stringWithFormat:@"结束时间:%@",endTime];
    
    self.viewsLabel.text = [NSString stringWithFormat:@"已浏览%@次",[dataDic objectForKey:@"post_view"]];
    
    self.detailTextView.text = [dataDic objectForKey:@"post_text"];
    
    [self.detailTableView reloadData];
}

- (void)getData
{
    [_hud show];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[DFRequestUrl getInfoPostWithPostId:[self.sendDic objectForKey:@"post_id"]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"TopJSON: %@", responseObject);
        dataDic = [responseObject objectForKey:@"data"];
        
        listArr = [dataDic objectForKey:@"list"];
        
        [_hud dismiss];
        
        [self buildUI];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"operation: %@",operation);
        
        NSLog(@"Error: %@", error);
        
        [_hud dismiss];
    }];
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([listArr count] == 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else
    {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return [listArr count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"detailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    cell.textLabel.text = [[listArr objectAtIndex:indexPath.row] objectForKey:@"profile_setting_title"];
    cell.detailTextLabel.text = [[listArr objectAtIndex:indexPath.row] objectForKey:@"post_profile_title"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
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

- (IBAction)reportClick:(id)sender {
    
    [_hud show];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDate *dateNow = [NSDate date];
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[dateNow timeIntervalSince1970]];
    
    
    
    NSDictionary *para = @{@"post_id":[dataDic objectForKey:@"post_id"],@"post_title":[dataDic objectForKey:@"post_title"],@"jubao_time":timeSp};
    
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
