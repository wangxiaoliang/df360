//
//  DFSendVC.h
//  df360
//
//  Created by wangxl on 14-9-21.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFCustomViewController.h"

@interface DFSendVC : DFCustomViewController
@property (nonatomic, retain) NSDictionary *childDic;
+ (void)addDicWithKey:(NSString *)key andValue:(NSString *)value;
@end
