//
//  SmallHeadView.m
//  nen
//
//  Created by nenios101 on 2017/3/9.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "SmallHeadView.h"
#import "ShopmanageModel.h"
@interface SmallHeadView ()

@property (weak, nonatomic) IBOutlet UILabel *shopTitle;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayOrder;

@end

@implementation SmallHeadView


- (void)setModel:(ShopmanageModel *)model
{
    _model = model;
    
    self.shopTitle.text = model.shop_name;
    self.iconImage.layer.cornerRadius = 30;
    self.iconImage.clipsToBounds = YES;
    if (model.shop_logo.length > 0)
    {
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.shop_logo]];
        
    }else
    {
        self.iconImage.image = [UIImage imageNamed:@"2"];
    }
    
    self.sumLabel.text = [NSString stringWithFormat:@"¥%@",model.today_deal];
    self.dayOrder.text = [NSString stringWithFormat:@"%@",model.today_order];
    
}





@end
