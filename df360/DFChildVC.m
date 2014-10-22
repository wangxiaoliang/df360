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
    
    _comArr = [[NSMutableArray alloc] init];
    
    _titleArr = [[NSMutableArray alloc] init];
    
    _typeArr = [[NSMutableArray alloc] init];
    
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
    [_hud show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[DFRequestUrl getSubcatListWithPage:[NSString stringWithFormat:@"%ld",_page] withSubcatId:[self.childDic objectForKey:@"cat_id"]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"TopJSON: %@", responseObject);
        _childArr = [responseObject objectForKey:@"data"];
        _requestCount -= 1;
        
        if (_requestCount == 0) {
            [self buildUI];
        }
        
        [_hud dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"operation: %@",operation);
        
        NSLog(@"Error: %@", error);
        _requestCount -= 1;
        [_hud dismiss];
    }];
}

- (void)buildUI
{
    
    /************ tableView ************/
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, KCurrentWidth, KCurrentHeight - 40) style:UITableViewStylePlain];
    
    tableView.backgroundColor = [UIColor whiteColor];
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
    
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self performSegueWithIdentifier:@"childDetailView" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

#pragma mark - segementDelegate
- (void)segmentIsClickWithType:(NSInteger)type withId:(NSString *)subid
{
    NSLog(@"%ld   %@",type,subid);
    [_hud show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[DFRequestUrl getSubcatListWithPage:[NSString stringWithFormat:@"%ld",_page] withSubcatId:[self.childDic objectForKey:@"cat_id"]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"TopJSON: %@", responseObject);
        _childArr = [responseObject objectForKey:@"data"];
        _requestCount -= 1;
        
        if (_requestCount == 0) {
            [self buildUI];
        }
        
        [_hud dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"operation: %@",operation);
        
        NSLog(@"Error: %@", error);
        _requestCount -= 1;
        [_hud dismiss];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [segment dissmisSegmentView];

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
