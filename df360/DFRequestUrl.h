//
//  DFRequestUrl.h
//  df360
//
//  Created by wangxl on 14-9-14.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFRequestUrl : NSObject
/** 注册 */
+ (NSString *)registerUrl;

/** 登陆 */
+ (NSString *)loginUrl;

/** 获取置顶信息 */
+ (NSString *)getTopTitles;

/** 获取信息详情接口 */
+ (NSString *)getInfoPostWithPostId:(NSString *)postId;

/** 举报接口 */
+ (NSString *)report;

/** 获取父分类信息 */
+ (NSString *)getFatherCatesUrl;

/** 获取子分类信息 */
+ (NSString *)getChildCatesUrlWithCatPid:(NSString *)catpid;

/** 获取所有大小分类 */
+ (NSString *)getAllCates;

/** 获取团购分类信息 */
+ (NSString *)getTuanCat;

/** 团购列表信息 */
+ (NSString *)getTGoodsWithPage:(NSString *)page;

/** 团购详情 */
+ (NSString *)TGInfoWithID:(NSString *)catId;

/** 获取糗百分类接口 */
+ (NSString *)getQBFid;

/** 获取糗百信息 */
+ (NSString *)getQBInfoWithFid:(NSString *)fid withPage:(NSInteger)page;

/** 获取具体的某个糗百信息 */
+ (NSString *)getQBInfoWithTid:(NSString *)tid;

/** 获取糗百留言 */
+ (NSString *)getQBMessageWithTid:(NSString *)tid
                         withPage:(NSString *)page;

/** 获取子分类信息下信息列表接口 */
+ (NSString *)getSubcatListWithPage:(NSString *)page
                       withSubcatId:(NSString *)subcat_id;

/** 我置顶信息列表 */
+ (NSString *)getInfoUpWithUid:(NSString *)uid
                      withPage:(NSString *)page;

/** 我发布的信息 */
+ (NSString *)getMyInfoWithPage:(NSString *)page
                        withUid:(NSString *)Uid;

/** 获取发布布局 */
+ (NSString *)getLayoutWithId:(NSString *)catId;
/** 初始化所属区域 */
+ (NSString *)getArea;

/** 初始化交易类型 */
+ (NSString *)getTradeType;

/** 初始化付款方式 */
+ (NSString *)getFukuan;

/** 初始化新旧程度 */
+ (NSString *)getXinjiu;

/** 初始化接口 */
+ (NSString *)sysSetWithSubcatid:(NSString *)subcatid;
@end
