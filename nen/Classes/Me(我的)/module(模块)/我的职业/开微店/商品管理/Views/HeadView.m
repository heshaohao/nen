//
//  HeadView.m
//  nen
//
//  Created by nenios101 on 2017/3/10.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "HeadView.h"

@interface HeadView ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *shopName;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation HeadView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.iconImageView.layer.cornerRadius = 30;
    self.iconImageView.clipsToBounds = YES;
}


- (void)setShopDict:(NSDictionary *)shopDict
{
    _shopDict = shopDict;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:shopDict[@"shop_logo"]]];
    self.shopName.text = shopDict[@"shop_name"];
}

@end
