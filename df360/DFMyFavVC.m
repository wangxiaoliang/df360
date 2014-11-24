//
//  DFMyFavVC.m
//  df360
//
//  Created by wangxl on 14/11/19.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFMyFavVC.h"
#import "DFRequestUrl.h"
#import "DFToolView.h"
#import "AFNetworking.h"
#import "DFShoppingDetailVC.h"
#import "DFCustomTableViewCell.h"

@interface DFMyFavVC ()<UITableViewDataSource,UITableViewDelegate,DFHudProgressDelegate>
{
    UITableView *_tableView;
    DFHudProgress *_hud;
    
    NSMutableArray *_dataArr;
}
@end

@implementation DFMyFavVC

- (void)viewDidLoad {
    
    self.WTitle = @"我的收藏";
    self.WLeftBarStyle = LeftBarStyleDefault;
    self.WRightBarStyle = RightBarStyleNone;

    _hud = [[DFHudProgress alloc] init];
    
    _hud.delegate = self;
    
    [self requestData];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)requestData
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userId = [defaults objectForKey:@"uid"];

    
    [_hud show];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[DFRequestUrl myFavWithUserId:userId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        _dataArr = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dic in [responseObject objectForKey:@"data"]) {
            [_dataArr addObject:[dic objectForKey:@"goodinfo"]];
        }

        [self buildUI];
        
        [_hud dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        [_hud dismiss];
    }];

}

- (void)buildUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KCurrentWidth, KCurrentHeight) style:UITableViewStylePlain];
    
    _tableView.backgroundColor = [UIColor clearColor];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;

    [self.view addSubview:_tableView];
    
    [self setExtraCellLineHidden:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_dataArr count] == 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else
    {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return [_dataArr count];
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
    [cell reloadTGCellWithArray:_dataArr withIndex:indexPath.row];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard *storyboard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DFShoppingDetailVC *detail = [storyboard instantiateViewControllerWithIdentifier:@"DFShoppingDetailVC"];
    
    detail.catId = [[_dataArr objectAtIndex:indexPath.row] objectForKey:@"goods_id"];
    detail.goodPic = [[_dataArr objectAtIndex:indexPath.row] objectForKey:@"goods_pic"];

    
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
