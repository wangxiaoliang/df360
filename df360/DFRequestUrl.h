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

/** 获取父分类信息 */
+ (NSString *)getFatherCatesUrl;

/** 获取子分类信息 */
+ (NSString *)getChildCatesUrlWithCatPid:(NSString *)catpid;

/** 获取所有大小分类 */
+ (NSString *)getAllCates;

/** 获取团购分类信息 */
+ (NSString *)getTuanCat;

/** 团购列表信息 */
+ (NSString *)getTGoods;

/** 获取糗百信息 */
+ (NSString *)getQBInfoWithFid:(NSString *)fid withPage:(NSInteger)page;

/** 获取具体的某个糗百信息 */
+ (NSString *)getQBInfoWithTid:(NSString *)tid;

/** 获取子分类信息下信息列表接口 */
+ (NSString *)getSubcatListWithPage:(NSString *)page
                       withSubcatId:(NSString *)subcat_id;

/** 我置顶信息列表 */
+ (NSString *)getInfoUpWithUid:(NSString *)uid
                      withPage:(NSString *)page;
@end
