//
//  DFCustomViewController.h
//  df360
//
//  Created by wangxl on 14-9-15.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UINavigationLineColor) {
    UINavigationLineColorDefault                   = 0,  //默认背景色
    UINavigationLineColorCustom                    = 1,  //重写
};

typedef NS_ENUM(NSInteger, UIBackGroundColorStyle) {
    UIViewBackGroundColorDefault                   = 0,  //默认背景色
    UIViewBackGroundColorCustom                    = 1,  //子类中重写
};

typedef NS_ENUM(NSInteger, LeftBarStyle) {
    LeftBarStyleDefault                  = 0,  //返回按钮
    LeftBarStyleClick                    = 1,  //紫色
    LeftBarStyleNone                     = 2,  //自定义
};

typedef NS_ENUM(NSInteger, RightBarStyle) {
    RightBarStyleDefault                  = 0, //分享按钮
    RightBarStyleClick                    = 1, //自定义响应函数
    RightBarStyleNone                     = 2, //自定义
};

typedef NS_ENUM(NSInteger, ExtendedLayout) {
    ExtendedLayoutDefault                  = 0,
    ExtendedLayoutBottom                   = 1,
};

@protocol WCustomVCDelegate <NSObject>

@optional
- (void)share:(UIButton *)sender;

/** UINavigation pop 时响应 */
- (void)didPopViewController;

@end

/** 此类中完成基础设置（背景色，title，bar等），需调用[super viewDidLoad],其他Controller继承此类。 */
@interface DFCustomViewController : UIViewController

/** 导航栏底部分割线背景色 */
@property (nonatomic, assign) UINavigationLineColor WNavigationColor;

/** 设置背景色 */
@property (nonatomic, assign) UIBackGroundColorStyle WBackGroundColorStyle;

/** 设置leftBar */
@property (nonatomic, assign) LeftBarStyle WLeftBarStyle;

/** 设置rightBar */
@property (nonatomic, assign) RightBarStyle WRightBarStyle;

/** 设置视图控制器的外观 */
@property (nonatomic, assign) ExtendedLayout WExtendedLayout;

/** 导航栏title */
@property (nonatomic, copy) NSString *WTitle;

/** 网络失败，显示此View，点击重新加载 */
@property (nonatomic, retain) UIView *touchView;

@property (nonatomic, assign) id<WCustomVCDelegate>delegate;

/** 轻触屏幕重新加载*/
- (void)reloadAgain;

@end
