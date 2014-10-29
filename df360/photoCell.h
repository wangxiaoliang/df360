//
//  photoCell.h
//  SpiderMovie
//
//  Created by wangxl on 14-8-4.
//  Copyright (c) 2014年 Spider.com. All rights reserved.
//
@protocol photoCellDelegate <NSObject>

- (void)deletePhoto:(UIButton *)sender;

@end

#import <UIKit/UIKit.h>
@interface photoCell : UICollectionViewCell
- (void)initPhotoCell:(BOOL)isEdit whithPhotos:(NSMutableArray *)imageArr withIndexPath:(int)index withTag:(int)tag;
- (void)initPhotoCell:(BOOL)isEdit whithPhotoUrl:(NSMutableArray *)photoUrl withIndexPath:(int)index;
- (void)initAddPhotoCell;
@property (nonatomic, assign) id<photoCellDelegate> delegate;
@end
