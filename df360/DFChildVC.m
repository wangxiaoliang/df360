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

@interface DFChildVC ()<UITableViewDataSource,UITableViewDelegate,DFHudProgressDelegate>
{
    LMContainsLMComboxScrollView *LMcomboxScrollView;
    
    NSMutableArray *_comArr; //下拉数据源
    
    NSMutableArray *_areaArr;  //区域
    
    NSMutableArray *_typeArr;  //类别
    
    NSMutableArray *_payTypeArr; //付款方式
    
    NSMutableArray *_oldOrNewArr; //新旧程度
    
    NSMutableArray *_childArr; //列表数据源
    
    NSInteger _page;
    
    DFHudProgress *_hud;
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
    
    _areaArr = [[NSMutableArray alloc] initWithObjects:@"所属区域", nil];
    _typeArr = [[NSMutableArray alloc] initWithObjects:@"交易类型", nil];
    _payTypeArr = [[NSMutableArray alloc] initWithObjects:@"付款方式", nil];
    _oldOrNewArr = [[NSMutableArray alloc] initWithObjects:@"新旧程度", nil];
    
    _comArr = [[NSMutableArray alloc] initWithObjects:_areaArr,_typeArr,_payTypeArr,_oldOrNewArr, nil];
    
    _hud = [[DFHudProgress alloc] init];
    _hud.delegate = self;
    
    self.WLeftBarStyle = LeftBarStyleDefault;
    self.WRightBarStyle = RightBarStyleNone;
    
    self.WTitle = [self.childDic objectForKey:@"cat_title"];
    
    UISearchBar *search = (UISearchBar *)[self.navigationController.navigationBar viewWithTag:1];
    search.hidden = YES;
    
    
    self.view.backgroundColor = [DFToolClass getColor:@"e5e5e5"];

    
    [self getListData];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)getListData
{
    [_hud show];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[DFRequestUrl getSubcatListWithPage:[NSString stringWithFormat:@"%ld",_page] withSubcatId:[self.childDic objectForKey:@"cat_id"]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"TopJSON: %@", responseObject);
        _childArr = [responseObject objectForKey:@"data"];
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
    
    
    
    /************ 下拉选项 ************/
    LMcomboxScrollView = [[LMContainsLMComboxScrollView alloc]initWithFrame:CGRectMake(0, 0, KCurrentHeight, KCurrentHeight)];
    LMcomboxScrollView.backgroundColor = [UIColor clearColor];
    LMcomboxScrollView.showsVerticalScrollIndicator = NO;
    LMcomboxScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:LMcomboxScrollView];

    [self setUpBgScrollView];
    
    /************ tableView ************/
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 24, KCurrentWidth, KCurrentHeight - 88) style:UITableViewStylePlain];
    
    tableView.backgroundColor = [UIColor whiteColor];
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
    

}

-(void)setUpBgScrollView
{
    
    NSLog(@"%@",_comArr);
    
    for(NSInteger i=0;i<4;i++)
    {
        LMComBoxView *comBox = [[LMComBoxView alloc]initWithFrame:CGRectMake((KCurrentWidth/4)*i, 0, KCurrentWidth/4, 24)];
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
