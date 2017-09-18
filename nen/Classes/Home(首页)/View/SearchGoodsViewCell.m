//
//  SearchGoodsViewCell.m
//  nen
//
//  Created by nenios101 on 2017/5/18.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "SearchGoodsViewCell.h"
#import "ShopGoodsListModel.h"


@interface SearchGoodsViewCell ()
// 商品图片
@property(nonatomic,strong) UIImageView *iconImageView;
// 标题
@property(nonatomic,strong) UILabel *headlineTitle;
// 评论
@property(nonatomic,strong) UILabel *commentTitles;
// 折后价
@property(nonatomic,strong) UILabel *discountPricesTitle;
// 原价
@property(nonatomic,strong) UILabel *originalPricesTitle;
// 店铺
@property(nonatomic,strong) UILabel *storeTitle;
// 已售数额
@property(nonatomic,strong) UILabel *soldTitle;
// 运费
@property(nonatomic,strong) UILabel *freightsTitle;
// 城市
@property(nonatomic,strong) UILabel *citysTitle;

@end

@implementation SearchGoodsViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        [self addsubViewControll];
    }
    
    return self;
    
}

- (void)addsubViewControll
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
    centerTitle.frame = CGRectMake(iconImag.sh_right + 10,10,ScreenWidth - 200,35);
    centerTitle.text= @"是非得失风格的是非得失公司返回韩国代购还记得个梵蒂冈和返回雕塑返回韩对方的负担国电视剧";
    centerTitle.numberOfLines = 0;
    centerTitle.font = [UIFont systemFontOfSize:13];
    [mainBodyView addSubview:centerTitle];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(centerTitle.sh_right + 10,iconImag.sh_y,60,25);
    [shareBtn setTitle:@"分享推广" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.layer.borderColor = [UIColor redColor].CGColor;
    shareBtn.layer.borderWidth = 1.0f;
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [mainBodyView addSubview:shareBtn];
    
    UILabel *commentTitle = [[UILabel alloc] init];
    self.commentTitles = commentTitle;
    commentTitle.frame = CGRectMake(centerTitle.sh_x,centerTitle.sh_bottom,120,20);
    commentTitle.text = @"100条评论";
    commentTitle.font = [UIFont systemFontOfSize:12];
    commentTitle.textColor = [UIColor lightGrayColor];
    [mainBodyView addSubview:commentTitle];
    
    UILabel *shopTitle = [[UILabel alloc] init];
    self.storeTitle = shopTitle;
    shopTitle.frame = CGRectMake(commentTitle.sh_right,commentTitle.sh_y,ScreenWidth - 240,20);
    shopTitle.text = @"店铺666";
    shopTitle.textAlignment = NSTextAlignmentRight;
    shopTitle.font = [UIFont systemFontOfSize:11];
    shopTitle.textColor = [UIColor blackColor];
    [mainBodyView addSubview:shopTitle];
    
    
    UILabel * discountPriceTitle = [[UILabel alloc] init];
    self.discountPricesTitle = discountPriceTitle;
    discountPriceTitle.frame = CGRectMake(commentTitle.sh_x,commentTitle.sh_bottom,80,20);
    discountPriceTitle.text = @"¥6.00";
    discountPriceTitle.font = [UIFont systemFontOfSize:14];
    discountPriceTitle.textColor = [UIColor redColor];
    [mainBodyView addSubview:discountPriceTitle];
    
    
    UILabel * originalPriceTitle = [[UILabel alloc] init];
    self.originalPricesTitle = originalPriceTitle;
    originalPriceTitle.frame = CGRectMake(discountPriceTitle.sh_right + 10 ,commentTitle.sh_bottom,commentTitle.sh_width,20);
    originalPriceTitle.text = @"¥6.00";
    originalPriceTitle.font = [UIFont systemFontOfSize:13];
    originalPriceTitle.textColor = [UIColor lightGrayColor];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    originalPriceTitle.attributedText = [[NSAttributedString alloc] initWithString:@"¥12" attributes:attribtDic];
    
    [mainBodyView addSubview:originalPriceTitle];
    
    
    UILabel *soldItemTitle = [[UILabel alloc] init];
    self.soldTitle = soldItemTitle;
    soldItemTitle.frame = CGRectMake(commentTitle.sh_x,originalPriceTitle.sh_bottom,50,20);
    soldItemTitle.text = @"已售666";
    soldItemTitle.font = [UIFont systemFontOfSize:12];
    [mainBodyView addSubview:soldItemTitle];
    
    UILabel *freightTitle = [[UILabel alloc] init];
    self.freightsTitle = freightTitle;
    freightTitle.frame = CGRectMake(shareBtn.sh_x - 5,soldItemTitle.sh_y,45,20);
    freightTitle.text = @"不含运费";
    freightTitle.font = [UIFont systemFontOfSize:10];
    [mainBodyView addSubview:freightTitle];
    
    UILabel *cityTitle = [[UILabel alloc] init];
    self.citysTitle = cityTitle;
    cityTitle.frame = CGRectMake(freightTitle.sh_right,freightTitle.sh_bottom - (freightTitle.sh_height *0.5),30,20);
    cityTitle.text = @"城市";
    cityTitle.font = [UIFont systemFontOfSize:10];
    [mainBodyView addSubview:cityTitle];
    
    
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.frame = CGRectMake(ScreenWidth - 70,cityTitle.sh_bottom,60,25);
    [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    buyBtn.layer.borderColor = [UIColor redColor].CGColor;
    buyBtn.layer.borderWidth = 1.0f;
    buyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [buyBtn addTarget:self action:@selector(buyBtn) forControlEvents:UIControlEventTouchUpInside];
    [mainBodyView addSubview:buyBtn];
    
//    
//    UIButton *fullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    fullBtn.frame = CGRectMake(ScreenWidth - 145,buyBtn.sh_y,60,25);
//    [fullBtn setTitle:@"全额返现" forState:UIControlStateNormal];
//    [fullBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [fullBtn addTarget:self action:@selector(fullBtn) forControlEvents:UIControlEventTouchUpInside];
//    [fullBtn setBackgroundColor:[UIColor redColor]];
//    fullBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//    [mainBodyView addSubview:fullBtn];
    
    
}

#pragma mark 全额返现按钮
- (void)fullBtn
{
    NSDictionary *dict = @{@"goodsId":self.model.id};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushShopVcs" object:self userInfo:dict];
}



#pragma mark 立即购买按钮
- (void)buyBtn
{
    NSDictionary *dict = @{@"goodsId":self.model.id};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushBuyVcs" object:self userInfo:dict];
}



#pragma mark 分享按钮
-(void)shareBtnClick:(UIButton *)btn
{
    NSDictionary *dict = @{@"goodsName":self.model.goods_name,@"shopName":self.model.shop_name,@"shareStr":self.model.share_url,@"iconImage":self.model.goods_img};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shareBtns" object:self userInfo:dict];
    
    
}





- (void)setModel:(ShopGoodsListModel *)model
{
    _model = model;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.goods_img]];
    
   // NSLog(@"%@",model.goods_name);
    
    self.headlineTitle.text = model.goods_name;
    self.commentTitles.text = [NSString stringWithFormat:@"%@条评论",model.comment_count];
    self.storeTitle.text = model.shop_name;
    self.discountPricesTitle.text = [NSString stringWithFormat:@"¥%@",model.price];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    self.originalPricesTitle.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",model.primeval_price] attributes:attribtDic];
    
    self.freightsTitle.text = model.carriage.length >=1 ? @"含运费" : @"不含运费";
    self.citysTitle.text = model.delivesress;
    self.soldTitle.text = [NSString stringWithFormat:@"已售%@",model.sale_num];
    
}

@end
