
//
//  DFSearchVC.m
//  df360
//
//  Created by wangxl on 14/11/1.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFSearchVC.h"

@interface DFSearchVC ()

@end

@implementation DFSearchVC

- (void)viewDidLoad {
    
    UISearchBar *search = (UISearchBar *)[self.navigationController.navigationBar viewWithTag:1];
    search.hidden = YES;
    
    self.WTitle = [NSString stringWithFormat:@"搜索-%@",self.searchStr];
    self.WLeftBarStyle = LeftBarStyleDefault;
    self.WRightBarStyle = RightBarStyleNone;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
