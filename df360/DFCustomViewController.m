//
//  DFCustomViewController.m
//  df360
//
//  Created by wangxl on 14-9-15.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFCustomViewController.h"
#import "DFToolClass.h"


#define ShareBGViewTag  101
#define ShareViewTag  102
#define ShareCount 5

#define KCurrentWidth self.view.bounds.size.width

#define KCurrentHeight self.view.bounds.size.height

@interface DFCustomViewController ()
{
    NSArray *arrTitle;
    NSArray *arrNarmalImg;
    NSArray *arrHighImg;
}
@end

@implementation DFCustomViewController

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
    /*********   导航栏的颜色及下方分割线 ********/
    if (self.WNavigationColor == UINavigationLineColorDefault) {
        UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KCurrentWidth, 0.5)];
        viewLine.backgroundColor = [DFToolClass getColor:@"b2b2b2"];
        [self.view addSubview:viewLine];
        [self.view bringSubviewToFront:viewLine];
    }
    else
    {
        UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KCurrentWidth, 0.5)];
        viewLine.backgroundColor = [DFToolClass getColor:@"ea4940"];
        [self.view addSubview:viewLine];
        [self.view bringSubviewToFront:viewLine];

    }
    
    [[UINavigationBar appearance] setAlpha:0.9f];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        if (self.WExtendedLayout == ExtendedLayoutBottom) {
            self.edgesForExtendedLayout = UIRectEdgeBottom;
        }
        else {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    
    /*********   self.view,backgroundColor ********/
    if (self.WBackGroundColorStyle == UIViewBackGroundColorDefault) {
        self.view.backgroundColor = [DFToolClass getColor:@"f4f4f4"];
    }
    else if (self.WBackGroundColorStyle == UIViewBackGroundColorCustom) {
        
    }
    
    /*********   LeftBarItem ********/
    if (self.WLeftBarStyle == LeftBarStyleDefault) {
        UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnBack setBackgroundImage:[UIImage imageNamed:@"navBar_arrow.png"] forState:UIControlStateNormal];
        [btnBack setBackgroundImage:[UIImage imageNamed:@"navBar_arrow_press.png"] forState:UIControlStateHighlighted];
        btnBack.frame = CGRectMake(0, 0, 12, 20);
        btnBack.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 15);
        [btnBack addTarget:self action:@selector(doback) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
        self.navigationItem.leftBarButtonItem = item;
    }
    else if (self.WLeftBarStyle == LeftBarStyleClick)
    {
        UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnBack setBackgroundImage:[UIImage imageNamed:@"yy_navbar_arrow.png"] forState:UIControlStateNormal];
        [btnBack setBackgroundImage:[UIImage imageNamed:@"yy_navbar_arrow_press.png"] forState:UIControlStateHighlighted];
        btnBack.frame = CGRectMake(0, 0, 12, 20);
        btnBack.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 15);
        [btnBack addTarget:self action:@selector(doback) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
        self.navigationItem.leftBarButtonItem = item;
    }
    else
    {
     //do nothing
    }
    /*********   RightBarItem ********/
    if (self.WRightBarStyle == RightBarStyleDefault) {
        UIButton *btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
        btnShare.frame = CGRectMake(0, 0, 20, 20);
        [btnShare setBackgroundImage:[UIImage imageNamed:@"navbar_btn_share.png"] forState:UIControlStateNormal];
        [btnShare setBackgroundImage:[UIImage imageNamed:@"navbar_btn_share_press.png"] forState:UIControlStateHighlighted];
        btnShare.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, -10);
        [btnShare addTarget:self action:@selector(doShare) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnShare];
        self.navigationItem.rightBarButtonItem = item;
        
        arrTitle = [[NSArray alloc] initWithObjects:@"微信好友", @"微信朋友圈", @"新浪微博", @"QQ好友", @"QQ空间", nil];
        
        arrNarmalImg = [[NSArray alloc] initWithObjects:@"share_icon_wx.png", @"share_icon_pyq.png", @"share_icon_xl.png", @"share_icon_qq.png", @"share_icon_zone.png", nil];
        
        arrHighImg = [[NSArray alloc] initWithObjects:@"share_icon_wx_press.png", @"share_icon_pyq_press.png", @"share_icon_xl_press.png", @"share_icon_qq_press.png", @"share_icon_zone_press.png", nil];
    }
    else
    {
        //do nothing
    }
    
    /*********   导航栏title ********/
    if (_WTitle.length >0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.frame = CGRectMake(0, 0, 20, 22);
        label.text = _WTitle;
        label.font = [UIFont systemFontOfSize:18];
        if (self.WLeftBarStyle == LeftBarStyleClick) {
            label.textColor = [UIColor whiteColor];
        }
        else
        {
            label.textColor = [DFToolClass getColor:@"434343"];
        }
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = label;
        
    }
    
    self.touchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KCurrentWidth, KCurrentHeight - 64)];
    self.touchView.backgroundColor = [UIColor clearColor];
    self.touchView.hidden = YES;
    UILabel *lb1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 154, KCurrentWidth, 25)];
    lb1.backgroundColor = [UIColor clearColor];
    lb1.text = @"网络不给力哦!";
    lb1.textColor = [DFToolClass getColor:@"b3b3b3"];
    lb1.textAlignment = NSTextAlignmentCenter;
    lb1.font = [UIFont systemFontOfSize:24];
    [self.touchView addSubview:lb1];
    
    UILabel *lb2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 187, KCurrentWidth, 16)];
    lb2.backgroundColor = [UIColor clearColor];
    lb2.text = @"请检查网络后重试";
    lb2.textColor = [DFToolClass getColor:@"b3b3b3"];
    lb2.textAlignment = NSTextAlignmentCenter;
    lb2.font = [UIFont systemFontOfSize:15];
    [self.touchView addSubview:lb2];
    
    UILabel *lb3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 208, KCurrentWidth, 16)];
    lb3.backgroundColor = [UIColor clearColor];
    lb3.text = @"或轻触屏幕重新加载";
    lb3.textColor = [DFToolClass getColor:@"b3b3b3"];
    lb3.textAlignment = NSTextAlignmentCenter;
    lb3.font = [UIFont systemFontOfSize:15];
    [self.touchView addSubview:lb3];
    [self.view addSubview:self.touchView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadAgain)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    [self.touchView addGestureRecognizer:tapGesture];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)reloadAgain
{
    //do nothing;
    NSLog(@"reload");
}
//返回按钮
- (void)doback
{
    if ([self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]) {
        if ([self.delegate respondsToSelector:@selector(didPopViewController)]) {
            [self.delegate didPopViewController];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - share

- (void)doShare
{
    //分享界面灰色透明背景
    UIControl *bgView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, KCurrentWidth, KCurrentHeight)];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.tag = ShareBGViewTag;
    bgView.alpha = 0.0f;
    [bgView addTarget:self action:@selector(hideShareView) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    
    //分享界面 按钮背景图
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, KCurrentHeight, KCurrentWidth, 300)];
    view.backgroundColor = [UIColor whiteColor];
    view.tag = ShareViewTag;
    
    //线条
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 224, KCurrentWidth, 0.5)];
    lineView.backgroundColor = [DFToolClass getColor:@"b2b2b2"];
    [view addSubview:lineView];
    
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.frame = CGRectMake(0, 224, KCurrentWidth, 52);
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(hideShareView) forControlEvents:UIControlEventTouchUpInside];
    btnCancel.titleLabel.font = [UIFont systemFontOfSize:22];
    [btnCancel setTitleColor:[DFToolClass getColor:@"ea4940"] forState:UIControlStateNormal];
    [view addSubview:btnCancel];
    
    //分享平台的标题
    for (NSInteger i = 0; i < ShareCount; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn addTarget:self action:@selector(shareSNS:) forControlEvents:UIControlEventTouchUpInside];
        if (i>2) {
            label.frame = CGRectMake(18 + (i - 3) * 110, 88 + 105, 65, 16);
            btn.frame = CGRectMake(20 + (i - 3) * 110, 128, 61, 61);
        }
        else {
            label.frame = CGRectMake(18 + i * 110, 88, 65, 16);
            btn.frame = CGRectMake(20 + i * 110, 24, 61, 61);
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [arrTitle objectAtIndex:i];
        label.font = [UIFont systemFontOfSize:13];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [DFToolClass getColor:@"434343"];
        [view addSubview:label];
        
        NSString *strNarmalImg = [arrNarmalImg objectAtIndex:i];
        NSString *strHighImg = [arrHighImg objectAtIndex:i];
        
        [btn setBackgroundImage:[UIImage imageNamed:strNarmalImg] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:strHighImg] forState:UIControlStateHighlighted];
        
        [view addSubview:btn];
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    
    [UIView animateWithDuration:0.3f animations:^{
        view.frame = CGRectMake(0, KCurrentHeight - 276, KCurrentWidth, 276);
        bgView.alpha = 0.5f;
    }completion:^(BOOL finished){
        
    }];
}

- (void)hideShareView
{
    UIControl *view = (UIControl *)[[UIApplication sharedApplication].keyWindow viewWithTag:ShareBGViewTag];
    UIView *view1 = (UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:ShareViewTag];
    
    [UIView animateWithDuration:0.3f animations:^{
        view1.frame = CGRectMake(0, KCurrentHeight, KCurrentWidth, 276);
        view.alpha = 0.0f;
    }completion:^(BOOL finished){
        [view removeFromSuperview];
        [view1 removeFromSuperview];
    }];
}

- (void)shareSNS:(UIButton *)sender
{
    UIControl *view = (UIControl *)[[UIApplication sharedApplication].keyWindow viewWithTag:ShareBGViewTag];
    UIView *view1 = (UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:ShareViewTag];
    [UIView animateWithDuration:0.3f animations:^{
        view1.frame = CGRectMake(0, KCurrentHeight, KCurrentWidth, 276);
        view.alpha = 0.0f;
    }completion:^(BOOL finished){
        [view removeFromSuperview];
        [view1 removeFromSuperview];
        
        if ([self.delegate respondsToSelector:@selector(share:)]) {
            [self.delegate share:sender];
        }
    }];
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
