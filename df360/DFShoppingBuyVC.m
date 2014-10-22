//
//  DFShoppingBuyVC.m
//  df360
//
//  Created by wangxl on 14/10/20.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFShoppingBuyVC.h"

@interface DFShoppingBuyVC ()
{
    NSInteger num;
    
    NSInteger price;
}
@end

@implementation DFShoppingBuyVC

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
    
    num = 1;
    price = [[self.senderDic objectForKey:@"goods_price"] integerValue];
    
    self.WTitle = @"购买";
    self.WLeftBarStyle = LeftBarStyleDefault;
    self.WRightBarStyle = RightBarStyleClick;
    
    self.titleLabel.text = [self.senderDic objectForKey:@"goods_title"];
    self.priceLabel.text = [NSString stringWithFormat:@"%@元",[self.senderDic objectForKey:@"goods_price"]];
    self.countLabel.text = @"1";
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"%@元",[self.senderDic objectForKey:@"goods_price"]];
    
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

- (IBAction)subtractionSelected:(id)sender {
    
    if (num != 1) {
        num --;
        self.countLabel.text = [NSString stringWithFormat:@"%ld",num];
        self.totalPriceLabel.text = [NSString stringWithFormat:@"%ld", num * price];
    }
    
}

- (IBAction)plusSelected:(id)sender {
    
    num ++;
    self.countLabel.text = [NSString stringWithFormat:@"%ld",num];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"%ld", num * price];
    
}

- (IBAction)buySelected:(id)sender {
    
}
@end
