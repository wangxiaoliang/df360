//
//  DFCustomTableViewCell.h
//  df360
//
//  Created by wangxl on 14-9-17.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DFCustomTableViewCell : UITableViewCell

/** 团购 */
- (void)initTGCell;

/** 给团购Cell赋值 */
- (void)reloadTGCellWithArray:(NSMutableArray *)arr withIndex:(NSInteger)row;

/** 糗百 */
- (void)initQBCell;

/** 给糗百Cell赋值 */
- (void)reloadQBCellWithArray:(NSMutableArray *)arr withIndex:(NSInteger)row;

/** 糗百评论 */
- (void)initQBMessageCell;

/** 糗百评论赋值 */

- (void)reloadQBMessageWithArray:(NSArray *)arr withIndex:(NSInteger)row;

/** 子类列表cell */
- (void)initChildCell;

/** 子类列表赋值 */
- (void)reloadChildCellWithArray:(NSArray *)arr withIndex:(NSInteger)row;

/** 修改资料cell */
- (void)initModifyUserInfoCellWithTitleArray:(NSArray *)arr Index:(NSInteger)row;

/** 我发布、置顶的信息Cell */
- (void)initMySendMessageCell;

/** 我发布、置顶的信息赋值 */
- (void)reloadMySendMessageWithArray:(NSArray *)arr WithIndex:(NSInteger)row;

- (void)initMyTGCell;

- (void)initTGCellWithArray:(NSMutableArray *)arr withIndex:(NSInteger)index;
@end
