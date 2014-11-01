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

@protocol DFShareHud <NSObject>

@end

@interface DFShareHud : UIView
{
    UIView *_bgView;
    UILabel *_label;
}

@property (nonatomic, assign) id<DFShareHud>delegage;

- (void)success;

- (void)error;

@end

@protocol DFSegmentDelegate <NSObject>

- (void)segmentIsClickWithType:(NSInteger)type withId:(NSString *)subid;

@end

@interface DFSegmentController : UIView <UITableViewDataSource,UITableViewDelegate>
{
    NSInteger index;
    BOOL more;
    BOOL selectMore;
    NSMutableArray *dataSource;
    
}

@property (nonatomic, assign) id<DFSegmentDelegate>delegate;
@property (nonatomic, retain) NSArray *segementTitle;
@property (nonatomic, retain) NSArray *segementData;
@property (nonatomic, assign) BOOL isShowing;

- (id)initWithFrame:(CGRect)frame
          withTitle:(NSArray *)title
           withData:(NSArray *)data;

- (void)dissmisSegmentView;

@end

@protocol DFTuanSegmentDelegate <NSObject>

- (void)tuanSegmentIsClickWithType:(NSInteger)type withId:(NSString *)subid;

@end

@interface DFTuanSegmentController : UIView<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger index;
    BOOL selectMore;
    NSMutableArray *dataSource;
}

@property (nonatomic, assign) id<DFTuanSegmentDelegate>delegate;
@property (nonatomic, retain) NSDictionary *segementData;
@property (nonatomic, assign) BOOL isShowing;

- (id)initWithFrame:(CGRect)frame withData:(NSDictionary *)data;

- (void)dissmisSegmentView;
@end