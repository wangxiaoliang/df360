//
//  DFShoppingDetailVC.m
//  df360
//
//  Created by wangxl on 14-10-19.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFShoppingDetailVC.h"
#import "DFRequestUrl.h"
#import "AFNetworking.h"
#import "DFToolClass.h"
#import "DFToolView.h"
#import "UIImageView+WebCache.h"
#import "DFShoppingBuyVC.h"

@interface DFShoppingDetailVC ()<DFHudProgressDelegate>
{
    DFHudProgress *_hud;
    
    NSDictionary *_dataDic;
}
@end

@implementation DFShoppingDetailVC

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
    UISearchBar *search = (UISearchBar *)[self.navigationController.navigationBar viewWithTag:1];
    search.hidden = YES;
    
    self.WTitle = @"团购详情";
    self.WLeftBarStyle = LeftBarStyleDefault;
    self.WRightBarStyle = RightBarStyleDefault;

    _dataDic = [[NSDictionary alloc] init];
    
    _hud = [[DFHudProgress alloc] init];
    _hud.delegate = self;
    
    [self getTGGoods];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)getTGGoods
{
    [_hud show];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[DFRequestUrl TGInfoWithID:self.catId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        _dataDic = [responseObject objectForKey:@"data"];
        
        [self buildUI];
        [_hud dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        [_hud dismiss];
        }];
    
}


- (void)buildUI
{
    [self.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.df360.cc/%@",self.goodPic]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    self.haveSeedLabel.text = [NSString stringWithFormat:@"已有%@人浏览",[_dataDic objectForKey:@"goods_view"]];
    self.titleLabel.text = [_dataDic objectForKey:@"goods_title"];
    self.infoTextView.text = [_dataDic objectForKey:@"goods_text"];
    self.introductionTextView.text = [_dataDic objectForKey:@"goods_instruction"];
    
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[_dataDic objectForKey:@"goods_end_time"] floatValue]];
    
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *regStr = [df stringFromDate:confromTimesp];
    
    self.noticeTextView.text = [NSString stringWithFormat:@"团购结束时间：%@",regStr];
    
    self.nowPriceLabel.text = [NSString stringWithFormat:@"%@元",[_dataDic objectForKey:@"goods_price"]];
    
    self.oldPriceLabel.text = [NSString stringWithFormat:@"%@元",[_dataDic objectForKey:@"goods_market_price"]];
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

- (IBAction)buySelected:(id)sender {
    
    [self performSegueWithIdentifier:@"shoppingBuy" sender:_dataDic];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"shoppingBuy"]) {
        DFShoppingBuyVC *buy = (DFShoppingBuyVC *)segue.destinationViewController;
        buy.senderDic = sender;
    }
}

@end
