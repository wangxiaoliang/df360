//
//  DFTodayShoppingVC.m
//  df360
//
//  Created by wangxl on 14-9-2.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFTodayShoppingVC.h"
#import "DFToolClass.h"
#import "LMContainsLMComboxScrollView.h"
#import "AFNetworking.h"
#import "DFToolView.h"
#import "DFRequestUrl.h"
#import "DFCustomTableViewCell.h"

@interface DFTodayShoppingVC ()<DFHudProgressDelegate,UITableViewDataSource,UITableViewDelegate>
{
    LMContainsLMComboxScrollView *LMcomboxScrollView;
    
    NSInteger _requestCount; //请求数量 -- 用来判断何时消失_hud
    
    NSMutableArray *_comArr;  //下拉数据源
    
    NSMutableArray *_tgTypeArr; //团购类型数组
    
    NSMutableArray *_areaArr;  //团购区域
    
    NSMutableArray *_timeArr;  //团购时间
    
    DFHudProgress *_hud;
    
    NSMutableArray *_tgArr;  //团购列表信息
    
}
@end

@implementation DFTodayShoppingVC

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
    _requestCount = 2;
    
    UISearchBar *search = (UISearchBar *)[self.navigationController.navigationBar viewWithTag:1];
    search.hidden = YES;
    
    self.WTitle = @"今日团购";
    self.WLeftBarStyle = LeftBarStyleDefault;
    self.WRightBarStyle = RightBarStyleNone;
    
    _tgTypeArr = [[NSMutableArray alloc] init];
    _areaArr = [[NSMutableArray alloc] initWithObjects:@"登封", nil];
    _timeArr = [[NSMutableArray alloc] initWithObjects:@"最近一周", nil];
    _comArr = [[NSMutableArray alloc] initWithObjects:_tgTypeArr,_areaArr,_timeArr, nil];
    
    _hud = [[DFHudProgress alloc] init];
    _hud.delegate = self;

    [_hud show];
    [self getSearchData];
    [self getTGGoods];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 获取下拉数据源
- (void)getSearchData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[DFRequestUrl getTuanCat] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSArray *dicArr = [responseObject objectForKey:@"data"];
        for (NSDictionary *dic in dicArr) {
            [_tgTypeArr addObject:[dic objectForKey:@"cat_title"]];
        }
        _requestCount -= 1;
        [self hudDissMiss];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        _requestCount -= 1;
        [self hudDissMiss];
    }];
}

#pragma mark - 获取团购列表信息
- (void)getTGGoods
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[DFRequestUrl getTGoods] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        _tgArr = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"data"]];
        _requestCount -= 1;
        [self hudDissMiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        _requestCount -= 1;
        [self hudDissMiss];
    }];

}

- (void)buildUI
{
    
    self.view.backgroundColor = [DFToolClass getColor:@"e5e5e5"];
    
    
    /************ 下拉选项 ************/
    LMcomboxScrollView = [[LMContainsLMComboxScrollView alloc]initWithFrame:CGRectMake(0, 0, KCurrentHeight, KCurrentHeight)];
    LMcomboxScrollView.backgroundColor = [UIColor clearColor];
    LMcomboxScrollView.showsVerticalScrollIndicator = NO;
    LMcomboxScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:LMcomboxScrollView];

    [self setUpBgScrollView];
    
    /************ 底部按钮 ************/
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, KCurrentHeight - 44, KCurrentWidth, 44)];
    downView.backgroundColor = [UIColor redColor];
    
    [LMcomboxScrollView addSubview:downView];
    
    UIButton *myTG = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, KCurrentWidth/2, 44)];
    
    [myTG setTitle:@"我的团购" forState:UIControlStateNormal];
    
    [myTG setBackgroundColor:[UIColor clearColor]];
    
    [downView addSubview:myTG];
    
    UIButton *myShop = [[UIButton alloc] initWithFrame:CGRectMake(KCurrentWidth/2, 0, KCurrentWidth/2, 44)];
    
    [myShop setTitle:@"我的商店" forState:UIControlStateNormal];
    
    [myShop setBackgroundColor:[UIColor clearColor]];
    
    [downView addSubview:myShop];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(KCurrentWidth/2, 0, 1, 44)];
    
    lineView.backgroundColor = [UIColor blackColor];
    
    [downView addSubview:lineView];
    
    /************ TableView ************/

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 24, KCurrentWidth, KCurrentHeight - 68) style:UITableViewStylePlain];
    
    tableView.backgroundColor = [UIColor clearColor];
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    [LMcomboxScrollView addSubview:tableView];
    
    
}

-(void)setUpBgScrollView
{
    
    NSLog(@"%@",_comArr);
    
    for(NSInteger i=0;i<3;i++)
    {
        LMComBoxView *comBox = [[LMComBoxView alloc]initWithFrame:CGRectMake(1 + (106)*i, 0, 106, 24)];
        comBox.backgroundColor = [UIColor whiteColor];
        comBox.arrowImgName = @"down_dark0.png";
        comBox.titlesList = [_comArr objectAtIndex:i];
        comBox.delegate = self;
        comBox.supView = LMcomboxScrollView;
        [comBox defaultSettings];
        comBox.tag =  i;
        [LMcomboxScrollView addSubview:comBox];
    }
}


-(void)selectAtIndex:(int)index inCombox:(LMComBoxView *)_combox
{
    NSInteger tag = [_combox tag];
    switch (tag) {
        case 0:
            
            break;
            
        default:
            break;
    }
}


#pragma mark - tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tgArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identif = @"cell";

    DFCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identif];
    
    if (!cell) {
        cell = [[DFCustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identif];
        [cell initTGCell];
    }
    [cell reloadTGCellWithArray:_tgArr withIndex:indexPath.row];
    return cell;
}

- (void)hudDissMiss
{
    if (_requestCount == 0) {
        [_hud dismiss];
        _requestCount = 2;
        [self buildUI];
    }
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
