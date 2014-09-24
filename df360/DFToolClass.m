//
//  DFToolClass.m
//  df360
//
//  Created by wangxl on 14-9-14.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFToolClass.h"

@implementation DFToolClass

/** 把十六进制颜色值转化  参数:十六进制颜色值 */
+ (UIColor *)getColor:(NSString *)hexColor
{
    NSAssert(hexColor.length == 6, @"参数 hexColor 长度必须等于6");
    
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
}

/** 判断邮箱输入是否正确 */
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/** 判断用户是否登陆 */
+ (BOOL)isLogin
{
    /********** 判断是否登陆 **********/
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString *name = [userDefault objectForKey:@"username"];

    return (name == nil)?false:true;
}

@end
