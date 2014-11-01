//
//  DFSendSelectVC.h
//  df360
//
//  Created by wangxl on 14/10/30.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//
@protocol sendSelectDelegate <NSObject>

- (void)addDicWithKey:(NSString *)key andValue:(NSString *)value andTitle:(NSString *)title;

@end

#import "DFCustomViewController.h"
@interface DFSendSelectVC : DFCustomViewController
@property (nonatomic, retain) NSDictionary *selectDic;
@property (nonatomic, assign) id<sendSelectDelegate> sendDelegate;
@end
