//
//  photoCell.m
//  SpiderMovie
//
//  Created by wangxl on 14-8-4.
//  Copyright (c) 2014年 Spider.com. All rights reserved.
//

#import "photoCell.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "DFToolClass.h"
#import <QuartzCore/QuartzCore.h>


@implementation photoCell

{
    UIImageView *_photoImgView;
    UIButton *_deleteBtn;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _photoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 0, 74, 74)];
        [self addSubview:_photoImgView];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)initPhotoCell:(BOOL)isEdit whithPhotos:(NSMutableArray *)imageArr withIndexPath:(int)index withTag:(int)tag
{
    
    [_photoImgView setImage:[imageArr objectAtIndex:index]];
    [_photoImgView setNeedsLayout];
    _photoImgView.layer.masksToBounds = YES;
    _photoImgView.layer.cornerRadius = 10.0;
    _photoImgView.layer.borderWidth = 0;
    
    
    
}

- (void)initPhotoCell:(BOOL)isEdit whithPhotoUrl:(NSMutableArray *)photoUrl withIndexPath:(int)index
{
    
    
    _photoImgView.layer.masksToBounds = YES;
    _photoImgView.layer.cornerRadius = 10.0;
    _photoImgView.layer.borderWidth = 0;
    
    
}

- (void)initAddPhotoCell
{
    _photoImgView.image = [UIImage imageNamed:@"publish_add_image_normal"];
    _photoImgView.layer.masksToBounds = YES;
    _photoImgView.layer.cornerRadius = 10.0;
    _photoImgView.layer.borderWidth = 0;
    _photoImgView.backgroundColor = [DFToolClass getColor:@"e5e5e5"];
    _deleteBtn.hidden = YES;
}


@end
