//
//  GoodsCollectionListCell.m
//  nen
//
//  Created by nenios101 on 2017/6/19.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "GoodsCollectionListCell.h"
#import "CollectgoodsModel.h"

@interface GoodsCollectionListCell()

@property(nonatomic,strong) UIImageView *iconImagViews;

@property(nonatomic,strong) UILabel *contentTitle;

@property(nonatomic,strong) UILabel *priceLabel;

@end

@implementation GoodsCollectionListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
      [self addSubViewControll];
    }
    
    return self;
}

- (void)setGoodsModel:(CollectgoodsModel *)goodsModel
{
    _goodsModel = goodsModel;
    
    [self.iconImagViews sd_setImageWithURL:[NSURL URLWithString:goodsModel.img]];
    self.contentTitle.text = goodsModel.goods_name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",goodsModel.price];
    
}


- (void)addSubViewControll
{
    UIImageView *iconImage = [[UIImageView alloc] init];
    self.iconImagViews = iconImage;
    iconImage.frame = CGRectMake(10,10,80,80);
    [self.contentView addSubview:iconImage];
    
    CGFloat contentTitleW = (ScreenWidth - iconImage.sh_width) - 20;
    UILabel *contentTitle = [[UILabel alloc] init];
    self.contentTitle = contentTitle;
    contentTitle.frame = CGRectMake(iconImage.sh_right + 5,0,contentTitleW,50);
    contentTitle.numberOfLines = 0;
    contentTitle.font = [UIFont systemFontOfSize:13];
    contentTitle.textColor = [UIColor blackColor];
    contentTitle.text = @"1432423432423";
    [self.contentView addSubview:contentTitle];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    self.priceLabel = priceLabel;
    priceLabel.frame = CGRectMake(iconImage.sh_right + 5,contentTitle.sh_bottom + 10,50,25);
    priceLabel.textAlignment = NSTextAlignmentLeft;
    priceLabel.font = [UIFont systemFontOfSize:13];
    priceLabel.textColor = [UIColor redColor];
    [self.contentView addSubview:priceLabel];
    
}


@end
