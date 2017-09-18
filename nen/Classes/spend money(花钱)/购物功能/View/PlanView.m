//
//  PlanView.m
//  nen
//
//  Created by nenios101 on 2017/3/6.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "PlanView.h"
#import "GoodsProductModel.h"
#import "MarketingModel.h"
#import "GroupBuyingItemGoodsItemModel.h"
@interface PlanView ()
// 商品图片
@property (weak, nonatomic) IBOutlet UIImageView *goods_img;
// 商品名称
@property (weak, nonatomic) IBOutlet UILabel *goods_name;
// 价格
@property (weak, nonatomic) IBOutlet UILabel *priceTitle;
// 销量
@property (weak, nonatomic) IBOutlet UILabel *sale_num;
// 评论
@property (weak, nonatomic) IBOutlet UILabel *comment_count;
// 运费
@property (weak, nonatomic) IBOutlet UILabel *carriage;
// 商家名称
@property (weak, nonatomic) IBOutlet UILabel *shop_name;

 // 分享按钮
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
// 立即购买按钮
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
// 全额返回
@property (weak, nonatomic) IBOutlet UIButton *fullRetrunBtn;

@property (weak, nonatomic) IBOutlet UIView *bottomLine;
// 原价格
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLabel;
// 发货
@property (weak, nonatomic) IBOutlet UILabel *delivery;

@end

@implementation PlanView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.buyBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.buyBtn.layer.borderWidth = 1.f;
    
    self.shareBtn.layer.borderWidth = 1.f;
    self.shareBtn.layer.borderColor = [UIColor redColor].CGColor;
    
}


- (void)setProductModel:(GoodsProductModel *)productModel
{
    _productModel = productModel;
    
    if (productModel != nil)
    {
        self.goods_name.text = productModel.goods_name;
        [self.goods_img sd_setImageWithURL:[NSURL URLWithString:productModel.goods_img] placeholderImage:nil];
        self.sale_num.text = [NSString stringWithFormat:@"已售%@",productModel.sale_num];
        self.comment_count.text = [NSString stringWithFormat:@"%@条评论",productModel.comment_count];
        self.carriage.text = [NSString stringWithFormat:@"运费:%@",productModel.carriage];
        self.shop_name.text = [NSString stringWithFormat:@"%@",productModel.shop_name];
        self.priceTitle.text = [NSString stringWithFormat:@"%@",productModel.price];
        
        self.originalPriceLabel.text = [NSString stringWithFormat:@"%@",productModel.primeval_price];
        self.delivery.text = productModel.delivesress;
        
    }else
    {
        self.goods_name.text = @"该商品已下架";
        self.shareBtn.hidden = YES;
        self.goods_img.image = [UIImage imageNamed:@"placeholderImage"];
        self.buyBtn.hidden = YES;
    }
    
    
    
}

- (void)setGroupModel:(GroupBuyingItemGoodsItemModel *)groupModel{
    _groupModel = groupModel;
    
    if (groupModel !=nil)
    {
        self.goods_name.text = groupModel.goods_name;
        [self.goods_img sd_setImageWithURL:[NSURL URLWithString:groupModel.goods_all_img[@"img1"]] placeholderImage:nil];
        self.sale_num.text = [NSString stringWithFormat:@"已售%@",groupModel.sale_num];
        self.comment_count.text = [NSString stringWithFormat:@"%@条评论",groupModel.comment_count];
        self.carriage.text = [NSString stringWithFormat:@"运费:%@",groupModel.carriage];
        self.shop_name.text = [NSString stringWithFormat:@"%@",groupModel.shop_name];
        self.priceTitle.text = [NSString stringWithFormat:@"%@",groupModel.price];
        self.originalPriceLabel.text = [NSString stringWithFormat:@"%@",groupModel.primeval_price];
        self.delivery.text = groupModel.delivesress;
        
    }else
    {
        self.goods_name.text = @"该商品已下架";
        self.shareBtn.hidden = YES;
        self.goods_img.image = [UIImage imageNamed:@"placeholderImage"];
        self.buyBtn.hidden = YES;
    }
    
    
    
}

-(CGFloat)returnPlanViewHeght
{
    return _bottomLine.sh_bottom;
}

- (IBAction)buyBtnClick:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"buy" object:self userInfo:nil];
}

- (IBAction)shareBtnclick:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"planShare" object:self userInfo:nil];
}

@end
