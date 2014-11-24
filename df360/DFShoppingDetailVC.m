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
#import "UMSocial.h"
#import "DFLoginVC.h"

#define collectTag    990

@interface DFShoppingDetailVC ()<DFHudProgressDelegate,WCustomVCDelegate>
{
    DFHudProgress *_hud;
    
    NSDictionary *_dataDic;
    
    NSString *_shareText;
    
    UIImage *_shareImg;
    
    UIImageView *_imageView;
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
    
    self.delegate = self;

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
//    [self.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.df360.cc/%@",self.goodPic]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
//
//    self.haveSeedLabel.text = [NSString stringWithFormat:@"已有%@人浏览",[_dataDic objectForKey:@"goods_view"]];
//    self.titleLabel.text = [_dataDic objectForKey:@"goods_title"];
//    self.infoTextView.text = [_dataDic objectForKey:@"goods_text"];
//    self.introductionTextView.text = [_dataDic objectForKey:@"goods_instruction"];
//    
//    
//    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[_dataDic objectForKey:@"goods_end_time"] floatValue]];
//    
//    NSDateFormatter * df = [[NSDateFormatter alloc] init];
//    [df setDateFormat:@"yyyy-MM-dd"];
//    NSString *regStr = [df stringFromDate:confromTimesp];
//    
//    self.noticeTextView.text = [NSString stringWithFormat:@"团购结束时间：%@",regStr];
//    
//    self.nowPriceLabel.text = [NSString stringWithFormat:@"%@元",[_dataDic objectForKey:@"goods_price"]];
//    
//    self.oldPriceLabel.text = [NSString stringWithFormat:@"%@元",[_dataDic objectForKey:@"goods_market_price"]];
    
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [collectBtn setFrame:CGRectMake(KCurrentWidth - 80, 6, 30, 30)];
    
    [collectBtn setImage:[UIImage imageNamed:@"wb_collect_normal"] forState:UIControlStateNormal];
    
    [collectBtn addTarget:self action:@selector(collectShopping) forControlEvents:UIControlEventTouchUpInside];
    
    collectBtn.tag = collectTag;
    
    [self.navigationController.navigationBar addSubview:collectBtn];
    
    UIScrollView *backScrolView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KCurrentWidth, KCurrentHeight)];
    
    backScrolView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:backScrolView];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KCurrentWidth, 250)];
    
    topView.backgroundColor = [UIColor whiteColor];
    
    [backScrolView addSubview:topView];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KCurrentWidth, 150)];
    
    
    [_imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.df360.cc/%@",self.goodPic]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    [topView addSubview:_imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, KCurrentWidth, 20)];
    
    titleLabel.text = [_dataDic objectForKey:@"goods_title"];
    
    titleLabel.font = [UIFont systemFontOfSize:18];
    
    titleLabel.textColor = [UIColor whiteColor];
    
    titleLabel.textAlignment = NSTextAlignmentLeft;
    
    [topView addSubview:titleLabel];
    
    UILabel *nowPrice = [[UILabel alloc] initWithFrame:CGRectMake(10, 180, 20, 20)];
    
    UILabel *oldPrice = [[UILabel alloc] initWithFrame:CGRectMake(50, 180, 20, 20)];
    
    nowPrice.font = [UIFont systemFontOfSize:30];
    
    CGFloat nowWigth = [DFToolClass widthOfLabel:[NSString stringWithFormat:@"%@元",[_dataDic objectForKey:@"goods_price"]] ForFont:[UIFont systemFontOfSize:30] labelHeight:20];
    
    nowPrice.textColor = [UIColor orangeColor];
    
    NSMutableAttributedString *nowAttriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元",[_dataDic objectForKey:@"goods_price"]]];
    
    NSString *nowPriceStr = [_dataDic objectForKey:@"goods_price"];
    
    NSInteger nowPriceLength = nowPriceStr.length;
    
    [nowAttriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(nowPriceLength, 1)];
    
    nowPrice.attributedText = nowAttriStr;
    
    [nowPrice setFrame:CGRectMake(10, 180, nowWigth, 20)];
    
    //
    
//    oldPrice.font = [UIFont systemFontOfSize:25];
    
    CGFloat oldWigth = [DFToolClass widthOfLabel:[NSString stringWithFormat:@"%@元",[_dataDic objectForKey:@"goods_market_price"]] ForFont:[UIFont systemFontOfSize:25] labelHeight:20];
    
    nowPrice.textColor = [UIColor orangeColor];
    
    nowAttriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元",[_dataDic objectForKey:@"goods_market_price"]]];
    
    nowPriceStr = [_dataDic objectForKey:@"goods_market_price"];
    
    nowPriceLength = nowPriceStr.length;
    
    [nowAttriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(nowPriceLength, 1)];
    
    oldPrice.attributedText = nowAttriStr;
    
    [oldPrice setFrame:CGRectMake(10 + nowWigth, 185, oldWigth, 20)];
    
    [topView addSubview:oldPrice];
    
    [topView addSubview:nowPrice];

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10 + nowWigth, 195, oldWigth - 15, 0.5)];
    
    line.backgroundColor = [UIColor blackColor];
    
    
    [topView addSubview:line];
    
    UIImageView *tkImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 220, 20, 20)];
    
    tkImg.image = [UIImage imageNamed:@"ic_global_deal_exchange"];
    
    [topView addSubview:tkImg];
    
    UILabel *tkLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 220, 100, 20)];
    
    tkLabel.text = @"支持退款";
    
    tkLabel.textAlignment = NSTextAlignmentLeft;
    
    tkLabel.font = [UIFont systemFontOfSize:20];
    
    [topView addSubview:tkLabel];
    
    UIImageView *saleImg = [[UIImageView alloc] initWithFrame:CGRectMake(150, 220, 20, 20)];
    
    saleImg.image = [UIImage imageNamed:@"ic_global_deal_sell"];
    
    [topView addSubview:saleImg];
    
    UILabel *saleLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 220, 100, 20)];
    
    saleLabel.text = [NSString stringWithFormat:@"已售%@",[_dataDic objectForKey:@"goods_sellsum"]];
    
    saleLabel.textAlignment = NSTextAlignmentLeft;
    
    saleLabel.font = [UIFont systemFontOfSize:20];
    
    [topView addSubview:saleLabel];

    line = [[UIView alloc] initWithFrame:CGRectMake(0, 250, KCurrentWidth, 0.5)];
    
    line.backgroundColor = [DFToolClass getColor:@"e0e0e0"];
    
    [backScrolView addSubview:line];
    
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    buyBtn.backgroundColor = [UIColor orangeColor];
    
    [buyBtn setTitle:@"立即抢购" forState:UIControlStateNormal];
    
    [buyBtn addTarget:self action:@selector(buySelected:) forControlEvents:UIControlEventTouchUpInside];
    
    [buyBtn setFrame:CGRectMake(KCurrentWidth - 100, 170, 90, 35)];
    
    [topView addSubview:buyBtn];
    
    line = [[UIView alloc] initWithFrame:CGRectMake(0, 269.5, KCurrentWidth, 0.5)];
    
    line.backgroundColor = [DFToolClass getColor:@"e0e0e0"];
    
    [backScrolView addSubview:line];

    
    UIView *scoreView = [[UIView alloc] initWithFrame:CGRectMake(0, 270, KCurrentWidth, 44)];
    
    scoreView.backgroundColor = [UIColor whiteColor];
    
    line = [[UIView alloc] initWithFrame:CGRectMake(0, 314, KCurrentWidth, 0.5)];
    
    line.backgroundColor = [DFToolClass getColor:@"e0e0e0"];
    
    [backScrolView addSubview:line];
    
    for (int i = 0; i < 5; i ++) {
        UIImageView *scoreImge = [[UIImageView alloc] initWithFrame:CGRectMake(10 + 25 * i, 12, 20, 20)];
        
        scoreImge.image = [UIImage imageNamed:@"ic_rating_star_small_off"];
        
        scoreImge.tag = i;
        
        [scoreView addSubview:scoreImge];
    }
    
    NSString *scroeStr = [DFToolClass stringISNULL:[_dataDic objectForKey:@"good_grade"]];
    
    float scroef = 0.0;
    
    if (![scroeStr isEqualToString:@""]) {
        scroef = scroeStr.floatValue;
    }

    if (scroef >= 2) {
        UIImageView *img = (UIImageView *)[scoreView viewWithTag:0];
        
        img.image = [UIImage imageNamed:@"ic_rating_star_small_on"];
    }
    
    else if (scroef >= 4)
    {
        UIImageView *img = (UIImageView *)[scoreView viewWithTag:1];
        
        img.image = [UIImage imageNamed:@"ic_rating_star_small_on"];
    }
    
    else if (scroef >= 6)
    {
        UIImageView *img = (UIImageView *)[scoreView viewWithTag:2];
        
        img.image = [UIImage imageNamed:@"ic_rating_star_small_on"];
    }

    else if (scroef >= 8)
    {
        UIImageView *img = (UIImageView *)[scoreView viewWithTag:3];
        
        img.image = [UIImage imageNamed:@"ic_rating_star_small_on"];
    }

    else if (scroef >= 10)
    {
        UIImageView *img = (UIImageView *)[scoreView viewWithTag:4];
        
        img.image = [UIImage imageNamed:@"ic_rating_star_small_on"];
    }

    UILabel *scroeLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 12, 60, 20)];
    
    scroeLabel.text = [NSString stringWithFormat:@"%0.1f分",scroef];
    
    scroeLabel.font = [UIFont systemFontOfSize:16];
    
    scroeLabel.textColor = [UIColor lightGrayColor];
    
    [scoreView addSubview:scroeLabel];
    
    UILabel *pjLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 12, 120, 20)];
    
    pjLabel.text = @"查看全部评价 >";
    
    pjLabel.font = [UIFont systemFontOfSize:16];
    
    pjLabel.textColor = [UIColor lightGrayColor];
    
    [scoreView addSubview:pjLabel];
    
    [backScrolView addSubview:scoreView];
    
    line = [[UIView alloc] initWithFrame:CGRectMake(0, 328.5, KCurrentWidth, 0.5)];
    
    line.backgroundColor = [DFToolClass getColor:@"e0e0e0"];
    
    [backScrolView addSubview:line];
    
    UIView *goodsInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 329, KCurrentWidth, 40)];
    
    line = [[UIView alloc] initWithFrame:CGRectMake(0, 40, KCurrentWidth, 0.5)];
    
    line.backgroundColor = [DFToolClass getColor:@"e0e0e0"];
    
    [goodsInfoView addSubview:line];
    
    UILabel *sjxx = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    
    sjxx.text = @"商家信息";
    
    sjxx.textColor = [UIColor lightGrayColor];
    
    sjxx.font = [UIFont systemFontOfSize:20];
    
    sjxx.textAlignment = NSTextAlignmentLeft;
    
    [goodsInfoView addSubview:sjxx];
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 260, 10)];
    
    infoLabel.font = [UIFont systemFontOfSize:16];
    
    infoLabel.text = [_dataDic objectForKey:@"goods_title"];
    
    CGFloat height = [DFToolClass heightOfLabel:[_dataDic objectForKey:@"goods_title"] forFont:[UIFont systemFontOfSize:16] labelLength:260];
    
    infoLabel.numberOfLines = 0;
    
    [infoLabel setFrame:CGRectMake(10, 40, 260, 20 + height)];
    
    [goodsInfoView addSubview:infoLabel];
    
    [goodsInfoView setFrame:CGRectMake(0 , 329, KCurrentWidth, 60 + height)];
    
    goodsInfoView.backgroundColor = [UIColor whiteColor];
    
    [backScrolView addSubview:goodsInfoView];
    
    
    line = [[UIView alloc] initWithFrame:CGRectMake(0, 329 + 60 + height, KCurrentWidth, 0.5)];
    
    line.backgroundColor = [DFToolClass getColor:@"e0e0e0"];
    
    [backScrolView addSubview:line];
    
    CGFloat tgInfoY = 400+height;
    
    UIView *tgInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, tgInfoY, KCurrentWidth, 40)];
    
    line = [[UIView alloc] initWithFrame:CGRectMake(0, 40, KCurrentWidth, 0.5)];
    
    line.backgroundColor = [DFToolClass getColor:@"e0e0e0"];
    
    [tgInfoView addSubview:line];
    
    UILabel *tgxx = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    
    tgxx.text = @"团购信息";
    
    tgxx.textColor = [UIColor lightGrayColor];
    
    tgxx.font = [UIFont systemFontOfSize:20];
    
    tgxx.textAlignment = NSTextAlignmentLeft;
    
    [tgInfoView addSubview:tgxx];
    
    tgInfoView.backgroundColor = [UIColor whiteColor];

    [backScrolView addSubview:tgInfoView];

    UILabel *tgInfo = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 260, 10)];
    
    tgInfo.font = [UIFont systemFontOfSize:16];
    
    tgInfo.text = [_dataDic objectForKey:@"goods_text"];
    
    CGFloat tgHeight = [DFToolClass heightOfLabel:[_dataDic objectForKey:@"goods_text"] forFont:[UIFont systemFontOfSize:16] labelLength:260];
    
    tgInfo.numberOfLines = 0;
    
    [tgInfo setFrame:CGRectMake(10, 40, KCurrentWidth-20,  tgHeight)];
    
    [tgInfoView addSubview:tgInfo];
    
    [tgInfoView setFrame:CGRectMake(0, tgInfoY, KCurrentWidth, 210 + tgHeight)];
    
    UILabel *yxqTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, tgHeight + 40, 200, 15)];
    
    yxqTitle.text = @"有效期:";
    
    yxqTitle.font = [UIFont systemFontOfSize:16];
    
    yxqTitle.textColor = [UIColor orangeColor];
    
    yxqTitle.textAlignment = NSTextAlignmentLeft;
    
    [tgInfoView addSubview:yxqTitle];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[_dataDic objectForKey:@"goods_yzm_begin_time"] floatValue]];
    
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yy-MM-dd"];
    NSString *beginTime = [df stringFromDate:confromTimesp];
    
    NSDate *endTimesp = [NSDate dateWithTimeIntervalSince1970:[[_dataDic objectForKey:@"goods_yzm_end_time"] floatValue]];
    
    NSString *endTime = [df stringFromDate:endTimesp];

    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, tgHeight + 65, 200, 15)];
    
    timeLabel.text = [NSString stringWithFormat:@"%@至%@",beginTime,endTime];
    
    timeLabel.font = [UIFont systemFontOfSize:16];
    
    timeLabel.textAlignment = NSTextAlignmentLeft;
    
    [tgInfoView addSubview:timeLabel];
    
    
    UILabel *gzTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, tgHeight + 90, 200, 15)];
    
    gzTitle.text = @"使用规则：";
    
    gzTitle.font = [UIFont systemFontOfSize:16];
    
    gzTitle.textColor = [UIColor orangeColor];
    
    gzTitle.textAlignment = NSTextAlignmentLeft;
    
    [tgInfoView addSubview:gzTitle];
    
    UILabel *gz1 = [[UILabel alloc] initWithFrame:CGRectMake(10, tgHeight + 115, 200, 15)];
    
    gz1.text = @"· 不可叠加使用";
    
    gz1.font = [UIFont systemFontOfSize:16];
    
    gz1.textAlignment = NSTextAlignmentLeft;
    
    [tgInfoView addSubview:gz1];
    
    UILabel *gz2 = [[UILabel alloc] initWithFrame:CGRectMake(10, tgHeight + 140, 300, 15)];
    
    gz2.text = @"· 部分地区需先咨询商家再预定";
    
    gz2.font = [UIFont systemFontOfSize:16];
    
    gz2.textAlignment = NSTextAlignmentLeft;
    
    [tgInfoView addSubview:gz2];

    UILabel *gz3 = [[UILabel alloc] initWithFrame:CGRectMake(10, tgHeight + 165, 300, 15)];
    
    gz3.text = @"· 团购商品不能同时享受其他优惠";
    
    gz3.font = [UIFont systemFontOfSize:16];
    
    gz3.textAlignment = NSTextAlignmentLeft;
    
    [tgInfoView addSubview:gz3];

    UILabel *gz4 = [[UILabel alloc] initWithFrame:CGRectMake(10, tgHeight + 190, 300, 15)];
    
    gz4.text = @"· 值得信赖的商家";
    
    gz4.font = [UIFont systemFontOfSize:16];
    
    gz4.textAlignment = NSTextAlignmentLeft;
    
    [tgInfoView addSubview:gz4];

    line = [[UIView alloc] initWithFrame:CGRectMake(0, tgInfoY + 210 + tgHeight, KCurrentWidth, 0.5)];
    
    line.backgroundColor = [DFToolClass getColor:@"e0e0e0"];
    
    [backScrolView addSubview:line];

    float pjY = tgInfoY + 220 + tgHeight;
    
    line = [[UIView alloc] initWithFrame:CGRectMake(0, pjY, KCurrentWidth, 0.5)];
    
    line.backgroundColor = [DFToolClass getColor:@"e0e0e0"];
    
    [backScrolView addSubview:line];
    
    UIView *pjView = [[UIView alloc] initWithFrame:CGRectMake(0, pjY, KCurrentWidth, 44)];
    
    pjView.backgroundColor = [UIColor whiteColor];
    
    UILabel *pjTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    
    pjTitle.text = @"评价";
    
    pjTitle.textColor = [UIColor lightGrayColor];
    
    pjTitle.font = [UIFont systemFontOfSize:20];
    
    pjTitle.textAlignment = NSTextAlignmentLeft;
    
    [pjView addSubview:pjTitle];
    
    [backScrolView addSubview:pjView];
    
    
    [goodsInfoView setFrame:CGRectMake(0 , 329, KCurrentWidth, 60 + height)];
    
    
    backScrolView.contentSize = CGSizeMake(KCurrentWidth, pjY + 44);
    

    
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

- (void)share:(UIButton *)sender
{
    _shareImg = _imageView.image;
    
    _shareText = [_dataDic objectForKey:@"goods_text"];
    
    [UMSocialData defaultData].extConfig.title = @"登封360";
    
    NSInteger shareTag = [sender tag];
    
    switch (shareTag) {
        case 0:
        {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:_shareText image:_shareImg location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                    [self alertWithTitle:@"分享成功!"];
                }
                else
                {
                    [self alertWithTitle:@"分享失败!"];
                }
            }];
 
        }
        break;
        case 1:
        {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:_shareText image:_shareImg location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                    [self alertWithTitle:@"分享成功!"];
                }
                else
                {
                    [self alertWithTitle:@"分享失败!"];
                }
            }];
        }
            break;
        case 2:
        {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:_shareText image:_shareImg location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                    [self alertWithTitle:@"分享成功!"];
                }
                else
                {
                    [self alertWithTitle:@"分享失败!"];
                }
            }];
        }
            break;
            case 3:
        {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:_shareText image:_shareImg location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                    [self alertWithTitle:@"分享成功!"];
                }
                else
                {
                    [self alertWithTitle:@"分享失败!"];
                }
            }];
        }
            break;
            case 4:
        {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:_shareText image:_shareImg location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                    [self alertWithTitle:@"分享成功!"];
                }
                else
                {
                    [self alertWithTitle:@"分享失败!"];
                }
            }];
        }
            break;
        default:
            break;
    }
}

- (void)collectShopping
{
    if ([DFToolClass isLogin]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSString *userId = [defaults objectForKey:@"uid"];
        
        NSString *goods_id = [_dataDic objectForKey:@"goods_id"];
        
        [_hud show];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:[DFRequestUrl tuanFavWithUserId:userId withGoods_id:goods_id] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"JSON: %@", responseObject);
            
            NSString *msg = [responseObject objectForKey:@"msg"];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            
            [alert show];
            
            [_hud dismiss];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            [_hud dismiss];
        }];

    }
    else
    {
        UIStoryboard *storyboard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DFLoginVC *login = [storyboard instantiateViewControllerWithIdentifier:@"DFLoginVC"];
        [self.navigationController pushViewController:login animated:YES];

    }
    
}

- (IBAction)buySelected:(id)sender {
    
    if ([DFToolClass isLogin]) {
        [self performSegueWithIdentifier:@"shoppingBuy" sender:_dataDic];
    }
    else
    {
        UIStoryboard *storyboard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DFLoginVC *login = [storyboard instantiateViewControllerWithIdentifier:@"DFLoginVC"];
        [self.navigationController pushViewController:login animated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"shoppingBuy"]) {
        DFShoppingBuyVC *buy = (DFShoppingBuyVC *)segue.destinationViewController;
        buy.senderDic = sender;
    }
}

- (void)alertWithTitle:(NSString *)str
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)viewWillAppear:(BOOL)animated
{
    UIButton *collectBtn = (UIButton *)[self.navigationController.navigationBar viewWithTag:collectTag];
    
    collectBtn.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    UIButton *collectBtn = (UIButton *)[self.navigationController.navigationBar viewWithTag:collectTag];
    
    collectBtn.hidden = YES;
}

@end
