//
//  DFToolView.h
//  df360
//
//  Created by wangxl on 14-9-4.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 简单的自定义View */

@interface DFToolView : NSObject

@end

@protocol DFHudProgressDelegate <NSObject>

@end
/** 网络请求时提示框 */
@interface DFHudProgress: UIView
{
    UIView *_bgView;
    UIActivityIndicatorView *_activity;
}


@property (nonatomic ,assign) id<DFHudProgressDelegate>delegate;

- (void)show;

- (void)dismiss;

@end