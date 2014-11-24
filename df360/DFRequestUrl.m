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
+ (NSString *)getTGoodsWithPage:(NSString *)page
{
    return [NSString stringWithFormat:@"%@tuan_goods?page=%@",DFBaseUrl,page];
}

/** 团购详情 */
+ (NSString *)TGInfoWithID:(NSString *)catId
{
    return [NSString stringWithFormat:@"%@tuan_good_info?goods_id=%@",DFBaseUrl, catId];
}

/** 获取糗百分类接口 */
+ (NSString *)getQBFid
{
    return [NSString stringWithFormat:@"%@qb_fids", DFBaseUrl];
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

/** 获取糗百留言 */
+ (NSString *)getQBMessageWithTid:(NSString *)tid
                         withPage:(NSString *)page
{
    return [NSString stringWithFormat:@"%@form_info_liuyan?tid=%@&page=%@",DFBaseUrl, tid, page];
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

/** 获取信息详情接口 */
+ (NSString *)getInfoPostWithPostId:(NSString *)postId
{
    return [NSString stringWithFormat:@"%@info_post?post_id=%@",DFBaseUrl ,postId];
}

/** 举报接口 */
+ (NSString *)report
{
    return [NSString stringWithFormat:@"%@info_jubao",DFBaseUrl];
}


/** 我发布的信息 */
+ (NSString *)getMyInfoWithPage:(NSString *)page
                        withUid:(NSString *)Uid
{
    return [NSString stringWithFormat:@"%@info_posts?page=%@&member_uid=%@",DFBaseUrl, page, Uid];

}

/** 初始化所属区域 */
+ (NSString *)getArea
{
    return [NSString stringWithFormat:@"%@info_area",DFBaseUrl];
}

/** 初始化交易类型 */
+ (NSString *)getTradeType
{
    return [NSString stringWithFormat:@"%@trade_type",DFBaseUrl];
}

/** 初始化付款方式 */
+ (NSString *)getFukuan
{
    return [NSString stringWithFormat:@"%@fukuan",DFBaseUrl];
}

/** 初始化新旧程度 */
+ (NSString *)getXinjiu
{
    return [NSString stringWithFormat:@"%@xinjiu",DFBaseUrl];
}

/** 查询条件接口 */
+ (NSString *)sysSetWithSubcatid:(NSString *)subcatid
{
    return [NSString stringWithFormat:@"%@sysset_bysubcat_id?subcat_id=%@",DFBaseUrl, subcatid];

}

/** 获取发布布局 */
+ (NSString *)getLayoutWithId:(NSString *)catId
{
    return [NSString stringWithFormat:@"%@sysset_bysubcat_all?subcat_id=%@",DFBaseUrl, catId];
}

/** 发布消息 */
+ (NSString *)postInfo
{
    return [NSString stringWithFormat:@"%@info_postinfo",DFBaseUrl];
}

/** 积分规则 */
+ (NSString*)jifenrole
{
    return [NSString stringWithFormat:@"%@jifenrole",DFBaseUrl];
}

/** 收藏 */
+ (NSString *)tuanFavWithUserId:(NSString *)uid
                   withGoods_id:(NSString *)goods_id
{
    return [NSString stringWithFormat:@"%@tuan_fav?u_id=%@&goods_id=%@",DFBaseUrl, uid, goods_id];

}

/** 我的收藏 */
+ (NSString *)myFavWithUserId:(NSString *)uid
{
    return [NSString stringWithFormat:@"%@mine_favs?u_id=%@",DFBaseUrl, uid];
}

@end
