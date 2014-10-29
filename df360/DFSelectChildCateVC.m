//
//  DFSelectChildCateVC.m
//  df360
//
//  Created by wangxl on 14-9-22.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFSelectChildCateVC.h"
#import "DFToolClass.h"
#import "DFSendVC.h"

@interface DFSelectChildCateVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation DFSelectChildCateVC

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
    self.WLeftBarStyle = LeftBarStyleDefault;
    self.WRightBarStyle = RightBarStyleNone;
    
    self.WTitle = @"小分类";
    
    UISearchBar *search = (UISearchBar *)[self.navigationController.navigationBar viewWithTag:1];
    search.hidden = YES;
    
    
    self.view.backgroundColor = [DFToolClass getColor:@"e5e5e5"];

    [self buildUI];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)buildUI
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KCurrentWidth, KCurrentHeight-64) style:UITableViewStylePlain];
    
    tableView.backgroundColor = [UIColor whiteColor];
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    [self setExtraCellLineHidden:tableView];
    
    [self.view addSubview:tableView];
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.childCates count] == 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else
    {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }

    return [self.childCates count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"childCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    cell.textLabel.text = [[self.childCates objectAtIndex:indexPath.row] objectForKey:@"cat_title"];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%@",[self.childCates objectAtIndex:indexPath.row]);
    
    DFSendVC *send = [[DFSendVC alloc] init];
    send.childDic = [self.childCates objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:send animated:YES];
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
