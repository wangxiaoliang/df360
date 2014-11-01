//
//  DFSendSelectVC.m
//  df360
//
//  Created by wangxl on 14/10/30.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFSendSelectVC.h"

@interface DFSendSelectVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_dataArr;
    
    NSMutableArray *_selectArr;
    
}
@end

@implementation DFSendSelectVC

- (void)viewDidLoad {
    
    self.WLeftBarStyle = LeftBarStyleDefault;
    self.WRightBarStyle = RightBarStyleNone;
    
    self.WTitle = [self.selectDic objectForKey:@"c_name"];
    
    _dataArr = [self.selectDic objectForKey:@"child_categories"];
    _selectArr = [[NSMutableArray alloc] init];
    
    [self buildUI];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)buildUI
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KCurrentWidth, KCurrentHeight - 64) style:UITableViewStylePlain];
    
    tableView.dataSource = self;
    
    tableView.delegate = self;
    
    tableView.allowsMultipleSelection = YES;
    
    [self.view addSubview:tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"sendSelectCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    cell.textLabel.text = [[_dataArr objectAtIndex:indexPath.row] objectForKey:@"c_name"];
    
    cell.imageView.image = [UIImage imageNamed:@"checkbox_empty"];
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if ([_selectArr containsObject:[NSString stringWithFormat:@"%d",indexPath.row]]) {
        cell.imageView.image =  [UIImage imageNamed:@"checkbox_empty"];
        
        [_selectArr removeObject:[NSString stringWithFormat:@"%d",indexPath.row]];
    }
    else
    {
        cell.imageView.image =  [UIImage imageNamed:@"checkbox_full"];
        
        [_selectArr addObject:[NSString stringWithFormat:@"%d",indexPath.row]];

    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSString *selectId = @"";
    
    NSString *title = @"";
    
    for (NSString *str in _selectArr) {
        NSInteger num = [str integerValue];
        
        if ([selectId isEqualToString:@""]) {
            selectId = [selectId stringByAppendingString:[[_dataArr objectAtIndex:num] objectForKey:@"c_id"]];
            title = [title stringByAppendingString:[[_dataArr objectAtIndex:num] objectForKey:@"c_name"]];
        }
        else
        {
            selectId = [selectId stringByAppendingString:[NSString stringWithFormat:@",%@",[[_dataArr objectAtIndex:num] objectForKey:@"c_id"]]];
            title = [title stringByAppendingString:[NSString stringWithFormat:@",%@",[[_dataArr objectAtIndex:num] objectForKey:@"c_name"]]];
        }
    }
    
    [self.sendDelegate addDicWithKey:[self.selectDic objectForKey:@"c_id"]  andValue:selectId andTitle:title];
    
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
