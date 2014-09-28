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
#import "DFCustomTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface DFQBDetailVC ()<UITableViewDataSource,UITableViewDelegate,DFHudProgressDelegate>
{
    DFHudProgress *_hud;
    
    NSDictionary *_infoDic;
    
    NSMutableArray *_messageArr;
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
    
    self.WTitle = @"帖子详情";
    self.WLeftBarStyle = LeftBarStyleDefault;
    self.WRightBarStyle = RightBarStyleClick;
    
    [self getInfo];
    
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
        _messageArr = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"liuyan"]];

        
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
    
    UITextView *detailView = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, KCurrentWidth - 40, 120)];
    
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
    
    [upBtn setFrame:CGRectMake(20, 150, 60, 30)];
    
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
    
    [downBtn setFrame:CGRectMake(90, 150, 60, 30)];
    
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
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 190, KCurrentWidth, KCurrentHeight - 220) style:UITableViewStylePlain];
    
    
    tableView.backgroundColor = [UIColor whiteColor];
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
    /******************** 底部更多按钮 **********************/
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [moreBtn setFrame:CGRectMake(0, KCurrentHeight - 30, KCurrentWidth, 30)];
    
    moreBtn.backgroundColor = [UIColor redColor];
    
    [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    
    [self.view addSubview:moreBtn];
    
        
    
    
    
                                                                         
}

#pragma mark - 点赞
- (void)sendGood
{
    
}

- (void)sendBad
{
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_messageArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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
