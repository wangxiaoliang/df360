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

+ (CGFloat)widthOfLabel:(NSString *)strText ForFont:(UIFont *)font labelHeight:(CGFloat)height
{
    CGSize size;
    if (kOSVersion >= 7.0) {
        NSDictionary *attribute = @{UITextAttributeFont: font};
        size = [strText boundingRectWithSize:CGSizeMake(0, height) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    }
    else {
        size = [strText sizeWithFont:font];
    }
    
    return size.width;
}

+ (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}
/** 判断字符串是否为null */
+ (NSString *)stringISNULL:(NSString *)str
{
    return [str isEqual:[NSNull null]]?@"":str;
}

+ (CGFloat)heightOfLabel:(NSString *)strText forFont:(UIFont *)font labelLength:(CGFloat)length
{
    CGSize size;
    
    if (kOSVersion >= 7.0) {
        NSDictionary *attribute = @{UITextAttributeFont: font};
        size = [strText boundingRectWithSize:CGSizeMake(length, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    }
    else {
        size = [strText sizeWithFont:font constrainedToSize:CGSizeMake(length, 10000) lineBreakMode:NSLineBreakByCharWrapping];
    }
    
    return size.height;
}

@end
