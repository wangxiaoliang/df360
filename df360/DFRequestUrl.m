//
//  DFRequestUrl.m
//  df360
//
//  Created by wangxl on 14-9-14.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFRequestUrl.h"

@implementation DFRequestUrl
#define DFBaseUrl  @"http://www.df360.cc/df360/api/"


/** 注册 */
+ (NSString *)registerUrl
{
    return [NSString stringWithFormat:@"%@register",DFBaseUrl];
}

/** 登陆 */
+ (NSString *)loginUrl
{
    return [NSString stringWithFormat:@"%@login_validate",DFBaseUrl];
}

/** 获取置顶信息 */
+ (NSString *)getTopTitles
{
    return [NSString stringWithFormat:@"%@top_titles",DFBaseUrl];
}

/** 获取父分类信息 */
+ (NSString *)getFatherCatesUrl
{
    return [NSString stringWithFormat:@"%@father_cates",DFBaseUrl];
}

/** 获取子分类信息 */
+ (NSString *)getChildCatesUrlWithCatPid:(NSString *)catpid
{
    return [NSString stringWithFormat:@"%@child_cates?cat_pid=%@",DFBaseUrl, catpid];
}

/** 获取所有大小分类 */
+ (NSString *)getAllCates
{
    return [NSString stringWithFormat:@"%@all_cates",DFBaseUrl];
}

/** 获取团购分类信息 */
+ (NSString *)getTuanCat
{
    return [NSString stringWithFormat:@"%@tuan_cat?cat_pid=0",DFBaseUrl];

}

/** 团购列表信息 */
+ (NSString *)getTGoods
{
    return [NSString stringWithFormat:@"%@tuan_goods",DFBaseUrl];
}

/** 获取糗百信息 */
+ (NSString *)getQBInfoWithFid:(NSString *)fid withPage:(NSInteger)page
{
    return [NSString stringWithFormat:@"%@form_info_list?fid=%@&page=%ld",DFBaseUrl,fid,(long)page];
}

/** 获取具体的某个糗百信息 */
+ (NSString *)getQBInfoWithTid:(NSString *)tid
{
    return [NSString stringWithFormat:@"%@form_info?tid=%@",DFBaseUrl,tid];

}

/** 获取子分类信息下信息列表接口 */
+ (NSString *)getSubcatListWithPage:(NSString *)page
                       withSubcatId:(NSString *)subcat_id
{
    return [NSString stringWithFormat:@"%@subcat_list?page=%@&subcat_id=%@",DFBaseUrl, page, subcat_id];
}

/** 我置顶信息列表 */
+ (NSString *)getInfoUpWithUid:(NSString *)uid
                      withPage:(NSString *)page
{
    return [NSString stringWithFormat:@"%@info_up?member_uid=%@&page=%@",DFBaseUrl, uid, page];
}

/** 我发布的信息 */
+ (NSString *)getMyInfoWithPage:(NSString *)page
                        withUid:(NSString *)Uid
{
    return [NSString stringWithFormat:@"%@info_posts?page=%@&member_uid=%@",DFBaseUrl, page, Uid];

}

@end
