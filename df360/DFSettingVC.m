//
//  DFSettingVC.m
//  df360
//
//  Created by wangxl on 14-9-2.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFSettingVC.h"
#import "DFToolClass.h"
#import "UMFeedbackViewController.h"

@interface DFSettingVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_titleArr;
    
    NSArray *_imgArr;
}
@end

@implementation DFSettingVC

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
    _titleArr = [[NSArray alloc] initWithObjects:@"版本更新",@"用户反馈",@"帮助",@"关于我们", nil];
    
    _imgArr = [[NSArray alloc] initWithObjects:@"ic_update",@"ic_feedback",@"ic_help",@"ic_about", nil];
    self.WLeftBarStyle = LeftBarStyleDefault;
    self.WRightBarStyle = RightBarStyleNone;
    self.WTitle = @"设置";
    
    UISearchBar *search = (UISearchBar *)[self.navigationController.navigationBar viewWithTag:1];
    search.hidden = YES;
    
    [self buildUI];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)buildUI
{
    self.view.backgroundColor = [DFToolClass getColor:@"e5e5e5"];

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, KCurrentWidth, 176) style:UITableViewStylePlain];
    
    tableView.backgroundColor = [UIColor whiteColor];
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
}

#pragma mark - tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"settingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    cell.textLabel.text = [_titleArr objectAtIndex:indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:[_imgArr objectAtIndex:indexPath.row]];
    
    UILabel *label = (UILabel *)cell.textLabel;
    
    label.frame = CGRectMake(0, 0, KCurrentWidth, 44);
    
    label.textAlignment = NSTextAlignmentLeft;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        [self nativeFeedback];
    }
    if (indexPath.row == 2) {
        [self performSegueWithIdentifier:@"help" sender:nil];
    }
}
- (void)nativeFeedback
{
    [self showNativeFeedbackWithAppkey:UMENG_APPKEY];
}

- (void)showNativeFeedbackWithAppkey:(NSString *)appkey {
    UMFeedbackViewController *feedbackViewController = [[UMFeedbackViewController alloc] initWithNibName:@"UMFeedbackViewController" bundle:nil];
    feedbackViewController.appkey = appkey;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:feedbackViewController];
    //    navigationController.navigationBar.barStyle = UIBarStyleBlack;
    //    navigationController.navigationBar.translucent = NO;
    [self presentViewController:navigationController animated:YES completion:nil];

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
