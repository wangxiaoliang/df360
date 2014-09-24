//
//  DFSendVC.m
//  df360
//
//  Created by wangxl on 14-9-21.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFSendVC.h"
#import "DFToolClass.h"

@interface DFSendVC ()

@end

@implementation DFSendVC

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
    
    self.WTitle = @"发布";
    
    UISearchBar *search = (UISearchBar *)[self.navigationController.navigationBar viewWithTag:1];
    search.hidden = YES;
    
    
    self.view.backgroundColor = [DFToolClass getColor:@"e5e5e5"];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
