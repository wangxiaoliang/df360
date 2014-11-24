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
#import "DFShoppingDetailVC.h"
#import "MJRefresh.h"

@interface DFTodayShoppingVC ()<DFHudProgressDelegate,UITableViewDataSource,UITableViewDelegate,DFTuanSegmentDelegate>
{
    
    NSInteger _requestCount; //请求数量 -- 用来判断何时消失_hud
    
    NSMutableArray *_comArr;  //下拉数据源
    
    NSDictionary *_tgTypeDic; //团购类型
    
    NSMutableArray *_areaArr;  //团购区域
    
    NSMutableArray *_timeArr;  //团购时间
    
    DFHudProgress *_hud;
    
    NSMutableArray *_tgArr;  //团购列表信息
    
    DFTuanSegmentController *segement;
    
    UITableView *_tableView;
    
    NSInteger _page;
    
    BOOL _needRequest;
    
    NSString *_searchCondition;
    
    NSString *_searchValue;
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
    
    _page = 0;
    
    _needRequest = YES;
    
    UISearchBar *search = (UISearchBar *)[self.navigationController.navigationBar viewWithTag:1];
    search.hidden = YES;
    
    self.WTitle = @"今日团购";
    self.WLeftBarStyle = LeftBarStyleDefault;
    self.WRightBarStyle = RightBarStyleNone;
    
    _tgTypeDic = [[NSDictionary alloc] init];
    
    
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
        
        _tgTypeDic = [responseObject objectForKey:@"data"];
       
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
    [manager GET:[DFRequestUrl getTGoodsWithPage:[NSString stringWithFormat:@"%d",_page]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        _tgArr = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"data"]];
        if (_tgArr.count < 10) {
            _needRequest = NO;
        }
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];

        _requestCount -= 1;
        [self hudDissMiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        _requestCount -= 1;
        [self hudDissMiss];
    }];

}

- (void)getTGGoodsAgain
{
    [_hud show];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[self getTGURLWithSearchCondition:_searchCondition WithSearchValue:_searchValue WithPage:[NSString stringWithFormat:@"%d",_page]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        if (_tgArr.count < 10) {
            _needRequest = NO;
        }
        for (NSDictionary *dic in [responseObject objectForKey:@"data"]) {
            [_tgArr addObject:dic];
        }
        
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];

        [_hud dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        _requestCount -= 1;
        [_hud dismiss];
    }];
    
}

- (NSString *)getTGURLWithSearchCondition:(NSString *)condition WithSearchValue:(NSString *)value WithPage:(NSString *)page
{
    NSString *strURL;
    if (condition.length>1) {
        strURL = [NSString stringWithFormat:@"http://www.df360.cc/df360/api/tuan_goods?%@=%@&page=%@",condition,value,page];
    }
    else
    {
        strURL = [NSString stringWithFormat:@"http://www.df360.cc/df360/api/tuan_goods?page=%@",page];
    }
    
    strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",strURL);
    
    return strURL;
}

- (void)tuanSegmentIsClickWithType:(NSInteger)type withId:(NSString *)subid
{
    NSArray *typeArr = @[@"type",@"area",@"updatedate"];
    
    _searchCondition = [typeArr objectAtIndex:type];
    
    _searchValue = subid;
    
    _page = 0;
    
    [_tgArr removeAllObjects];
    
    [self getTGGoodsAgain];
}

- (void)buildUI
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    /************ 下拉选项 ************/
//    LMcomboxScrollView = [[LMContainsLMComboxScrollView alloc]initWithFrame:CGRectMake(0, 0, KCurrentHeight, KCurrentHeight)];
//    LMcomboxScrollView.backgroundColor = [UIColor clearColor];
//    LMcomboxScrollView.showsVerticalScrollIndicator = NO;
//    LMcomboxScrollView.showsHorizontalScrollIndicator = NO;
//    [self.view addSubview:LMcomboxScrollView];
//
//    [self setUpBgScrollView];
    segement = [[DFTuanSegmentController alloc] initWithFrame:CGRectMake(0, 0, KCurrentWidth, 40) withData:_tgTypeDic];
    
    segement.segementData = _tgTypeDic;
    
    segement.delegate = self;
    
    [self.view addSubview:segement];
    
    
    /************ 底部按钮 ************/
//    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, KCurrentHeight - 44, KCurrentWidth, 44)];
//    downView.backgroundColor = [UIColor redColor];
//    
//    [self.view addSubview:downView];
//    
//    UIButton *myTG = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, KCurrentWidth/2, 44)];
//    
//    [myTG setTitle:@"我的团购" forState:UIControlStateNormal];
//    
//    [myTG setBackgroundColor:[UIColor clearColor]];
//    
//    [downView addSubview:myTG];
//    
//    UIButton *myShop = [[UIButton alloc] initWithFrame:CGRectMake(KCurrentWidth/2, 0, KCurrentWidth/2, 44)];
//    
//    [myShop setTitle:@"我的商店" forState:UIControlStateNormal];
//    
//    [myShop setBackgroundColor:[UIColor clearColor]];
//    
//    [downView addSubview:myShop];
//    
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(KCurrentWidth/2, 0, 1, 44)];
//    
//    lineView.backgroundColor = [UIColor blackColor];
//    
//    [downView addSubview:lineView];
    
    /************ TableView ************/

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, KCurrentWidth, KCurrentHeight - 84) style:UITableViewStylePlain];
    
    _tableView.backgroundColor = [UIColor clearColor];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    __block DFTodayShoppingVC *blockSelf = self;
    [_tableView addHeaderWithCallback:^{
        blockSelf -> _page = 0;
        blockSelf -> _needRequest = YES;
        [blockSelf -> _tgArr removeAllObjects];
        [blockSelf getTGGoodsAgain];
    }];
    
    
    [_tableView addFooterWithCallback:^{
        if (blockSelf -> _needRequest) {
            blockSelf -> _page++;
            [blockSelf getTGGoodsAgain];
        }
        else
        {
            [blockSelf -> _tableView footerEndRefreshing];
        }
    }];
    
    [self.view addSubview:_tableView];
    
    [self setExtraCellLineHidden:_tableView];
}




#pragma mark - tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_tgArr count] == 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else
    {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *senderArr = [[NSArray alloc] initWithObjects:[[_tgArr objectAtIndex:indexPath.row] objectForKey:@"goods_id"],[[_tgArr objectAtIndex:indexPath.row] objectForKey:@"goods_pic"], nil];
    
    [self performSegueWithIdentifier:@"shoppingDetail" sender:senderArr];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"shoppingDetail"]) {
        DFShoppingDetailVC *shopping = (DFShoppingDetailVC *)segue.destinationViewController;
        shopping.catId = [sender objectAtIndex:0];
        shopping.goodPic = [sender objectAtIndex:1];
        
    }
}

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
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
