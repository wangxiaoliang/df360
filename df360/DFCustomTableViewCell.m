//
//  DFCustomTableViewCell.m
//  df360
//
//  Created by wangxl on 14-9-17.
//  Copyright (c) 2014年 wangxl. All rights reserved.
//

#import "DFCustomTableViewCell.h"
#import "DFToolClass.h"
#import "UIImageView+WebCache.h"


#define cellWigth self.bounds.size.width
#define cellHeight self.bounds.size.height
#define baseURL @"http://www.df360.cc/"

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
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 240, 25)];
    
    titleLabel.backgroundColor = [UIColor clearColor];
    
    titleLabel.tag = 102;
    
    titleLabel.text = @"大甩卖";
    
    titleLabel.font = [UIFont systemFontOfSize:16];
    
    [self addSubview:titleLabel];
    
    UILabel *nowPrice = [[UILabel alloc] initWithFrame:CGRectMake(80, 45, 100, 30)];
    
    nowPrice.text = @"￥190";
    
    nowPrice.tag = 103;
    
    nowPrice.backgroundColor = [UIColor clearColor];
    
    nowPrice.font = [UIFont systemFontOfSize:15];
    
    nowPrice.textColor = [DFToolClass getColor:@"ea4940"];
    
    [self addSubview:nowPrice];
    
    UILabel *oldPrice = [[UILabel alloc] initWithFrame:CGRectMake(180, 50, 100, 20)];
    
    oldPrice.text = @"￥200";
    
    oldPrice.tag = 104;
    
    oldPrice.backgroundColor = [UIColor clearColor];
    
    oldPrice.font = [UIFont systemFontOfSize:13];
    
    [self addSubview:oldPrice];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(180, 60, 80, 0.5)];
    
    line.tag = 110;
    
    line.backgroundColor = [UIColor blackColor];
    
    [self addSubview:line];
    
    UILabel *number = [[UILabel alloc] initWithFrame:CGRectMake(200, 30,  110, 30)];
    
    number.text = @"100人购买";
    
    number.tag = 105;
    
    number.font = [UIFont systemFontOfSize:13];
    
    number.textAlignment = NSTextAlignmentRight;
    
    number.backgroundColor = [UIColor clearColor];
    
    [self addSubview:number];

    
    UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, 150, 15)];
    
    desLabel.backgroundColor = [UIColor clearColor];
    
    desLabel.tag = 106;
    
    desLabel.text = @"大甩卖";
    
    desLabel.font = [UIFont systemFontOfSize:16];
    
    [self addSubview:desLabel];

    
}

/** 给团购Cell赋值 */
- (void)reloadTGCellWithArray:(NSMutableArray *)arr withIndex:(NSInteger)row
{
    UIImageView *imageView = (UIImageView *)[self viewWithTag:101];
    

    [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseURL,[[arr objectAtIndex:row] objectForKey:@"goods_pic"]]] placeholderImage:[UIImage imageNamed:@"default_img"]];

    
    
    UILabel *titleLabel = (UILabel *)[self viewWithTag:102];
    
    titleLabel.text = [[arr objectAtIndex:row] objectForKey:@"goods_title"];
    
    UILabel *nowPrice = (UILabel *)[self viewWithTag:103];
    
    nowPrice.text = [NSString stringWithFormat:@"现价￥%@",[[arr objectAtIndex:row] objectForKey:@"goods_price"]];
    
    UIView *line = (UIView *)[self viewWithTag:110];
    
    
    
    UILabel *oldPrice = (UILabel *)[self viewWithTag:104];
    
    oldPrice.text = [NSString stringWithFormat:@"原价￥%@",[[arr objectAtIndex:row] objectForKey:@"goods_market_price"]];
    
    CGSize size = CGSizeMake(320,2000);
    
    CGSize labelsize = [[NSString stringWithFormat:@"原价￥%@",[[arr objectAtIndex:row] objectForKey:@"goods_market_price"]] sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    
    [line setFrame:CGRectMake(180, 60, labelsize.width, 0.5)];
    
    UILabel *number = (UILabel *)[self viewWithTag:105];
    
    number.text = [NSString stringWithFormat:@"%@人购买",[[arr objectAtIndex:row] objectForKey:@"goods_sellsum"]];
    
    UILabel *desLabel = (UILabel *)[self viewWithTag:106];
    
    desLabel.text = [[arr objectAtIndex:row] objectForKey:@"goods_text"];

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
    
    title.font = [UIFont systemFontOfSize:15];
    
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
    
    [image setImage:[UIImage imageNamed:@"default_img"]];
    
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
    
    UILabel *message = [[UILabel alloc] init];
    
    
    message.backgroundColor = [UIColor whiteColor];
    
    message.font = [UIFont systemFontOfSize:13];
    
    message .text = @"hahaha";
    
    message.tag = 103;
    
    [self addSubview:message];
    
    self.backgroundColor = [UIColor whiteColor];
    
}

/** 糗百评论赋值 */

- (void)reloadQBMessageWithArray:(NSArray *)arr withIndex:(NSInteger)row
{
    UIImageView *imageView = (UIImageView *)[self viewWithTag:101];
    
    imageView.image = [UIImage imageNamed:@"default_img"];
    
    UILabel *name = (UILabel *)[self viewWithTag:102];
    
    name.text = [[arr objectAtIndex:row] objectForKey:@"author"];
    
    UILabel *message = (UILabel *)[self viewWithTag:103];
    
    [message setNumberOfLines:0];
    
    CGSize size = CGSizeMake(cellWigth - 25, 100);
    
    CGSize messageSize = [[[arr objectAtIndex:row] objectForKey:@"message"] sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];

    [message setFrame:CGRectMake(15, 42, cellWigth - 25, messageSize.height)];
    
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
    
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(250, 10, 70, 50)];
    
    price.text = @"123/元";
    
    price.tag = 105;
    
    price.font = [UIFont systemFontOfSize:13];
    
    [self addSubview:price];
    

}

/** 子类列表赋值 */
- (void)reloadChildCellWithArray:(NSArray *)arr withIndex:(NSInteger)row
{
    
    NSDictionary *dic = (NSDictionary *)[arr objectAtIndex:row];
    
    UIImageView *imageView = (UIImageView *)[self viewWithTag:101];
    
    [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseURL,[dic objectForKey:@"post_img_1"]]] placeholderImage:[UIImage imageNamed:@"default_img"]];
    UILabel *title = (UILabel *)[self viewWithTag:102];
    
    title.text = [dic objectForKey:@"post_text"];
    UILabel *address = (UILabel *)[self viewWithTag:103];
    address.text = [dic objectForKey:@"area_title"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"post_end_time"] floatValue]];
    
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *regStr = [df stringFromDate:confromTimesp];

    UILabel *time = (UILabel *)[self viewWithTag:104];
    time.text = regStr;
    
    UILabel *price = (UILabel *)[self viewWithTag:105];
    price.numberOfLines = 2;
    price.text = [NSString stringWithFormat:@"%@%@",[dic objectForKey:@"post_price"],[dic objectForKey:@"post_price_unit"]];
}

/** 修改资料cell */
- (void)initModifyUserInfoCellWithTitleArray:(NSArray *)arr Index:(NSInteger)row
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 80, 20)];
    
    titleLabel.text = [arr objectAtIndex:row];
    
    titleLabel.font = [UIFont systemFontOfSize:13];
    
    titleLabel.backgroundColor = [UIColor clearColor];
    
    [self addSubview:titleLabel];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(105, 6, 170, 32)];
    
    textField.backgroundColor = [UIColor clearColor];
    
    textField.borderStyle = UITextBorderStyleRoundedRect;
    
    textField.tag = row + 1000;
    
    textField.returnKeyType = UIReturnKeyDone;
    
    [self addSubview:textField];
}

/** 我发布、置顶的信息Cell */
- (void)initMySendMessageCell
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 30, 30)];
    
    imageView.backgroundColor = [UIColor lightGrayColor];
    
    imageView.tag = 101;
    
    [self addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 150, 20)];
    
    titleLabel.text = @"标题";
    
    titleLabel.tag = 102;
    
    titleLabel.backgroundColor = [UIColor clearColor];
    
    titleLabel.font = [UIFont systemFontOfSize:13];
    
    titleLabel.textAlignment = NSTextAlignmentLeft;
    
    [self addSubview:titleLabel];
    
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, 150, 20)];
    
    typeLabel.text = @"租房";
    
    typeLabel.tag = 103;
    
    typeLabel.backgroundColor = [UIColor clearColor];
    
    typeLabel.textAlignment = NSTextAlignmentLeft;
    
    typeLabel.font = [UIFont systemFontOfSize:13];
    
    [self addSubview:typeLabel];
    
    UILabel *beginTime = [[UILabel alloc] initWithFrame:CGRectMake(210, 5, 100, 20)];
    
    beginTime.text = @"2014-09-28";
    
    beginTime.backgroundColor = [UIColor clearColor];
    
    beginTime.tag = 104;
    
    beginTime.textAlignment = NSTextAlignmentLeft;
    
    beginTime.font = [UIFont systemFontOfSize:13];
    
    [self addSubview:beginTime];
    
    UILabel *endTime = [[UILabel alloc] initWithFrame:CGRectMake(210, 30, 100, 20)];
    
    endTime.text = @"2014-09-30";
    
    endTime.backgroundColor = [UIColor clearColor];
    
    endTime.tag = 105;
    
    endTime.textAlignment = NSTextAlignmentLeft;
    
    endTime.font = [UIFont systemFontOfSize:13];
    
    [self addSubview:endTime];

    
}

/** 我发布、置顶的信息赋值 */
- (void)reloadMySendMessageWithArray:(NSArray *)arr WithIndex:(NSInteger)row
{
    UIImageView *imageView = (UIImageView *)[self viewWithTag:101];
    
    [imageView setImageWithURL:[NSURL URLWithString:[DFToolClass stringISNULL:[[arr objectAtIndex:row] objectForKey:@"post_img_1"]]] placeholderImage:[UIImage imageNamed:@"default_img"]];
    
    UILabel *titleLabel = (UILabel *)[self viewWithTag:102];
    
    titleLabel.text = [DFToolClass stringISNULL:[[arr objectAtIndex:row] objectForKey:@"post_title"]];
    
    UILabel *cateLable = (UILabel *)[self viewWithTag:103];
    
    cateLable.text = [DFToolClass stringISNULL:[[arr objectAtIndex:row] objectForKey:@"cat_title"]];
    
    UILabel *beginTime = (UILabel *)[self viewWithTag:104];
    
    NSDate *beginDate = [NSDate dateWithTimeIntervalSince1970:[[DFToolClass stringISNULL:[[arr objectAtIndex:row] objectForKey:@"post_begin_time"]] floatValue]];
    

    
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:[[DFToolClass stringISNULL:[[arr objectAtIndex:row] objectForKey:@"post_end_time"]] floatValue]];
    
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *beginStr = [df stringFromDate:beginDate];

    NSString *endStr = [df stringFromDate:endDate];
    
    beginTime.text = beginStr;
    
    UILabel *endTime = (UILabel *)[self viewWithTag:105];
    
    endTime.text = endStr;
}

- (void)initMyTGCell
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, cellWigth-30, 10)];
    
    titleLabel.tag = 801;
    
    [self addSubview:titleLabel];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 80, 15)];
    
    timeLabel.tag = 802;
    
    [self addSubview:timeLabel];
    
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 15, 60, 15)];
    
    typeLabel.tag = 803;
    
    [self addSubview:typeLabel];
    
    UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, 80, 15)];
    
    totalLabel.tag = 804;
    
    [self addSubview:totalLabel];
    
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 35, 60, 15)];
    
    numLabel.tag = 805;
    
    [self addSubview:numLabel];

}

- (void)initTGCellWithArray:(NSMutableArray *)arr withIndex:(NSInteger)index
{
    UILabel *titleLabel = (UILabel *)[self viewWithTag:801];
    
    [titleLabel setNumberOfLines:0];
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 测试字串
    NSString *s =[DFToolClass stringISNULL:[[arr objectAtIndex:index] objectForKey:@"goods_title"]];
    
    titleLabel.text = s;
    
    CGFloat height = [DFToolClass heightOfLabel:s forFont:[UIFont systemFontOfSize:14] labelLength:160];
    
    [titleLabel setFrame:CGRectMake(15, 5, cellWigth - 30, height + 15)];
    
    
    UILabel *timeLabel = (UILabel *)[self viewWithTag:802];
    
    [timeLabel setFrame:CGRectMake(15, height + 15, 80, 15)];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[DFToolClass stringISNULL:[[arr objectAtIndex:index] objectForKey:@"orderlist_time"]] floatValue]];
    
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yy-MM-dd"];
    NSString *regStr = [df stringFromDate:confromTimesp];
    
    if ([[DFToolClass stringISNULL:[[arr objectAtIndex:index] objectForKey:@"orderlist_time"]] isEqualToString:@""]) {
        regStr = @"";
    }
    
    timeLabel.text = regStr;
    
    timeLabel.textColor = [UIColor lightGrayColor];
    
    timeLabel.font = [UIFont systemFontOfSize:14];
    
    timeLabel.backgroundColor = [UIColor clearColor];
    
    UILabel *typeLabel = (UILabel *)[self viewWithTag:803];
    
    [typeLabel setFrame:CGRectMake(95, height + 15, 60, 15)];
    
    NSString *typeStr = @"";
    
    NSString *listStatus = [DFToolClass stringISNULL:[[arr objectAtIndex:index] objectForKey:@"orderlist_usestatus"]];
    
    if ([listStatus isEqualToString:@"2"]) {
        typeStr = @"已支付未消费";
    }
    if ([listStatus isEqualToString:@"1"]) {
        typeStr = @"未支付";
    }
    if ([listStatus isEqualToString:@"3"]) {
        typeStr = @"已付款已消费";
    }
    if ([listStatus isEqualToString:@"4"]) {
        typeStr = @"申请退款中";
    }
    if ([listStatus isEqualToString:@"5"]) {
        typeStr = @"已退款";
    }
    
    typeLabel.text = typeStr;
    
    typeLabel.textColor = [UIColor orangeColor];
    
    typeLabel.font = [UIFont systemFontOfSize:14];
    
    typeLabel.backgroundColor = [UIColor clearColor];
    
    
    UILabel *totalLabel = (UILabel *)[self viewWithTag:804];
    
    [totalLabel setFrame:CGRectMake(15, height + 35, 80, 15)];
    
    totalLabel.textColor = [UIColor lightGrayColor];
    
    totalLabel.text = [NSString stringWithFormat:@"总价:%@",[DFToolClass stringISNULL:[[arr objectAtIndex:index] objectForKey:@"goods_price"]]];
    
    totalLabel.font = [UIFont systemFontOfSize:14];
    
    totalLabel.backgroundColor = [UIColor clearColor];
    
    UILabel *numLabel = (UILabel *)[self viewWithTag:805];
    
    [numLabel setFrame:CGRectMake(95, height + 35, 60, 15)];
    
    numLabel.textColor = [UIColor lightGrayColor];
    
    numLabel.text = [NSString stringWithFormat:@"数量:%@",[DFToolClass stringISNULL:[[arr objectAtIndex:index] objectForKey:@"goods_sum"]]];
    
    numLabel.font = [UIFont systemFontOfSize:14];
    
    numLabel.backgroundColor = [UIColor clearColor];
        
    [self setFrame:CGRectMake(0, 0, cellWigth, height + 60)];

}

@end
