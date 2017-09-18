//
//  RecommendCell.m
//  LZCartViewController
//
//  Created by apple on 17/3/15.
//  Copyright © 2017年 Artup. All rights reserved.
//

#import "RecommendCell.h"
#import "RecommendationModel.h"

@interface RecommendCell ()
@property (weak, nonatomic) IBOutlet UIImageView *foodImage;

@property (weak, nonatomic) IBOutlet UILabel *goodsLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation RecommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


- (void)setModel:(RecommendationModel *)model
{
    _model = model;
    
    [self.foodImage sd_setImageWithURL:[NSURL URLWithString:model.goods_img]];
    self.goodsLabel.text = model.goods_name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
    
}


@end
