//
//  DFCustomTableViewCell.m
//  df360
//
//  Created by wangxl on 14-9-17.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFCustomTableViewCell.h"
#import "DFToolClass.h"

#define cellWigth self.bounds.size.width
#define cellHeight self.bounds.size.height

@implementation DFCustomTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initTGCell
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 50, 50)];
    
    imageView.backgroundColor = [UIColor lightGrayColor];
    
    imageView.tag = 101;
    
    [self addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 120, 40)];
    
    titleLabel.backgroundColor = [UIColor clearColor];
    
    titleLabel.tag = 102;
    
    titleLabel.text = @"大甩卖";
    
    [self addSubview:titleLabel];
    
    UILabel *nowPrice = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, 70, 30)];
    
    nowPrice.text = @"￥190";
    
    nowPrice.tag = 103;
    
    nowPrice.backgroundColor = [UIColor clearColor];
    
    nowPrice.textColor = [DFToolClass getColor:@"ea4940"];
    
    [self addSubview:nowPrice];
    
    UILabel *oldPrice = [[UILabel alloc] initWithFrame:CGRectMake(170, 36, 60, 20)];
    
    oldPrice.text = @"￥200";
    
    oldPrice.tag = 104;
    
    oldPrice.backgroundColor = [UIColor clearColor];
    
    oldPrice.font = [UIFont systemFontOfSize:13];
    
    [self addSubview:oldPrice];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(170, 45.5, 40, 0.5)];
    
    line.backgroundColor = [UIColor blackColor];
    
    [self addSubview:line];
    
    UILabel *number = [[UILabel alloc] initWithFrame:CGRectMake(230, 30,  80, 30)];
    
    number.text = @"100人购买";
    
    number.tag = 105;
    
    number.backgroundColor = [UIColor clearColor];
    
    [self addSubview:number];
}

/** 给团购Cell赋值 */
- (void)reloadTGCellWithArray:(NSMutableArray *)arr withIndex:(NSInteger)row
{
    UIImageView *imageView = (UIImageView *)[self viewWithTag:101];
    
//    imageView.image = [UIImage imageNamed:[[arr objectAtIndex:row] objectForKey:<#(id)#>]]
    
    UILabel *titleLabel = (UILabel *)[self viewWithTag:102];
    
    titleLabel.text = [[arr objectAtIndex:row] objectForKey:@"goods_title"];
    
    UILabel *nowPrice = (UILabel *)[self viewWithTag:103];
    
    nowPrice.text = [NSString stringWithFormat:@"￥%@",[[arr objectAtIndex:row] objectForKey:@"goods_market_price"]];
    
    UILabel *oldPrice = (UILabel *)[self viewWithTag:104];
    
    oldPrice.text = [NSString stringWithFormat:@"￥%@",[[arr objectAtIndex:row] objectForKey:@"goods_price"]];
    
    UILabel *number = (UILabel *)[self viewWithTag:105];
    
    number.text = [NSString stringWithFormat:@"%@人购买",[[arr objectAtIndex:row] objectForKey:@"goods_total_buy"]];
}

/** 糗百 */
- (void)initQBCell
{
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 40, 40)];
    
    image.tag = 101;
    
    image.backgroundColor = [UIColor magentaColor];
    
    [self addSubview:image];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 220, 30)];
    
    title.tag = 102;
    
    title.backgroundColor = [UIColor clearColor];
    
    title.text = @"哈哈哈哈";
    
    [self addSubview:title];
    
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, 220, 40)];
    
    content.tag = 103;
    
    content.numberOfLines = 3;
    
    content.text = @"嘎达是的噶是的过分的话就有人粉底乳有人饭卡 哦哦 看 就是三个回合的奋斗嘎达是的噶是的过分的话就有人粉底乳有人饭卡 哦哦 看 就是三个回合的奋斗";
    
    content.backgroundColor = [UIColor clearColor];
    
    content.font = [UIFont systemFontOfSize:10];
    
    [self addSubview:content];
}

/** 给糗百Cell赋值 */
- (void)reloadQBCellWithArray:(NSMutableArray *)arr withIndex:(NSInteger)row
{
    UIImageView *image = (UIImageView *)[self viewWithTag:101];
    
    
    
    UILabel *title = (UILabel *)[self viewWithTag:102];
    
    title.text = [[arr objectAtIndex:row] objectForKey:@"subject"];
    
    UILabel *content = (UILabel *)[self viewWithTag:103];
    
    content.text = [[arr objectAtIndex:row] objectForKey:@"message"];
}

/** 糗百评论 */
- (void)initQBMessageCell
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 30, 30)];
    
    imageView.tag = 101;
    
    imageView.backgroundColor = [UIColor magentaColor];
    
    [self addSubview:imageView];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 100, 30)];
    
    name.backgroundColor = [UIColor clearColor];
    
    name.font = [UIFont systemFontOfSize:13];
    
    name.text = @"admin";
    
    name.tag = 102;
    
    [self addSubview:name];
    
    UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, cellWigth - 15, 40)];
    
    message.backgroundColor = [UIColor whiteColor];
    
    message.font = [UIFont systemFontOfSize:13];
    
    message .text = @"hahaha";
    
    message.tag = 103;
    
    [self addSubview:message];
    
}

/** 糗百评论赋值 */

- (void)reloadQBMessageWithArray:(NSArray *)arr withIndex:(NSInteger)row
{
    UIImageView *imageView = (UIImageView *)[self viewWithTag:101];
    
    UILabel *name = (UILabel *)[self viewWithTag:102];
    
    name.text = [[arr objectAtIndex:row] objectForKey:@"author"];
    
    UILabel *message = (UILabel *)[self viewWithTag:103];
    
    message.text = [[arr objectAtIndex:row] objectForKey:@"message"];
    
}

/** 子类列表cell */
- (void)initChildCell
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 50, 50)];
    
    imageView.backgroundColor = [UIColor lightGrayColor];
    
    imageView.tag = 101;
    
    [self addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 200, 40)];
    
    titleLabel.backgroundColor = [UIColor clearColor];
    
    titleLabel.tag = 102;
    
    titleLabel.text = @"大甩卖";
    
    [self addSubview:titleLabel];
    
    UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, 50, 30)];
    
    address.tag = 103;
    
    address.text = @"登封";
    
    address.font = [UIFont systemFontOfSize:13];
    
    [self addSubview:address];
    
    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(150, 30, 150, 30)];
    
    time.tag = 104;
    
    time.text = @"2014-09-21";
    
    time.font = [UIFont systemFontOfSize:13];
    
    [self addSubview:time];
    
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(250, 20, 50, 30)];
    
    price.text = @"123/元";
    
    price.tag = 105;
    
    price.font = [UIFont systemFontOfSize:13];
    
    [self addSubview:price];
    

}

/** 子类列表赋值 */
- (void)reloadChildCellWithArray:(NSArray *)arr withIndex:(NSInteger)row
{
    
    NSDictionary *dic = [arr objectAtIndex:row];
    
    UIImageView *imageView = (UIImageView *)[self viewWithTag:101];
    
    
    UILabel *title = (UILabel *)[self viewWithTag:102];
    title.text = [dic objectForKey:@"post_text"];
    UILabel *address = (UILabel *)[self viewWithTag:103];
    address.text = [dic objectForKey:@"area_title"];
    
    UILabel *time = (UILabel *)[self viewWithTag:104];
    time.text = [dic objectForKey:@"post_end_time"];
    
    UILabel *price = (UILabel *)[self viewWithTag:105];
    price.text = [NSString stringWithFormat:@"%@/%@",[dic objectForKey:@"post_price"],[dic objectForKey:@"post_price_unit"]];
    
}


@end
