//
//  DFChildVC.m
//  df360
//
//  Created by wangxl on 14-9-21.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFChildVC.h"
#import "DFChildDetailVC.h"
#import "DFToolClass.h"
#import "AFNetworking.h"
#import "DFRequestUrl.h"
#import "DFToolView.h"
#import "DFCustomTableViewCell.h"
#import "LMContainsLMComboxScrollView.h"
#import "PopoverView.h"
#import "MJRefresh.h"


@interface DFChildVC ()<UITableViewDataSource,UITableViewDelegate,DFHudProgressDelegate,DFSegmentDelegate>
{
    
    NSMutableArray *_comArr; //下拉数据源
    
    NSMutableArray *_titleArr;
    
    NSMutableArray *_areaArr;  //区域
    
    NSMutableArray *_typeArr;  //类别
    
    NSMutableArray *_payTypeArr; //付款方式
    
    NSMutableArray *_oldOrNewArr; //新旧程度
    
    NSMutableArray *_childArr; //列表数据源
    
    NSInteger _page;
    
    NSInteger _requestCount;
    
    DFHudProgress *_hud;
    
    DFSegmentController *segment;
    
    BOOL _firstRequest;
    
    BOOL _needRequest;
    
    UITableView *_tableView;
    
    NSString *_searchCondition;
    
    NSString *_searchValue;
    
}
@end

@implementation DFChildVC

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
    _page = 0;
    
    _requestCount = 2;
    
    _firstRequest = YES;
    _needRequest = YES;
    
    _comArr = [[NSMutableArray alloc] init];
    
    _titleArr = [[NSMutableArray alloc] init];
    
    _typeArr = [[NSMutableArray alloc] init];
    
    _childArr = [[NSMutableArray alloc] init];
    
    _hud = [[DFHudProgress alloc] init];
    _hud.delegate = self;
    
    self.WLeftBarStyle = LeftBarStyleDefault;
    self.WRightBarStyle = RightBarStyleNone;
    
    self.WTitle = [self.childDic objectForKey:@"cat_title"];
    
    UISearchBar *search = (UISearchBar *)[self.navigationController.navigationBar viewWithTag:1];
    search.hidden = YES;
    
    
    self.view.backgroundColor = [DFToolClass getColor:@"e5e5e5"];

    
    
    [self getListData];
    
    [self getComArr];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)getComArr
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[DFRequestUrl sysSetWithSubcatid:[self.childDic objectForKey:@"cat_id"]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"TopJSON: %@", responseObject);
        NSArray *dataArr = [responseObject objectForKey:@"data"];
        
        for (NSDictionary *dic in dataArr) {
            NSArray *childarr = [dic objectForKey:@"child_categories"];
            
            [_typeArr addObject:[dic objectForKey:@"c_id"]];
            
            [_titleArr addObject:[dic objectForKey:@"c_name"]];
            
            [_comArr addObject:childarr];
            
            
        }
        
        _requestCount -= 1;
        if (_requestCount == 0) {
            [self buildUI];
        }
        [self buildUI];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"operation: %@",operation);
        
        NSLog(@"Error: %@", error);
        _requestCount -= 1;

    }];

}

- (void)getArea
{
    
}

- (void)getListData
{
    if (_firstRequest) {
        [_hud show];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[self getListURL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"TopJSON: %@", responseObject);
        
        for (NSDictionary *dic in [responseObject objectForKey:@"data"]) {
            
            [_childArr addObject:dic];
        }
        
        
        if (_childArr.count != 10) {
            _needRequest = false;
        }
        if (_firstRequest) {
            _requestCount -= 1;
            _firstRequest = false;
            
            if (_requestCount == 0) {
                [self buildUI];
            }
        }
        else
        {
            [_tableView reloadData];
        }
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        [_hud dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"operation: %@",operation);
        
        NSLog(@"Error: %@", error);
        _requestCount -= 1;
        [_hud dismiss];
    }];
}

- (NSString *)getListURL
{
    NSString *strURL;
    if (_searchCondition.length > 1) {
        strURL = [NSString stringWithFormat:@"http://www.df360.cc/df360/api/subcat_list?&subcat_id=%@&%@=%@&page=%@",[self.childDic objectForKey:@"cat_id"],_searchCondition,_searchValue,[NSString stringWithFormat:@"%ld",_page]];
    }
    else
    {
        strURL = [NSString stringWithFormat:@"http://www.df360.cc/df360/api/subcat_list?&subcat_id=%@&page=%@",[self.childDic objectForKey:@"cat_id"],[NSString stringWithFormat:@"%ld",_page]];
    }
    
    strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return strURL;
}

- (void)buildUI
{
    
    /************ tableView ************/
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, KCurrentWidth, KCurrentHeight - 40) style:UITableViewStylePlain];
    
    _tableView.backgroundColor = [UIColor whiteColor];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    [self setExtraCellLineHidden:_tableView];
    
    __block DFChildVC *blockSelf = self;
     [_tableView addHeaderWithCallback:^{
         blockSelf -> _page = 0;
         blockSelf -> _needRequest = YES;
         [blockSelf getListData];
    }];
    
    
    [_tableView addFooterWithCallback:^{
        if (blockSelf -> _needRequest) {
            blockSelf -> _page++;
            [blockSelf getListData];
        }
        else
        {
            [blockSelf -> _tableView footerEndRefreshing];
        }
    }];
    
    [self.view addSubview:_tableView];
    
    
    segment = [[DFSegmentController alloc] initWithFrame:CGRectMake(0, 0, KCurrentWidth, 40) withTitle:_titleArr withData:_comArr];
    segment.delegate = self;
    segment.segementTitle = _titleArr;
    segment.segementData = _comArr;
    
    [self.view addSubview:segment];
}




#pragma mark - TableViewDeletagte
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_childArr count] == 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else
    {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return [_childArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"childCell";
    DFCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[DFCustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        [cell initChildCell];
    }
    [cell reloadChildCellWithArray:_childArr withIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%@",[_childArr objectAtIndex:indexPath.row]);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self performSegueWithIdentifier:@"childDetailView" sender:[_childArr objectAtIndex:indexPath.row]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"childDetailView"]) {
        DFChildDetailVC *detail = (DFChildDetailVC *)segue.destinationViewController;
        detail.sendDic = sender;
    }
}



#pragma mark - segementDelegate
- (void)segmentIsClickWithType:(NSInteger)type withId:(NSString *)subid
{
    NSLog(@"%ld   %@",type,subid);
    
    _searchCondition = [_typeArr objectAtIndex:type];
    
    _searchValue = subid;
    
    _page = 0;
    
    [_childArr removeAllObjects];
    
    [self getListData];
    
    
//    [_hud show];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager GET:[DFRequestUrl getSubcatListWithPage:[NSString stringWithFormat:@"%ld",_page] withSubcatId:[self.childDic objectForKey:@"cat_id"]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSLog(@"TopJSON: %@", responseObject);
//        _childArr = [responseObject objectForKey:@"data"];
//        _requestCount -= 1;
//        
//        if (_requestCount == 0) {
//            [self buildUI];
//        }
//        
//        [_hud dismiss];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"operation: %@",operation);
//        
//        NSLog(@"Error: %@", error);
//        _requestCount -= 1;
//        [_hud dismiss];
//    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [segment dissmisSegmentView];

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

@end
