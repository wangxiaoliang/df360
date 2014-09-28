//
//  DFMyTopMessageVC.m
//  df360
//
//  Created by wangxl on 14-9-28.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFMyTopMessageVC.h"

@interface DFMyTopMessageVC ()

@end

@implementation DFMyTopMessageVC

- (void)viewDidLoad {
    
    self.WTitle = @"我的置顶信息";
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
