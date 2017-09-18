//
//  GroupBuyingTableViewCell.m
//  nen
//
//  Created by nenios101 on 2017/5/4.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "GroupBuyingTableViewCell.h"
#import "GroupBuyingModel.h"

@interface GroupBuyingTableViewCell ()
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

//二人团
@property(nonatomic,strong) UIButton *twoPersonGroups;

@end

@implementation GroupBuyingTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self addSubviewControll];
    }
    
    return self;
}



-(void)addSubviewControll
{
    UIView *mainBodyView = [[UIView alloc] init];
    mainBodyView.frame = CGRectMake(0,5,ScreenWidth,145);
    mainBodyView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:mainBodyView];
    
    UIImageView *iconImag = [[UIImageView alloc] init];
    self.iconImageView = iconImag;
    iconImag.frame = CGRectMake(10,15,100,125);
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
    shopTitle.frame = CGRectMake(ScreenWidth - 150,commentTitle.sh_y,140,20);
    shopTitle.text = @"店铺666";
    shopTitle.textAlignment = NSTextAlignmentRight;
    shopTitle.font = [UIFont systemFontOfSize:12];
    shopTitle.textColor = [UIColor blackColor];
    [mainBodyView addSubview:shopTitle];
    
    
    UILabel * discountPriceTitle = [[UILabel alloc] init];
    self.discountPricesTitle = discountPriceTitle;
    discountPriceTitle.frame = CGRectMake(commentTitle.sh_x,commentTitle.sh_bottom,60,20);
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
    freightTitle.frame = CGRectMake(ScreenWidth - 120,soldItemTitle.sh_y,60,20);
    freightTitle.text = @"不含运费";
    freightTitle.font = [UIFont systemFontOfSize:12];
    [mainBodyView addSubview:freightTitle];
    
    UILabel *cityTitle = [[UILabel alloc] init];
    self.citysTitle = cityTitle;
    cityTitle.frame = CGRectMake(freightTitle.sh_right +10,freightTitle.sh_y,50,20);
    cityTitle.text = @"城市";
    cityTitle.font = [UIFont systemFontOfSize:12];
    [mainBodyView addSubview:cityTitle];
    
    
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.frame = CGRectMake(centerTitle.sh_right + 10,cityTitle.sh_bottom,60,25);
    [buyBtn setTitle:@"去开团" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    buyBtn.layer.borderColor = [UIColor redColor].CGColor;
    buyBtn.layer.borderWidth = 1.0f;
    buyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
  //  [buyBtn addTarget:self action:@selector(buyBtn) forControlEvents:UIControlEventTouchUpInside];
    [mainBodyView addSubview:buyBtn];
    
    
    UIButton *twoPersonGroup = [UIButton buttonWithType:UIButtonTypeCustom];
    self.twoPersonGroups = twoPersonGroup;
    twoPersonGroup.frame = CGRectMake((buyBtn.sh_x - buyBtn.sh_width),buyBtn.sh_y,60,25);
    
    [twoPersonGroup setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  //  [twoPersonGroup addTarget:self action:@selector(twoPersonGroupBtn) forControlEvents:UIControlEventTouchUpInside];
    [twoPersonGroup setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    twoPersonGroup.layer.borderColor = [UIColor redColor].CGColor;
    twoPersonGroup.layer.borderWidth = 1.0f;
    twoPersonGroup.titleLabel.font = [UIFont systemFontOfSize:13];
    [mainBodyView addSubview:twoPersonGroup];
    

}

//#pragma mark 去开团
//-(void)buyBtn
//{
//    NSDictionary *dict = @{@"groupGoodsId":self.model.id,@"page":@"1"};
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushShopVc" object:self userInfo:dict];
//    
//}
//
//#pragma mark 二人团
//- (void)twoPersonGroupBtn
//{
//    NSDictionary *dict = @{@"groupGoodsId":self.model.id,@"page":@"0"};
//    
//   [[NSNotificationCenter defaultCenter] postNotificationName:@"pushShopVc" object:self userInfo:dict];
//}

#pragma mark 分享按钮
-(void)shareBtnClick:(UIButton *)btn
{
    NSDictionary *dict = @{@"goodsName":self.model.goods_name,@"shopName":self.model.shop_name,@"shareStr":self.model.share_url,@"iconImage":self.model.goods_img};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shareBtns" object:self userInfo:dict];
    
    
}



- (void)setModel:(GroupBuyingModel *)model
{
    _model = model;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.goods_img]];
    self.headlineTitle.text = model.goods_name;
    self.commentTitles.text = [NSString stringWithFormat:@"%@条评论",model.comment_count];
    self.discountPricesTitle.text = [NSString stringWithFormat:@"¥%@",model.group_price];
    NSDictionary *attributeStr = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    self.originalPricesTitle.attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@",model.primeval_price]attributes:attributeStr];
    self.storeTitle.text = model.shop_name;
    self.soldTitle.text = [NSString stringWithFormat:@"已售%@",model.sale_num];
    self.citysTitle.text = model.delivesress;
    
    self.freightsTitle.text = [NSString stringWithFormat:@"运费%@",model.carriage];
    [self.twoPersonGroups setTitle:model.group_num forState:UIControlStateNormal];
    
}


@end
