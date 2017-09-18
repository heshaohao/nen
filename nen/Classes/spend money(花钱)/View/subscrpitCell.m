//
//  subscrpitCell.m
//  nen
//
//  Created by nenios101 on 2017/3/1.
//  Copyright © 2017年 nen. All rights reserved.
//认购区Cell

#import "subscrpitCell.h"
#import "GoodsModel.h"

@interface subscrpitCell ()
// 图片
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
// 商品标题
@property (weak, nonatomic) IBOutlet UILabel *goodsTitle;
// 分享推广
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
// 评论
@property (weak, nonatomic) IBOutlet UILabel *comment;
// 商家名称
@property (weak, nonatomic) IBOutlet UILabel *shop_name;
// 价格
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
// 销量
@property (weak, nonatomic) IBOutlet UILabel *sale_num;
// 运费
@property (weak, nonatomic) IBOutlet UILabel *carriage;
// 全额返现
@property (weak, nonatomic) IBOutlet UIButton *is_promotion;
// 营销方案
@property (weak, nonatomic) IBOutlet UILabel *adTitle;

// 分享商品url
@property(nonatomic,copy) NSString *shaerUrl;

@property(nonatomic,copy) NSString *shaerImage;

@property (weak, nonatomic) IBOutlet UIButton *buyItNowBtn;

@property(nonatomic,copy) NSString *goodsId;

// 原价价格
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *city;

@end

@implementation subscrpitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.shareBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.shareBtn.layer.borderWidth = 1.0f;
    
    self.buyItNowBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.buyItNowBtn.layer.borderWidth = 1.0f;
}


- (void)setGoodsModel:(GoodsModel *)goodsModel
{
    _goodsModel = goodsModel;
    
    NSURL *url = [NSURL URLWithString:goodsModel.goods_img];
    [self.goodsImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    self.shaerImage = goodsModel.goods_img;
    self.goodsTitle.text = goodsModel.goods_name;
    self.sale_num.text = [NSString stringWithFormat:@"已售%@",goodsModel.sale_num];
    self.comment.text = [NSString stringWithFormat:@"%@条评论",goodsModel.comment_count];
    self.shop_name.text = goodsModel.shop_name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",goodsModel.price];
    self.carriage.text = [NSString stringWithFormat:@"运费%@",goodsModel.carriage];
    //self.is_promotion.hidden = [self.goodsModel.is_promotion isEqualToString:@"1"] ? YES : NO;
    self.adTitle.text = goodsModel.ad;
    self.shaerUrl = goodsModel.share_url;
    self.goodsId = goodsModel.id;
    self.originalPriceLabel.text = [NSString stringWithFormat:@"¥%@",goodsModel.primeval_price];
    
   // NSLog(@"%@",goodsModel.address);
    self.city.text = goodsModel.delivesress;
    
    
}

- (IBAction)shaerBtn:(UIButton *)sender
{
    NSDictionary *dcit = @{@"shareUrl":self.shaerUrl,@"shareName":self.shop_name.text,@"shareImage":self.shaerImage,@"shareGoods":self.goodsTitle.text};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"share" object:self userInfo:dcit];
}

- (IBAction)buyBtnClick:(UIButton *)sender
{
 
    NSDictionary *dict = @{@"goodsId":self.goodsId};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"buyBtn" object:self userInfo:dict];
}
- (IBAction)fullReturnBtn:(UIButton *)sender
{
    NSDictionary *dict = @{@"goodsId":self.goodsId};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"fullReturn" object:self userInfo:dict];

}




@end
