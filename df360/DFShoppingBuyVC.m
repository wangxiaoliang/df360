//
//  DFShoppingBuyVC.m
//  df360
//
//  Created by wangxl on 14/10/20.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFShoppingBuyVC.h"
#import "DFToolClass.h"
#import "DFLoginVC.h"
#import "DFToolView.h"
#import "AFNetworking.h"
#import "DFMyTGDetail.h"

@interface DFShoppingBuyVC ()<DFHudProgressDelegate,UIAlertViewDelegate>
{
    NSInteger num;
    
    NSInteger price;
    
    DFHudProgress *_hud;
    
    NSDictionary *TGDic;
    
    BOOL status;
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
    
    _hud = [[DFHudProgress alloc] init];
    
    _hud.delegate = self;
    
    num = 1;
    price = [[self.senderDic objectForKey:@"goods_price"] integerValue];
    
    self.WTitle = @"购买";
    self.WLeftBarStyle = LeftBarStyleDefault;
    self.WRightBarStyle = RightBarStyleClick;
    
    
    [self.titleLabel setNumberOfLines:0];
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSString *s =[self.senderDic objectForKey:@"goods_title"];
    
    self.titleLabel.text = s;
    
    CGFloat height = [DFToolClass heightOfLabel:s forFont:[UIFont systemFontOfSize:14] labelLength:KCurrentWidth - 130];
    
    [self.titleLabel setFrame:CGRectMake(100, 5, KCurrentWidth - 130, height + 10)];
    
    [self.gtitle setFrame:CGRectMake(28, 5, 100, height + 10)];
    
    self.priceLabel.text = [NSString stringWithFormat:@"%@元",[self.senderDic objectForKey:@"goods_price"]];
    self.countLabel.text = @"1";
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"%@元",[self.senderDic objectForKey:@"goods_price"]];
    
    float addHeight = height - 33 + 10;
    
    CGRect downRect = self.downView.frame;
    
    downRect.origin.y += addHeight;
    
    [self.downView setFrame:downRect];
    
    CGRect btnRect = self.payBtn.frame;
    
    btnRect.origin.y += addHeight;
    
    [self.payBtn setFrame:btnRect];
    
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
        self.countLabel.text = [NSString stringWithFormat:@"%d",num];
        self.totalPriceLabel.text = [NSString stringWithFormat:@"%d", num * price];
    }
    
}

- (IBAction)plusSelected:(id)sender {
    
    num ++;
    self.countLabel.text = [NSString stringWithFormat:@"%d",num];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"%d", num * price];
    
}

- (IBAction)buySelected:(id)sender {
    if ([DFToolClass isLogin]) {
        
        NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
        
        NSString *uid = [df objectForKey:@"uid"];
        
        NSString *username = [df objectForKey:@"username"];
        
        NSDate *datenow = [NSDate date];
        
        NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[datenow timeIntervalSince1970]];
        
        NSString *shopId = [self.senderDic objectForKey:@"shop_id"];
        
        NSString *shopTitle = [self.senderDic objectForKey:@"shop_title"];
        
        NSString *goodsTitle = [self.senderDic objectForKey:@"goods_title"];
        
        NSString *goodsId = [self.senderDic objectForKey:@"goods_id"];
        
        NSString *goodsPrice = [self.senderDic objectForKey:@"goods_price"];

        NSString *goodsSum = self.countLabel.text;
        
        NSString *goodsStatus = @"0";

        
        [_hud show];
        
        NSString *url = @"http://www.df360.cc/df360/api/tuan_order";
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *para = @{@"member_uid":uid,@"member_username":username,@"orderlist_allprice":self.totalPriceLabel.text,@"orderlist_time":timeSp,@"orderlist_remarks":@"",@"orderlist_usestatus":goodsStatus,@"shop_id":shopId,@"shop_title":shopTitle,@"goods_title":goodsTitle,@"goods_id":goodsId,@"goods_price":goodsPrice,@"goods_sum":goodsSum};
        
        NSLog(@"%@",para);
        
//        manager.requestSerializer = [AFJSONRequestSerializer serializer];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
//        
//        [manager POST:url parameters:para success:^(AFHTTPRequestOperation *operation,id responseObject){
//            NSLog(@"json:%@",responseObject);
//            
//            [_hud dismiss];
//        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
//            NSLog(@"error:%@",error);
//            [_hud dismiss];
//        }];
        
        [manager GET:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"response ==== %@",responseObject);
            
            TGDic = [[NSDictionary alloc] initWithDictionary:[responseObject objectForKey:@"data"]];
            
            status = (BOOL)[responseObject objectForKey:@"status"];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[responseObject objectForKey:@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            
            [alert show];
            
            [_hud dismiss];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [_hud dismiss];
            
        }];
        
        
    }
    else
    {
        DFLoginVC *login = [[DFLoginVC alloc] init];
        
        [self.navigationController pushViewController:login animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (status) {
        UIStoryboard *storyboard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DFMyTGDetail *detail = [storyboard instantiateViewControllerWithIdentifier:@"MyTGDetail"];
        
        detail.senderDic = TGDic;
        
        detail.isTG = YES;
        
        [self.navigationController pushViewController:detail animated:YES];    }
}

@end
