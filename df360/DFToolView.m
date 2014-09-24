//
//  DFToolView.m
//  df360
//
//  Created by wangxl on 14-9-4.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//


#import "DFToolView.h"
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