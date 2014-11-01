//
//  DFToolView.m
//  df360
//
//  Created by wangxl on 14-9-4.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//


#import "DFToolView.h"
#import "DFToolClass.h"
#import "DFAppDelegate.h"

@implementation DFToolView

@end


@implementation DFHudProgress


- (id)init
{
    CGRect frame = CGRectMake(61, 220, 198, 50);
    self = [super initWithFrame:frame];
    return self;
}

- (void)show
{
    DFAppDelegate *app = (DFAppDelegate *)[UIApplication sharedApplication].delegate;
    _bgView = [[UIView alloc] init];
    [_bgView setFrame:CGRectMake(0, 0, 320, 768)];
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.alpha = 0.5f;
    
    _activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    _activity.center = CGPointMake(160, 200);
    [_activity startAnimating];
    
    [app.window addSubview:_bgView];
    [app.window addSubview:_activity];
    [app.window addSubview:self];
    
        
        
}

- (void)dismiss
{
    [_bgView removeFromSuperview];
    [_activity removeFromSuperview];
}

@end

@implementation DFShareHud

- (id)init
{
    CGRect frame = CGRectMake(61, 220, 198, 50);
    self = [super initWithFrame:frame];
    return self;
}

-(void)success
{
    DFAppDelegate *app = (DFAppDelegate *)[UIApplication sharedApplication].delegate;
    _bgView = [[UIView alloc] init];
    [_bgView setFrame:CGRectMake(0, 0, 320, 768)];
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.alpha = 0.5f;
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    
    _label.font = [UIFont systemFontOfSize:13];
    
    _label.text = @"分享成功";
    
    _label.textAlignment = NSTextAlignmentCenter;
    
    [app.window addSubview:_bgView];
    [app.window addSubview:_label];
    [app.window addSubview:self];


    
    
}

@end



@implementation DFSegmentController

- (id)initWithFrame:(CGRect)frame withTitle:(NSArray *)title withData:(NSArray *)data
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isShowing = NO;
        
        [self buildUIWithTitle:title withData:data];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
        lineView.backgroundColor = [DFToolClass getColor:@"bfbfbf"];
        lineView.tag = 10001;
        [self addSubview:lineView];
        [self bringSubviewToFront:lineView];
    }
    return self;
}

- (void)buildUIWithTitle:(NSArray*)titleArr withData:(NSArray*)data
{
    if (titleArr.count <= 4) {
        more = NO;
        CGFloat deltaWith = [UIScreen mainScreen].bounds.size.width/titleArr.count;
        for (NSInteger i = 0; i <titleArr.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0 + i*deltaWith, 1, deltaWith, 40);
            btn.tag = i;
            [btn setBackgroundColor:[DFToolClass getColor:@"e5e5e5"]];
            [btn addTarget:self action:@selector(btnSelected:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
            NSString *title = [titleArr objectAtIndex:i];
            CGFloat width = [DFToolClass widthOfLabel:title ForFont:[UIFont systemFontOfSize:14] labelHeight:16];
            CGFloat XFloat = 0;
            UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(XFloat, 12, width, 16)];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(XFloat + width + 5, 16, 11, 8)];
            imageView.userInteractionEnabled = YES;
            imageView.tag = 10 + i;
            imageView.image = [UIImage imageNamed:@"navbar_arrow_down_g.png"];
            [btn addSubview:imageView];
            
            lbTitle.tag = 20 + i;
            lbTitle.backgroundColor = [UIColor clearColor];
            lbTitle.textColor = [DFToolClass getColor:@"878787"];
            lbTitle.text = title;
            lbTitle.textAlignment = NSTextAlignmentCenter;
            lbTitle.font = [UIFont systemFontOfSize:14];
            [btn addSubview:lbTitle];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(deltaWith * i, 10, 0.5, 20)];
            line.backgroundColor = [DFToolClass getColor:@"b2b2b2"];
            line.tag = 101;
            [self addSubview:line];
            
        }
        
        
    }
    else
    {
        more = YES;
        CGFloat deltaWith = [UIScreen mainScreen].bounds.size.width/4;
        for (NSInteger i = 0; i <4; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0 + i*deltaWith, 1, deltaWith, 40);
            btn.tag = i;
            [btn setBackgroundColor:[DFToolClass getColor:@"e5e5e5"]];
            [btn addTarget:self action:@selector(btnSelected:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
            NSString *title = [titleArr objectAtIndex:i];
            if (i == 3) {
                title = @"更多";
            }
            CGFloat width = [DFToolClass widthOfLabel:title ForFont:[UIFont systemFontOfSize:14] labelHeight:16];
            CGFloat XFloat = (deltaWith - width - 16) * 0.5;
            UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(XFloat, 12, width, 16)];
        
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(XFloat + width + 5, 16, 11, 8)];
            imageView.userInteractionEnabled = YES;
            imageView.tag = 10 + i;
            imageView.image = [UIImage imageNamed:@"navbar_arrow_down_g.png"];
            [btn addSubview:imageView];
            
            lbTitle.tag = 20 + i;
            lbTitle.backgroundColor = [UIColor clearColor];
            lbTitle.textColor = [DFToolClass getColor:@"878787"];
            lbTitle.text = title;
            lbTitle.textAlignment = NSTextAlignmentCenter;
            lbTitle.font = [UIFont systemFontOfSize:14];
            [btn addSubview:lbTitle];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(deltaWith * i, 10, 0.5, 20)];
            line.backgroundColor = [DFToolClass getColor:@"b2b2b2"];
            line.tag = 101;
            [self addSubview:line];
            
        }
        
        
    }
}

- (void)btnSelected:(UIButton *)sender
{
    sender.selected = !sender.selected;
    selectMore = NO;
    index = sender.tag;
    if (more) {
        if (index == 3) {
            dataSource = [[NSMutableArray alloc] init];
            for (int i = 3; i < self.segementTitle.count; i++) {
                [dataSource addObject:[self.segementTitle objectAtIndex:i]];
            }
        }
        else
        {
            dataSource = [self.segementData objectAtIndex:index];
        }
    }
    else
    {
        dataSource = [self.segementData objectAtIndex:index];
    }
    if (sender.selected) {
        self.isShowing = YES;
        if (more) {
            if (index == 3) {
                selectMore = YES;
            }
        }
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)view;
                if (button.tag != sender.tag) {
                    button.selected = NO;
                    [self reSetSubViewStateButton:button withState:0];
                }
            }
        }
        
        [self reSetSubViewStateButton:sender withState:1];
        [self presentSegmentView];
    }
    else {
        self.isShowing = NO;
        [self reSetSubViewStateButton: sender withState:0];
        [self dissmisSegmentView];
    }
}

//重置按钮状态
- (void)reSetSubViewStateButton:(UIButton *)sender withState:(NSInteger)state
{
    // 重置为0
    if (state == 0) {
        
        [sender setBackgroundColor:[DFToolClass getColor:@"e5e5e5"]];
        
        UIImageView *imageView = (UIImageView *)[sender viewWithTag:10 + sender.tag];
        imageView.image = [UIImage imageNamed:@"navbar_arrow_down_g.png"];
        
        UILabel *lbTitle = (UILabel *)[sender viewWithTag:20 + sender.tag];
        lbTitle.textColor = [DFToolClass getColor:@"878787"];
        
        UIView *lineView = (UIView *)[self viewWithTag:101];
        lineView.hidden = NO;
    }
    // 被按下
    else {
        [sender setBackgroundColor:[DFToolClass getColor:@"ffffff"]];
        
        UIImageView *imageView = (UIImageView *)[sender viewWithTag:10 + sender.tag];
        imageView.image = [UIImage imageNamed:@"navbar_arrow_down_g_press.png"];
        
        UILabel *lbTitle = (UILabel *)[sender viewWithTag:20 + sender.tag];
        lbTitle.textColor = [DFToolClass getColor:@"434343"];
        
        UIView *lineView = (UIView *)[self viewWithTag:101];
        lineView.hidden = YES;
    }
}

// 弹出选择列表
- (void)presentSegmentView
{
    self.isShowing = YES;
    
    NSInteger num = 0;
    
    if (more) {
        if (index == 3) {
            num = self.segementTitle.count - 3;
        }
        else
        {
            num = [[self.segementData objectAtIndex:index] count];
        }
    }
    else
    {
        num = [[self.segementData objectAtIndex:index] count];
    }
    
    num = num>10?10:num;
    
    CGFloat deltaHeight = 40 * num;
    
    UIControl *bgView = (UIControl *)[[UIApplication sharedApplication].keyWindow viewWithTag:1001];
    UITableView *tbl_view = (UITableView *)[[UIApplication sharedApplication].keyWindow viewWithTag:1002];
    UIView *lineView1 = (UIView *)[self viewWithTag:10001];
    
    if (bgView) {
        lineView1.alpha = 0.0f;
        [UIView animateWithDuration:0.2f
                         animations:^{
                             tbl_view.frame = CGRectMake(0, 104, [UIScreen mainScreen].bounds.size.width, deltaHeight);
                         } completion:^(BOOL finished) {
                             [tbl_view reloadData];
                         }];
    }
    else {
        UIControl *bgView = [[UIControl alloc] initWithFrame:CGRectMake(0, 104, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 104)];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.tag = 1001;
        bgView.alpha = 0.0f;
        [bgView addTarget:self action:@selector(dissmisSegmentView) forControlEvents:UIControlEventTouchUpInside];
        [[UIApplication sharedApplication].keyWindow addSubview:bgView];
        
        UITableView *tbl_view = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, [UIScreen mainScreen].bounds.size.width, 0) style:UITableViewStylePlain];
        if ([tbl_view respondsToSelector:@selector(setSeparatorInset:)]) {
            tbl_view.separatorInset = UIEdgeInsetsZero;
        }
        tbl_view.tag = 1002;
        tbl_view.separatorStyle = UITableViewCellSeparatorStyleNone;
        tbl_view.dataSource = self;
        tbl_view.delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:tbl_view];
        
        lineView1.alpha = 0.0f;
        [UIView animateWithDuration:0.3f
                         animations:^{
                             bgView.alpha = 0.5f;
                             tbl_view.frame = CGRectMake(0, 104, [UIScreen mainScreen].bounds.size.width, deltaHeight);
                         }
                         completion:^(BOOL finished) {
                             ;
                         }];
    }
}

// 隐藏选择列表
-(void)dissmisSegmentView
{
    self.isShowing = NO;
    UIControl *bgView = (UIControl *)[[UIApplication sharedApplication].keyWindow viewWithTag:1001];
    UITableView *tbl_view = (UITableView *)[[UIApplication sharedApplication].keyWindow viewWithTag:1002];
    UIView *lineView1 = (UIView *)[self viewWithTag:10001];
    
    if (bgView) {
        [UIView animateWithDuration:0.3f
                         animations:^{
                             bgView.alpha = 0.0f;
                             tbl_view.frame = CGRectMake(0, 104, [UIScreen mainScreen].bounds.size.width, 0);
                             lineView1.alpha = 1.0f;
                         }
                         completion:^(BOOL finished) {
                             [bgView removeFromSuperview];
                             [tbl_view removeFromSuperview];
                             
                             for (UIView *view in self.subviews) {
                                 if ([view isKindOfClass:[UIButton class]]) {
                                     UIButton *button = (UIButton *)view;
                                     if (button.selected == YES) {
                                         button.selected = NO;
                                         [self reSetSubViewStateButton:button withState:0];
                                     }
                                 }
                             }
                         }];
    }
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ide = @"cell1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ide];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ide];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 180, 18)];
        lbTitle.backgroundColor = [UIColor clearColor];
        lbTitle.textColor = [DFToolClass getColor:@"434343"];
        lbTitle.tag = 103;
        lbTitle.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:lbTitle];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 39.5, [UIScreen mainScreen].bounds.size.width - 20, 0.5)];
        lineView.backgroundColor = [DFToolClass getColor:@"b2b2b2"];
        lineView.tag = 105;
        [cell.contentView addSubview:lineView];
    }
    UILabel *lbTitle = (UILabel *)[cell.contentView viewWithTag:103];
    UIView *lineView = (UIView *)[cell.contentView viewWithTag:105];
    if (selectMore) {
        lbTitle.text = [dataSource objectAtIndex:indexPath.row];
    }
    else
    {
        lbTitle.text = [[dataSource objectAtIndex:indexPath.row] objectForKey:@"c_name"];
    }
    if (indexPath.row == dataSource.count - 1) {
        lineView.hidden = YES;
    }
    else {
        lineView.hidden = NO;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (selectMore) {
        dataSource = [self.segementData objectAtIndex:3+indexPath.row];
        [tableView reloadData];
        NSInteger num = dataSource.count>10?10:dataSource.count;
        CGFloat deltaHeight = num * 40;
        [UIView animateWithDuration:0.3f
                         animations:^{
                             tableView.frame = CGRectMake(0, 104, [UIScreen mainScreen].bounds.size.width, deltaHeight);
                         }
                         completion:^(BOOL finished) {
                             ;
                         }];
        selectMore = NO;
    }
    else
    {
        [self dissmisSegmentView];
        NSString *strTitle = [[dataSource objectAtIndex:indexPath.row] objectForKey:@"c_name"];
        UIButton *btn = (UIButton *)[self viewWithTag:index];
        UILabel *lbTitle = (UILabel *)[btn viewWithTag:20 + btn.tag];
        CGFloat width = [DFToolClass widthOfLabel:strTitle ForFont:[UIFont systemFontOfSize:14] labelHeight:16];
        NSInteger num = self.segementTitle.count>=4?4:self.segementTitle.count;
        CGFloat deltaWidth = ([UIScreen mainScreen].bounds.size.width / num - width - 16) * 0.5;
        lbTitle.frame = CGRectMake(deltaWidth, 12, width, 16);
        
        UIImageView *imageView = (UIImageView *)[btn viewWithTag:10 + btn.tag];
        imageView.frame = CGRectMake(deltaWidth + width + 5, 16, 11, 8);
        
        lbTitle.text = strTitle;
        if ([self.delegate respondsToSelector:@selector(segmentIsClickWithType:withId:)]) {
            [self.delegate segmentIsClickWithType:index withId:[[dataSource objectAtIndex:indexPath.row] objectForKey:@"c_id"]];
        }


    }

}

@end

@implementation DFTuanSegmentController
#define titleType  @[@"cat_title",@"area_title",@"c_name"]
#define idType     @[@"cat_id",@"area_id",@"c_id"]
#define dataType   @[@"type",@"area",@"updatedate"]

- (id)initWithFrame:(CGRect)frame withData:(NSDictionary *)data
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isShowing = NO;
        [self buildUIWithData:data];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
        lineView.backgroundColor = [DFToolClass getColor:@"bfbfbf"];
        lineView.tag = 10001;
        [self addSubview:lineView];
        [self bringSubviewToFront:lineView];
    }
    return self;
}

- (void)buildUIWithData:(NSDictionary *)data
{
    CGFloat deltaWith = [UIScreen mainScreen].bounds.size.width/3;
    NSArray *titleArr = @[@"类别",@"区域",@"更新时间"];
    for (NSInteger i = 0; i <3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0 + i*deltaWith, 1, deltaWith, 40);
        btn.tag = i;
        [btn setBackgroundColor:[DFToolClass getColor:@"e5e5e5"]];
        [btn addTarget:self action:@selector(btnSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        NSString *title = [titleArr objectAtIndex:i];
        CGFloat width = [DFToolClass widthOfLabel:title ForFont:[UIFont systemFontOfSize:14] labelHeight:16];
        CGFloat XFloat = ([UIScreen mainScreen].bounds.size.width / 3 - width - 16) * 0.5;

        UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(XFloat, 12, width, 16)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(XFloat + width + 5, 16, 11, 8)];
        imageView.userInteractionEnabled = YES;
        imageView.tag = 10 + i;
        imageView.image = [UIImage imageNamed:@"navbar_arrow_down_g.png"];
        [btn addSubview:imageView];
        
        lbTitle.tag = 20 + i;
        lbTitle.backgroundColor = [UIColor clearColor];
        lbTitle.textColor = [DFToolClass getColor:@"878787"];
        lbTitle.text = title;
        lbTitle.textAlignment = NSTextAlignmentCenter;
        lbTitle.font = [UIFont systemFontOfSize:14];
        [btn addSubview:lbTitle];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(deltaWith * i, 10, 0.5, 20)];
        line.backgroundColor = [DFToolClass getColor:@"b2b2b2"];
        line.tag = 101;
        [self addSubview:line];
    }

}

- (void)btnSelected:(UIButton *)sender
{
    sender.selected = !sender.selected;
    selectMore = NO;
    index = sender.tag;
    dataSource = [self.segementData objectForKey:[dataType objectAtIndex:index]];
    if (sender.selected) {
        self.isShowing = YES;
        
        if (index == 0 ||index == 1) {
            selectMore = YES;
            
        }
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)view;
                if (button.tag != sender.tag) {
                    button.selected = NO;
                    [self reSetSubViewStateButton:button withState:0];
                }
            }
        }
        
        [self reSetSubViewStateButton:sender withState:1];
        [self presentSegmentView];
    }
    else {
        self.isShowing = NO;
        [self reSetSubViewStateButton: sender withState:0];
        [self dissmisSegmentView];
    }
}

//重置按钮状态
- (void)reSetSubViewStateButton:(UIButton *)sender withState:(NSInteger)state
{
    // 重置为0
    if (state == 0) {
        
        [sender setBackgroundColor:[DFToolClass getColor:@"e5e5e5"]];
        
        UIImageView *imageView = (UIImageView *)[sender viewWithTag:10 + sender.tag];
        imageView.image = [UIImage imageNamed:@"navbar_arrow_down_g.png"];
        
        UILabel *lbTitle = (UILabel *)[sender viewWithTag:20 + sender.tag];
        lbTitle.textColor = [DFToolClass getColor:@"878787"];
        
        UIView *lineView = (UIView *)[self viewWithTag:101];
        lineView.hidden = NO;
    }
    // 被按下
    else {
        [sender setBackgroundColor:[DFToolClass getColor:@"ffffff"]];
        
        UIImageView *imageView = (UIImageView *)[sender viewWithTag:10 + sender.tag];
        imageView.image = [UIImage imageNamed:@"navbar_arrow_down_g_press.png"];
        
        UILabel *lbTitle = (UILabel *)[sender viewWithTag:20 + sender.tag];
        lbTitle.textColor = [DFToolClass getColor:@"434343"];
        
        UIView *lineView = (UIView *)[self viewWithTag:101];
        lineView.hidden = YES;
    }
}

// 弹出选择列表
- (void)presentSegmentView
{
    self.isShowing = YES;
    
    NSInteger num = 0;
    
    num = [[self.segementData objectForKey:[dataType objectAtIndex:index]] count];

    num = num>10?10:num;
    
    CGFloat deltaHeight = 40 * num;
    
    UIControl *bgView = (UIControl *)[[UIApplication sharedApplication].keyWindow viewWithTag:1001];
    UITableView *tbl_view = (UITableView *)[[UIApplication sharedApplication].keyWindow viewWithTag:1002];
    UIView *lineView1 = (UIView *)[self viewWithTag:10001];
    
    if (bgView) {
        lineView1.alpha = 0.0f;
        [UIView animateWithDuration:0.2f
                         animations:^{
                             tbl_view.frame = CGRectMake(0, 104, [UIScreen mainScreen].bounds.size.width, deltaHeight);
                         } completion:^(BOOL finished) {
                             [tbl_view reloadData];
                         }];
    }
    else {
        UIControl *bgView = [[UIControl alloc] initWithFrame:CGRectMake(0, 104, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 104)];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.tag = 1001;
        bgView.alpha = 0.0f;
        [bgView addTarget:self action:@selector(dissmisSegmentView) forControlEvents:UIControlEventTouchUpInside];
        [[UIApplication sharedApplication].keyWindow addSubview:bgView];
        
        UITableView *tbl_view = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, [UIScreen mainScreen].bounds.size.width, 0) style:UITableViewStylePlain];
        if ([tbl_view respondsToSelector:@selector(setSeparatorInset:)]) {
            tbl_view.separatorInset = UIEdgeInsetsZero;
        }
        tbl_view.tag = 1002;
        tbl_view.separatorStyle = UITableViewCellSeparatorStyleNone;
        tbl_view.dataSource = self;
        tbl_view.delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:tbl_view];
        
        lineView1.alpha = 0.0f;
        [UIView animateWithDuration:0.3f
                         animations:^{
                             bgView.alpha = 0.5f;
                             tbl_view.frame = CGRectMake(0, 104, [UIScreen mainScreen].bounds.size.width, deltaHeight);
                         }
                         completion:^(BOOL finished) {
                             ;
                         }];
    }
}

// 隐藏选择列表
-(void)dissmisSegmentView
{
    self.isShowing = NO;
    UIControl *bgView = (UIControl *)[[UIApplication sharedApplication].keyWindow viewWithTag:1001];
    UITableView *tbl_view = (UITableView *)[[UIApplication sharedApplication].keyWindow viewWithTag:1002];
    UIView *lineView1 = (UIView *)[self viewWithTag:10001];
    
    if (bgView) {
        [UIView animateWithDuration:0.3f
                         animations:^{
                             bgView.alpha = 0.0f;
                             tbl_view.frame = CGRectMake(0, 104, [UIScreen mainScreen].bounds.size.width, 0);
                             lineView1.alpha = 1.0f;
                         }
                         completion:^(BOOL finished) {
                             [bgView removeFromSuperview];
                             [tbl_view removeFromSuperview];
                             
                             for (UIView *view in self.subviews) {
                                 if ([view isKindOfClass:[UIButton class]]) {
                                     UIButton *button = (UIButton *)view;
                                     if (button.selected == YES) {
                                         button.selected = NO;
                                         [self reSetSubViewStateButton:button withState:0];
                                     }
                                 }
                             }
                         }];
    }
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ide = @"cell1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ide];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ide];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 180, 18)];
        lbTitle.backgroundColor = [UIColor clearColor];
        lbTitle.textColor = [DFToolClass getColor:@"434343"];
        lbTitle.tag = 103;
        lbTitle.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:lbTitle];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 39.5, [UIScreen mainScreen].bounds.size.width - 20, 0.5)];
        lineView.backgroundColor = [DFToolClass getColor:@"b2b2b2"];
        lineView.tag = 105;
        [cell.contentView addSubview:lineView];
    }
    UILabel *lbTitle = (UILabel *)[cell.contentView viewWithTag:103];
    UIView *lineView = (UIView *)[cell.contentView viewWithTag:105];
    
    lbTitle.text = [[dataSource objectAtIndex:indexPath.row] objectForKey:[titleType objectAtIndex:index]];

    
    if (indexPath.row == dataSource.count - 1) {
        lineView.hidden = YES;
    }
    else {
        lineView.hidden = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (selectMore) {
        dataSource = [[dataSource objectAtIndex:indexPath.row] objectForKey:@"child"];
        [tableView reloadData];
        NSInteger num = dataSource.count>10?10:dataSource.count;
        CGFloat deltaHeight = num * 40;
        [UIView animateWithDuration:0.3f
                         animations:^{
                             tableView.frame = CGRectMake(0, 104, [UIScreen mainScreen].bounds.size.width, deltaHeight);
                         }
                         completion:^(BOOL finished) {
                             ;
                         }];
        selectMore = NO;
    }
    else
    {
        [self dissmisSegmentView];
        NSString *strTitle = [[dataSource objectAtIndex:indexPath.row] objectForKey:[titleType objectAtIndex:index]];
        UIButton *btn = (UIButton *)[self viewWithTag:index];
        UILabel *lbTitle = (UILabel *)[btn viewWithTag:20 + btn.tag];
        CGFloat width = [DFToolClass widthOfLabel:strTitle ForFont:[UIFont systemFontOfSize:14] labelHeight:16];
        NSInteger num = 3;
        CGFloat deltaWidth = ([UIScreen mainScreen].bounds.size.width / num - width - 16) * 0.5;
        lbTitle.frame = CGRectMake(deltaWidth, 12, width, 16);
        
        UIImageView *imageView = (UIImageView *)[btn viewWithTag:10 + btn.tag];
        imageView.frame = CGRectMake(deltaWidth + width + 5, 16, 11, 8);
        
        lbTitle.text = strTitle;
        if ([self.delegate respondsToSelector:@selector(tuanSegmentIsClickWithType:withId:)]) {
            [self.delegate tuanSegmentIsClickWithType:index withId:[[dataSource objectAtIndex:indexPath.row] objectForKey:[idType objectAtIndex:index]]];
        }
        
        
    }
    
}


@end