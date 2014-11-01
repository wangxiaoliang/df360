//
//  DFAboutVC.m
//  df360
//
//  Created by wangxl on 14/11/1.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFAboutVC.h"

@interface DFAboutVC ()

@end

@implementation DFAboutVC

- (void)viewDidLoad {
    
    self.WLeftBarStyle = LeftBarStyleDefault;
    self.WRightBarStyle = RightBarStyleNone;
    self.WTitle = @"关于我们";
    
    UIImageView *backImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KCurrentWidth, 400)];
    
    backImg.image = [UIImage imageNamed:@"wb_copyright_bg"];
    
    [self.view addSubview:backImg];
    
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(KCurrentWidth/2 -30, 150, 60, 60)];
    
    icon.image = [UIImage imageNamed:@"iconImg"];
    
    [backImg addSubview:icon];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(KCurrentWidth/2 - 60, 450, 120, 20)];
    
    label.text = @"登封360 V1.0";
    
    label.font = [UIFont systemFontOfSize:15];
    
    label.textAlignment = NSTextAlignmentCenter;
    
    label.textColor = [UIColor lightGrayColor];
    
    [self.view addSubview:label];
 
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
