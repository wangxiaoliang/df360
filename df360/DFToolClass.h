//
//  DFToolClass.h
//  df360
//
//  Created by wangxl on 14-9-14.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ifaddrs.h>
#import <arpa/inet.h>


/** 工具类 */
@interface DFToolClass : NSObject
/** 把十六进制颜色值转化  参数:十六进制颜色值 */
+ (UIColor *)getColor:(NSString *)hexColor;

/** 判断邮箱输入是否正确 */
+ (BOOL) validateEmail:(NSString *)email;


/** 判断用户是否登陆 */
+ (BOOL)isLogin;

+ (CGFloat)widthOfLabel:(NSString *)strText ForFont:(UIFont *)font labelHeight:(CGFloat)height;
/** 获取本机IP */
+ (NSString *)getIPAddress;

/** 判断字符串是否为null */
+ (NSString *)stringISNULL:(NSString *)str;

+ (CGFloat)heightOfLabel:(NSString *)strText forFont:(UIFont *)font labelLength:(CGFloat)length;

@end
