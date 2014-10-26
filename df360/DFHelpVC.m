//
//  DFHelpVC.m
//  df360
//
//  Created by wangxl on 14/10/24.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFHelpVC.h"

@interface DFHelpVC ()

@end

@implementation DFHelpVC

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
    self.WTitle = @"帮助";

    UIWebView *webView =[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, KCurrentWidth, KCurrentHeight-64)];
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"help" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];

    [self.view addSubview:webView];
    
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
