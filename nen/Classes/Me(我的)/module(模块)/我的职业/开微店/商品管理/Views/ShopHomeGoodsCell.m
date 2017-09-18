//
//  ShopHomeGoodsCell.m
//  nen
//
//  Created by nenios101 on 2017/6/5.
//  Copyright © 2017年 nen. All rights reserved.
// 店铺首页 全部宝贝 新品上架

#import "ShopHomeGoodsCell.h"
#import "MyShopGoodsModel.h"

@interface ShopHomeGoodsCell ()

@property(nonatomic,strong) UIImageView *iconImageView;

@property(nonatomic,strong) UILabel *headlineTitle;

@property(nonatomic,strong) UILabel *discountPricesTitle;

@property(nonatomic,strong) UILabel *soldTitle;

@property(nonatomic,strong) UILabel *freightsTitle;
@end


@implementation ShopHomeGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self addSubviewControll];
    }
    
    return self;
}



- (void)setModel:(MyShopGoodsModel *)model
{
    _model = model;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.goods_img]];
    self.headlineTitle.text = model.goods_name;
    self.discountPricesTitle.text = [NSString stringWithFormat:@"¥%@",model.price];
    self.soldTitle.text = [NSString stringWithFormat:@"已售%@",model.sale_num];
    self.freightsTitle.text = [NSString stringWithFormat:@"运费%@",model.carriage];
    
}

-(void)addSubviewControll
{
    UIView *mainBodyView = [[UIView alloc] init];
    mainBodyView.frame = CGRectMake(0,5,ScreenWidth,145);
    mainBodyView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:mainBodyView];
    
    UIImageView *iconImag = [[UIImageView alloc] init];
    self.iconImageView = iconImag;
    iconImag.frame = CGRectMake(10,15,100,100);
    iconImag.image = [UIImage imageNamed:@"1"];
    [mainBodyView addSubview:iconImag];
    
    UILabel *centerTitle = [[UILabel alloc] init];
    self.headlineTitle = centerTitle;
    centerTitle.frame = CGRectMake(iconImag.sh_right + 10,10,ScreenWidth - 130,35);
    centerTitle.text= @"是非得失风格的是非得失公司返回韩国代购还记得个梵蒂冈和返回雕塑返回韩对方的负担国电视剧";
    centerTitle.numberOfLines = 0;
    centerTitle.lineBreakMode = NSLineBreakByWordWrapping;
    centerTitle.font = [UIFont systemFontOfSize:13];
    [mainBodyView addSubview:centerTitle];
    
    UILabel * discountPriceTitle = [[UILabel alloc] init];
    self.discountPricesTitle = discountPriceTitle;
    discountPriceTitle.frame = CGRectMake(centerTitle.sh_x,centerTitle.sh_bottom + 10,80,20);
    discountPriceTitle.text = @"¥6.00";
    discountPriceTitle.font = [UIFont systemFontOfSize:14];
    discountPriceTitle.textColor = [UIColor redColor];
    [mainBodyView addSubview:discountPriceTitle];
    
    
    UILabel *soldItemTitle = [[UILabel alloc] init];
    self.soldTitle = soldItemTitle;
    soldItemTitle.frame = CGRectMake(discountPriceTitle.sh_x,discountPriceTitle.sh_bottom + 20,50,20);
    soldItemTitle.text = @"已售666";
    soldItemTitle.font = [UIFont systemFontOfSize:12];
    [mainBodyView addSubview:soldItemTitle];
    
    UILabel *freightTitle = [[UILabel alloc] init];
    self.freightsTitle = freightTitle;
    freightTitle.frame = CGRectMake(soldItemTitle.sh_right + 30,soldItemTitle.sh_y,45,20);
    freightTitle.text = @"不含运费";
    freightTitle.font = [UIFont systemFontOfSize:10];
    [mainBodyView addSubview:freightTitle];
    
}



@end
