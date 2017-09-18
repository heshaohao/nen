//
//  ShopToCollectCell.m
//  nen
//
//  Created by nenios101 on 2017/6/20.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "ShopToCollectCell.h"
#import "ShopFavoritesModel.h"

@interface ShopToCollectCell ()

@property(nonatomic,strong) UIImageView *iconImagViews;

@property(nonatomic,strong) UILabel *shopName;


@end

@implementation ShopToCollectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self addSubViewControll];
    }
    
    return self;
}

- (void)setShopModel:(ShopFavoritesModel *)shopModel
{
    _shopModel = shopModel;
    
    [self.iconImagViews sd_setImageWithURL:[NSURL URLWithString:shopModel.img]];
    self.shopName.text = shopModel.shop_name;
    
}


- (void)addSubViewControll
{
    UIImageView *iconImage = [[UIImageView alloc] init];
    self.iconImagViews = iconImage;
    iconImage.frame = CGRectMake(10,10,60,60);
    iconImage.layer.cornerRadius = 30;
    iconImage.clipsToBounds = YES;
    [self.contentView addSubview:iconImage];
    

    UILabel *shopName = [[UILabel alloc] init];
    self.shopName = shopName;
    shopName.frame = CGRectMake(iconImage.sh_right + 20,15,100,50);
    shopName.numberOfLines = 0;
    shopName.font = [UIFont systemFontOfSize:13];
    shopName.textColor = [UIColor lightGrayColor];
    shopName.text = @"1432423432423";
    [self.contentView addSubview:shopName];
    
}

@end
