//
//  DFViewController.m
//  df360
//
//  Created by wangxl on 14-9-2.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "DFViewController.h"
#import "DFUserCenterVC.h"
#import "DFTodayShoppingVC.h"
#import "DFSettingVC.h"
#import "DFQSBKVC.h"
#import "AFNetworking.h"
#import "DFRequestUrl.h"
#import "DFToolView.h"
#import "DFToolClass.h"
#import "DFChildVC.h"
#import "DFSelectFatherCateVC.h"
#import "DFUserCenterVC.h"
#import "DFTopInfoVC.h"

@interface DFViewController ()<UISearchBarDelegate,UITextFieldDelegate,UIScrollViewDelegate,UITabBarDelegate,DFHudProgressDelegate,UIActionSheetDelegate>
{
    UIScrollView *_childScrollView;
    UIPageControl *_childPageControl;
    
    UIScrollView *_backScrollView;
    
    
    NSInteger numbersOfCell;
    
    UIScrollView *_topScrollView;  //置顶ScrollView
    
    UIPageControl *_topPageControl;  //置顶pageView
    
    NSMutableArray *_topInfoArr; //置顶信息
    
    UIScrollView *_fatherScrollView;  //父级菜单scrollerview
    
    UIPageControl *_fatherPageControl; //父级菜单pageview
    
    NSMutableArray *_btnArr;  //父级菜单按钮数组
    
    NSMutableArray *_fatherCatesArr; //父分类信息
    
    NSMutableArray *_childCatesArr; //子分类信息
    
    NSString *_fatherCatID;  //父分类类别id
    
    DFHudProgress *_hud;
    
    NSInteger _requestCount;
    
}

@end

@implementation DFViewController

- (void)viewDidLoad
{
    
    _requestCount = 2;
    
    
    [self buildUI];

    
    _hud = [[DFHudProgress alloc] init];
    [_hud show];
    
    [self getTopInfo];
    
    [self getFatherCates];
    
    self.view.backgroundColor = [DFToolClass getColor:@"e5e5e5"];
    

    self.WLeftBarStyle = LeftBarStyleNone;
    self.WRightBarStyle = RightBarStyleNone;
    
    [super viewDidLoad];
    	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    UISearchBar *search = (UISearchBar *)[self.navigationController.navigationBar viewWithTag:1];
    search.hidden = NO;

}

- (void)buildUI
{
    
    
    //导航栏上得控件
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [leftBtn setTitle:@"登封" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    leftBtn.backgroundColor = [UIColor clearColor];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(70, 0, 200, 44)];
    searchBar.tag = 1;
    searchBar.placeholder = @"输入类别或关键词";
    searchBar.delegate = self;
    
    
    for (UIView *subview in searchBar.subviews)
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            [subview removeFromSuperview];
            break;
        }
    }
    
    [self.navigationController.navigationBar addSubview:searchBar];
    
    _backScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _backScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 568 + 200);
    [self.view addSubview:_backScrollView];
    
    //固定置顶的图片
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KCurrentWidth, 53)];
    image.image = [UIImage imageNamed:@"info_index_top"];
    [_backScrollView addSubview:image];
    
    
    float btnWidth = (self.view.bounds.size.width - 100)/4;
    
    
    //第三方网站界面
    
//    UIView *webView = [[UIView alloc] initWithFrame:CGRectMake(0, deltaHeight + 373, KCurrentWidth, 100)];
    UIButton *webBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [webBtn setFrame:CGRectMake(0, 373, KCurrentWidth, 100)];
    
    [webBtn setImage:[UIImage imageNamed:@"icon_ad"] forState:UIControlStateNormal];
    
    webBtn.backgroundColor = [UIColor clearColor];
    
    [_backScrollView addSubview:webBtn];
    
    
    UITabBar *downTab = [[UITabBar alloc] initWithFrame:CGRectMake(0, KCurrentHeight - 113, KCurrentWidth, 49)];
    
//    downTab.backgroundColor = [UIColor redColor];
    
    NSMutableArray *tabItems = [NSMutableArray array];
    
    NSArray *tabTitle = @[@"个人中心",@"今日团购",@"夜猫基地",@"设置",@"发布"];
    
    NSArray *tabImage = @[@"home_tab_person",@"home_tab_collect",@"home_tab_history",@"home_tab_setting",@"home_tab_publish"];
    
    for (int i = 0; i < 5; i ++) {
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:[tabTitle objectAtIndex:i] image:nil tag:i];
        item.image = [UIImage imageNamed:[tabImage objectAtIndex:i]];
        [tabItems addObject:item];
    }
    
    downTab.items = tabItems;
    
    downTab.delegate = self;
    
    [self.view addSubview:downTab];
    
    
    
    
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)pageChange
{
    
}


#pragma mark - 构建置顶信息UI
- (void)buildTopUI
{
    
    //置顶信息总共数量
    NSInteger topItems = [_topInfoArr count];
    
    //置顶信息页数
    NSInteger topPages = (topItems%6 == 0)?topItems/6:topItems/6+1;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 62.5, KCurrentWidth, 0.5)];
    line.backgroundColor = [UIColor blackColor];

    [_backScrollView addSubview:line];
    
    
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 53, KCurrentWidth , 80)];
    
    _topScrollView.contentSize = CGSizeMake(KCurrentWidth * topPages, 80);
    _topScrollView.showsVerticalScrollIndicator = false;
    _topScrollView.backgroundColor = [UIColor whiteColor];
    _topScrollView.delegate = self;
    _topScrollView.pagingEnabled = YES;
    
    _topPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 143, 320, 10)];
    _topPageControl.backgroundColor = [UIColor clearColor];
    _topPageControl.numberOfPages = topPages;
    _topPageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    _topPageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    [_topPageControl addTarget:self action:@selector(topPageControlSelected:) forControlEvents:UIControlEventValueChanged];
    
    
    
    [_backScrollView addSubview:line];
    [_backScrollView addSubview:_topScrollView];
    [_backScrollView addSubview:_topPageControl];
    
    for (int page = 0; page < topPages; page ++) {
        
        //当前页有几个item
        NSInteger PageItemCount = (topItems-page*6)>=6?6:topItems-page*6;
        //需要显示两行
        if (PageItemCount >= 4) {
            for (int i = 0; i<2; i++) {
                //当前行有几个item
                NSInteger cellItemCount = (PageItemCount-i*3)>=3?3:(PageItemCount-i*3);
                for (int y = 0; y < cellItemCount; y ++) {
                    NSInteger tag = y + i*3 + page*6;
                    
                    NSString *title = [[_topInfoArr objectAtIndex:tag] objectForKey:@"post_title"];
                    if ([title isEqual:[NSNull null]]) {
                        title = @"";
                    }
                    UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    topBtn.backgroundColor = [UIColor whiteColor];
                    [topBtn setFrame:CGRectMake(20 + 100*y + page * KCurrentWidth, 5 + 40*i, 80, 30)];
                    [topBtn setTitle:title forState:UIControlStateNormal];
                    [topBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [topBtn addTarget:self action:@selector(topBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
                    topBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                    topBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                    topBtn.tag = tag;
                    [_topScrollView addSubview:topBtn];
                    
                }
            }
            
        }
        //只有一行
        else {
            for (int y = 0; y < PageItemCount; y ++) {
                NSInteger tag = y + page*6;
                
                NSString *title = [[_topInfoArr objectAtIndex:tag] objectForKey:@"post_title"];
                
                UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                topBtn.backgroundColor = [UIColor whiteColor];
                [topBtn setFrame:CGRectMake(20 + 100*y + page * KCurrentWidth, 5, 80, 30)];
                [topBtn setTitle:title forState:UIControlStateNormal];
                topBtn.titleLabel.font = [UIFont systemFontOfSize:15];
                topBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                [topBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                topBtn.tag = tag;
                [_topScrollView addSubview:topBtn];
                
            }

            
        }
        
        
    }
}

#pragma mark - 构建父级菜单UI
- (void)buildFatherUI
{
  
    
    float btnWidth = (self.view.bounds.size.width - 100)/4;
    
    float topHight = 163;
    
    //父级菜单总数
    NSInteger fatherItmes = [_fatherCatesArr count];
    
    //父级菜单页数
    NSInteger fatherPages = (fatherItmes%8 == 0)?fatherItmes/8:fatherItmes/8+1;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, topHight - 0.5, KCurrentWidth, 0.5)];
    
    line.backgroundColor = [UIColor blackColor];
    
//    [_backScrollView addSubview:line];
    
    _fatherScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topHight, KCurrentWidth , 100 + 2*btnWidth)];
    _fatherScrollView.contentSize = CGSizeMake(KCurrentWidth * fatherPages, 90);
    _fatherScrollView.showsVerticalScrollIndicator = false;
    _fatherScrollView.delegate = self;
    _fatherScrollView.pagingEnabled = YES;
    
    _fatherScrollView.backgroundColor = [UIColor whiteColor];
    
    _fatherPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, topHight + 85 + 2*btnWidth, KCurrentWidth, 10)];
    _fatherPageControl.backgroundColor = [UIColor whiteColor];
    _fatherPageControl.numberOfPages = fatherPages;
    _fatherPageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    _fatherPageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    [_fatherPageControl addTarget:self action:@selector(topPageControlSelected:) forControlEvents:UIControlEventValueChanged];
    
    line = [[UIView alloc] initWithFrame:CGRectMake(0, topHight + 100 + 2*btnWidth, KCurrentWidth, 0.5)];
    
    line.backgroundColor = [UIColor blackColor];
    
//    [_backScrollView addSubview:line];
    [_backScrollView addSubview:_fatherScrollView];
    [_backScrollView addSubview:_fatherPageControl];
    
    _btnArr = [[NSMutableArray alloc] init];
    
    NSArray *imageArr = [[NSArray alloc] initWithObjects:@"ic_house", @"ic_mark", @"ic_jobs", @"ic_resume", @"ic-friends", @"ic_study", @"ic_pet", @"ic_clean", @"ic-photo", @"ic_travel", @"ic_hotel", @"ic_play", @"ic_shoping", @"ic_tag", nil];
    
    for (int page = 0; page < fatherPages; page ++) {
        
        //当前页有几个item
        NSInteger PageItemCount = (fatherItmes-page*8)>=8?8:fatherItmes-page*8;
        //需要显示两行
        if (PageItemCount >= 5) {
            for (int i = 0; i<2; i++) {
                //当前行有几个item
                NSInteger cellItemCount = (PageItemCount-i*4)>=4?4:(PageItemCount-i*4);
                for (int y = 0; y < cellItemCount; y ++) {
                    NSInteger tag = y + i*4 + page*8;
                    
                    NSString *title = [[_fatherCatesArr objectAtIndex:tag] objectForKey:@"cat_title"];
                    
                    UIButton *fatherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    fatherBtn.backgroundColor = [UIColor clearColor];
                    [fatherBtn setFrame:CGRectMake(20 + (btnWidth + 20)*y + page * KCurrentWidth,20 + (40 + btnWidth)*i, btnWidth, btnWidth)];
                    [fatherBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    fatherBtn.titleLabel.font = [UIFont systemFontOfSize:12];
                    fatherBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                    [fatherBtn addTarget:self action:@selector(categorySelected:) forControlEvents:UIControlEventTouchUpInside];
                    fatherBtn.tag = tag;
                    [fatherBtn setImage:[UIImage imageNamed:[imageArr objectAtIndex:tag]] forState:UIControlStateNormal];
                    [_btnArr addObject:fatherBtn];
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + (btnWidth + 20)*y + page * KCurrentWidth,20 + (40 + btnWidth)*i + 60, btnWidth, 20)];
                    titleLabel.backgroundColor = [UIColor clearColor];
                    titleLabel.text = title;
                    titleLabel.font = [UIFont systemFontOfSize:13];
                    titleLabel.textAlignment = NSTextAlignmentCenter;
                    [_fatherScrollView addSubview:titleLabel];
                    [_fatherScrollView addSubview:fatherBtn];
                    
                }
            }
            
        }
        //只有一行
        else {
            for (int y = 0; y < PageItemCount; y ++) {
                NSInteger tag = y + page*8;
                
                NSString *title = [[_fatherCatesArr objectAtIndex:tag] objectForKey:@"cat_title"];
                
                UIButton *fatherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                fatherBtn.backgroundColor = [UIColor grayColor];
                [fatherBtn setFrame:CGRectMake(20 + (btnWidth + 20)*y + page * KCurrentWidth,20, btnWidth, btnWidth)];
                [fatherBtn setTitle:title forState:UIControlStateNormal];
                fatherBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                fatherBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                [fatherBtn addTarget:self action:@selector(categorySelected:) forControlEvents:UIControlEventTouchUpInside];
                fatherBtn.tag = tag;
                [_btnArr addObject:fatherBtn];
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + (btnWidth + 20)*y + page * KCurrentWidth + 60,20, btnWidth, 20)];
                titleLabel.backgroundColor = [UIColor clearColor];
                titleLabel.text = title;
                titleLabel.font = [UIFont systemFontOfSize:13];
                titleLabel.textAlignment = NSTextAlignmentCenter;
                [_fatherScrollView addSubview:titleLabel];
                [_fatherScrollView addSubview:fatherBtn];
                
            }
        }
    }
}

#pragma mark - 分类按钮点击事件
- (void)categorySelected:(UIButton *)sender
{
    
    
    UIImageView *imageView = (UIImageView *)[_backScrollView viewWithTag:101];
    [imageView removeFromSuperview];
    [_childScrollView removeFromSuperview];
    [_childPageControl removeFromSuperview];
    
    if (!sender.selected) {
        
        CGRect btnRect = sender.frame;
        
        
        CGPoint point = CGPointMake(btnRect.origin.x + btnRect.size.width/2 - 10, btnRect.origin.y + 22+btnRect.size.width);
        NSInteger tag = [sender tag];
        
        _childCatesArr = [[_fatherCatesArr objectAtIndex:tag] objectForKey:@"child"];
        _fatherCatID = [[_fatherCatesArr objectAtIndex:tag] objectForKey:@"cat_id"];
        [self showSecondCategoryWithPoint:point];
        
        for (UIButton *btn in _btnArr) {
            if (btn == sender) {
                btn.selected = YES;
            }
            else
            {
                btn.selected = NO;
            }
        }
    }
    else
    {
        sender.selected = NO;
    }
}

#pragma mark - web按钮点击事件
- (void)webViewSelected:(UIButton *)sender
{
    
}

#pragma mark - 子菜单
- (void)showSecondCategoryWithPoint:(CGPoint)point
{
    


    float topHight =  163;

    float xValue = (point.x > KCurrentWidth)?point.x - KCurrentWidth:point.x;
    
    
    UIImageView *pointImgView = [[UIImageView alloc] initWithFrame:CGRectMake(xValue, point.y + topHight - 20, 20, 20)];
    [pointImgView setImage:[UIImage imageNamed:@"UpTriangle"]];
    pointImgView.tag = 101;
    [_backScrollView addSubview:pointImgView];
    
    //子菜单总共数量
    NSInteger childItems = [_childCatesArr count];
    
    //子菜单页数
    NSInteger childPages = (childItems%12 == 0)?childItems/12:childItems/12+1;
    
    
    _childScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, point.y + topHight - 7, KCurrentWidth, 150)];
    
    _childScrollView.contentSize = CGSizeMake(KCurrentWidth * childPages, 150);
    _childScrollView.showsVerticalScrollIndicator = false;
    _childScrollView.pagingEnabled = YES;

//    _childScrollView.delegate = self;
    
    _childScrollView.backgroundColor = [UIColor blackColor];
    
    
    
    [_backScrollView addSubview:_childScrollView];
    
    NSInteger maxCellCount = 0; //所有页中最多几行，用来判断scrollView的高度
    
    for (int page = 0; page < childPages; page ++) {
        
        //当前页有几个item
        NSInteger PageItemCount = (childItems-page*12)>=12?12:childItems-page*12;
        NSInteger needCells = (PageItemCount%3 == 0)?PageItemCount/3:PageItemCount/3 + 1; //需要显示几行
        
        maxCellCount = needCells>maxCellCount?needCells:maxCellCount;
        
        for (int i = 0; i<needCells; i++) {
            //当前行有几个item
            NSInteger cellItemCount = (PageItemCount-i*3)>=3?3:(PageItemCount-i*3);
            for (int y = 0; y < cellItemCount; y ++) {
                NSInteger tag = y + i*3 + page*6;
                
                NSString *title = [[_childCatesArr objectAtIndex:tag] objectForKey:@"cat_title"];
                
                UIButton *childBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                childBtn.backgroundColor = [UIColor clearColor];
                [childBtn setFrame:CGRectMake(20 + 100*y + page * KCurrentWidth, 10 + 40*i, 80, 30)];
                [childBtn setTitle:title forState:UIControlStateNormal];
                [childBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                childBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                childBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                [childBtn addTarget:self action:@selector(childBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
                childBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
                childBtn.tag = tag;
                [_childScrollView addSubview:childBtn];
                
            }
        }
    }
    
    /**************************** 重构ScrollView的高度 以及pagecontrol的位置 *****************************/
    [_childScrollView setFrame:CGRectMake(0, point.y + topHight - 7, KCurrentWidth, 10 + 40*maxCellCount)];
    _childScrollView.contentSize = CGSizeMake(KCurrentWidth * childPages, 10 + 40*maxCellCount);
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewSwiped:)];
    [_childScrollView addGestureRecognizer:swipeGesture];

    
    _childPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, point.y + topHight + 3 + 40*maxCellCount, KCurrentWidth, 10)];
    _childPageControl.backgroundColor = [UIColor clearColor];
    _childPageControl.numberOfPages = childPages;
    [_childPageControl addTarget:self action:@selector(topPageControlSelected:) forControlEvents:UIControlEventValueChanged];
    [_backScrollView addSubview:_childPageControl];

}

- (void)scrollViewSwiped:(UIGestureRecognizer *)sender
{
    NSInteger currentPage = _childPageControl.currentPage;
    NSInteger allPages = _childPageControl.numberOfPages;
    if (sender.state == UISwipeGestureRecognizerDirectionLeft) {
        if (currentPage + 1 <allPages) {
            _childPageControl.currentPage += 1;
            [_childScrollView setContentOffset:CGPointMake(self.view.bounds.size.width * (_childPageControl.currentPage), _childScrollView.contentOffset.y) animated:YES];
        }
    }
    if (sender.state == UISwipeGestureRecognizerDirectionRight) {
        if (currentPage > 0) {
            _childPageControl.currentPage -= 1;
            [_childScrollView setContentOffset:CGPointMake(self.view.bounds.size.width * (_childPageControl.currentPage), _childScrollView.contentOffset.y) animated:YES];
        }
    }
}

#pragma mark - 点击子菜单

- (void)childBtnSelected:(UIButton *)sender
{
    
    NSInteger tag = [sender tag];
    
    
    [self performSegueWithIdentifier:@"childSelected" sender:[_childCatesArr objectAtIndex:tag]];
}

#pragma mark - 点击topBtn
- (void)topBtnSelected:(UIButton *)sender
{
    NSInteger tag = [sender tag];
    
    [self performSegueWithIdentifier:@"topInfo" sender:[_topInfoArr objectAtIndex:tag]];
}

#pragma mark  - 获取置顶信息
- (void)getTopInfo
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[DFRequestUrl getTopTitles] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"TopJSON: %@", responseObject);
        _requestCount -= 1;
        _topInfoArr = [responseObject objectForKey:@"data"];
        [self dissMissHud];
        [self buildTopUI];
        
        _topInfoArr = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"data"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSLog(@"operation: %@",operation);
        _requestCount -= 1;
        [self dissMissHud];

        
    }];
}

#pragma mark - 或者所有分类信息
- (void )getFatherCates
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[DFRequestUrl getAllCates] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"FatherJSON: %@", responseObject);
        _requestCount -= 1;
        [self dissMissHud];
        _fatherCatesArr = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"data"]];
        
        [self buildFatherUI];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"operation: %@",operation);
        NSLog(@"Error: %@", error);
        _requestCount -= 1;

        [self dissMissHud];


    }];
    
}

#pragma mark - hudDissmiss
- (void)dissMissHud
{
    if (_requestCount == 0) {
        [_hud dismiss];
        _requestCount = 2;
    }
}

#pragma mark - UIScrollerViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _topScrollView) {
        int page = scrollView.contentOffset.x/290;
        _topPageControl.currentPage = page;
    }
    if (scrollView == _fatherScrollView) {
        int page = scrollView.contentOffset.x/290;
        _fatherPageControl.currentPage = page;
        UIImageView *imageView = (UIImageView *)[_backScrollView viewWithTag:101];
        [imageView removeFromSuperview];
        [_childScrollView removeFromSuperview];
        [_childPageControl removeFromSuperview];

    }
    if (scrollView == _childScrollView) {
        int page = scrollView.contentOffset.x/290;
        _childPageControl.currentPage = page;

    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _childScrollView) {
        CGPoint offset = scrollView.contentOffset;
        _childPageControl.currentPage = offset.x / 290; //计算当前的页码
        [_childScrollView setContentOffset:CGPointMake(self.view.bounds.size.width * (_childPageControl.currentPage), _childScrollView.contentOffset.y) animated:YES];
    }

}

#pragma mark - UIPageControlAction

//topPageControl
- (void)topPageControlSelected:(id)sender
{
    if (sender == _topPageControl) {
        NSInteger page = _topPageControl.currentPage;
        _topScrollView.contentOffset = CGPointMake(KCurrentWidth*page, 0);
    }
    if (sender == _fatherPageControl) {
        NSInteger page = _fatherPageControl.currentPage;
        _fatherScrollView.contentOffset = CGPointMake(KCurrentWidth*page, 0);
    }
    if (sender == _childPageControl) {
        NSInteger page = _childPageControl.currentPage;
        _childScrollView.contentOffset = CGPointMake(KCurrentWidth*page, 0);
    }

}

- (void)reloadAgain
{
    [self getTopInfo];
    
    [self getFatherCates];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
    NSInteger tag = [item tag];
    if (tag == 4) {
        if ([DFToolClass isLogin]) {
            [self performSegueWithIdentifier:[NSString stringWithFormat:@"tab%ld",(long)tag] sender:_fatherCatesArr];
        }
        else
        {
            [self performSegueWithIdentifier:@"notLogin" sender:nil];
        }
    }
    else if (tag == 0)
    {
        [self performSegueWithIdentifier:[NSString stringWithFormat:@"tab%ld",(long)tag] sender:_fatherCatesArr];
    }
    else
    {
        [self performSegueWithIdentifier:[NSString stringWithFormat:@"tab%ld",(long)tag] sender:nil];
    }
}


#pragma mark - 跳转到子类列表传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"childSelected"]) {
        DFChildVC *child = (DFChildVC *)segue.destinationViewController;
        child.childDic = sender;
    }
    if ([segue.identifier isEqualToString:@"tab4"]) {
        DFSelectFatherCateVC *selectVC = (DFSelectFatherCateVC *)segue.destinationViewController;
        selectVC.allCates = sender;
    }
    
    if ([segue.identifier isEqualToString:@"tab0"]) {
        DFUserCenterVC *userCenter = (DFUserCenterVC *)segue.destinationViewController;
        userCenter.allCates = sender;
    }
    if ([segue.identifier isEqualToString:@"topInfo"]) {
        DFTopInfoVC *top = (DFTopInfoVC *)segue.destinationViewController;
        top.sendDic = sender;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
