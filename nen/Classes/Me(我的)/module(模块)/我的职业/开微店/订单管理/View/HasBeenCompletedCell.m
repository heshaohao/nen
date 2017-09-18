//
//  HasBeenCompletedCell.m
//  nen
//
//  Created by nenios101 on 2017/6/9.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "HasBeenCompletedCell.h"
#import "MerchantsOrdersModel.h"
#import "ShoppingForDetailsModel.h"

@interface HasBeenCompletedCell ()

@property(nonatomic,strong) UIImageView *iconImageView;
@property(nonatomic,strong) UILabel *headlineTitle;
@property(nonatomic,strong) UILabel *buyrightTitle;
@property(nonatomic,strong) UILabel *orderStatetitle;
@property(nonatomic,strong) UILabel *sumTitle;
@property(nonatomic,strong) UILabel *priceRightTitle;
@property(nonatomic,strong) UILabel *incomeLeftTitle;
@property(nonatomic,strong) UILabel *freightRightTitle;
@property(nonatomic,strong) UILabel *realPayTitle;
@end

@implementation HasBeenCompletedCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self addSubviewControll];
    }
    
    return self;
}


- (void)setShopModel:(ShoppingForDetailsModel *)shopModel
{
    _shopModel = shopModel;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:shopModel.goods_img]];
    self.headlineTitle.text = shopModel.goods_name;
    self.sumTitle.text = [NSString stringWithFormat:@"X%@",shopModel.num];
    
}

- (void)setMecchantsModel:(MerchantsOrdersModel *)mecchantsModel
{
    _mecchantsModel = mecchantsModel;
    self.buyrightTitle.text = mecchantsModel.seller_name;
    self.orderStatetitle.text = mecchantsModel.state_name;
    self.freightRightTitle.text = [NSString stringWithFormat:@"¥%@",mecchantsModel.pay_bank];
    self.realPayTitle.text = [NSString stringWithFormat:@"¥%@",mecchantsModel.delivery_cost];
}

-(void)addSubviewControll
{
    UILabel *buyLeftTitle = [[UILabel alloc] init];
    buyLeftTitle.frame = CGRectMake(10,10,40,25);
    buyLeftTitle.text = @"买家:";
    buyLeftTitle.textColor = [UIColor lightGrayColor];
    buyLeftTitle.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:buyLeftTitle];
    
    UILabel *buyrightTitle = [[UILabel alloc] init];
    self.buyrightTitle = buyrightTitle;
    buyrightTitle.frame = CGRectMake(buyLeftTitle.sh_right + 10,10,100,25);
    buyrightTitle.textColor = [UIColor blackColor];
    buyrightTitle.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:buyrightTitle];
    
    UILabel *orderStatetitle = [[UILabel alloc] init];
    self.orderStatetitle = orderStatetitle;
    orderStatetitle.frame = CGRectMake(ScreenWidth - 90,10,80,25);
    orderStatetitle.textColor = [UIColor orangeColor];
    orderStatetitle.textAlignment = NSTextAlignmentRight;
    orderStatetitle.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:orderStatetitle];
    
    UIImageView *iconImag = [[UIImageView alloc] init];
    self.iconImageView = iconImag;
    iconImag.frame = CGRectMake(10,buyLeftTitle.sh_bottom + 20,80,70);
    iconImag.image = [UIImage imageNamed:@"1"];
    [self.contentView addSubview:iconImag];
    
    UILabel *centerTitle = [[UILabel alloc] init];
    self.headlineTitle = centerTitle;
    centerTitle.frame = CGRectMake(iconImag.sh_right + 20,iconImag.sh_y - 10,150,30);
    centerTitle.text= @"是非得失风格的是非得失公司返回韩国代购还记得个梵蒂冈和返回雕塑返回韩对方的负担国电视剧";
    centerTitle.numberOfLines = 0;
    centerTitle.lineBreakMode = NSLineBreakByWordWrapping;
    centerTitle.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:centerTitle];
    
    UILabel *sumTitle = [[UILabel alloc] init];
    self.sumTitle = sumTitle;
    sumTitle.frame = CGRectMake(centerTitle.sh_x,centerTitle.sh_bottom + 10,50,20);
    sumTitle.font = [UIFont systemFontOfSize:13];
    sumTitle.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:sumTitle];
    
    UILabel *priceLeftTitle = [[UILabel alloc] init];
    priceLeftTitle.frame = CGRectMake(centerTitle.sh_x,sumTitle.sh_bottom,50,25);
    priceLeftTitle.font = [UIFont systemFontOfSize:13];
    priceLeftTitle.text = @"售价:";
    [self.contentView addSubview:priceLeftTitle];
    
    UILabel *priceRightTitle = [[UILabel alloc] init];
    self.priceRightTitle = priceRightTitle;
    priceRightTitle.frame = CGRectMake(priceLeftTitle.sh_right,priceLeftTitle.sh_y,50,25);
    priceRightTitle.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:priceRightTitle];
    
    UILabel *incomeLeftTitle = [[UILabel alloc] init];
    self.incomeLeftTitle = incomeLeftTitle;
    incomeLeftTitle.text = @"收入:";
    incomeLeftTitle.frame = CGRectMake(centerTitle.sh_x,priceRightTitle.sh_bottom,50,25);
    incomeLeftTitle.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:incomeLeftTitle];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.frame = CGRectMake(0,incomeLeftTitle.sh_bottom,ScreenWidth,1);
    bottomView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:bottomView];
    
    
    UILabel *realPayLeftTitle = [[UILabel alloc] init];
    realPayLeftTitle.frame = CGRectMake(10,bottomView.sh_bottom + 5,40,25);
    realPayLeftTitle.text = @"实付:";
    realPayLeftTitle.textColor = [UIColor lightGrayColor];
    realPayLeftTitle.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:realPayLeftTitle];
    
    UILabel *realPayTitle = [[UILabel alloc] init];
    self.realPayTitle = realPayTitle;
    realPayTitle.frame = CGRectMake(realPayLeftTitle.sh_right + 10,realPayLeftTitle.sh_y,100,25);
    realPayTitle.textColor = [UIColor blackColor];
    realPayTitle.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:realPayTitle];
    
    
    UILabel *freightLeftTitle = [[UILabel alloc] init];
    freightLeftTitle.frame = CGRectMake(10,realPayLeftTitle.sh_bottom ,40,25);
    freightLeftTitle.text = @"运费:";
    freightLeftTitle.textColor = [UIColor lightGrayColor];
    freightLeftTitle.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:freightLeftTitle];
    
    UILabel *freightRightTitle = [[UILabel alloc] init];
    self.freightRightTitle = freightRightTitle;
    freightRightTitle.frame = CGRectMake(freightLeftTitle.sh_right + 10,freightLeftTitle.sh_y,100,25);
    freightRightTitle.textColor = [UIColor blackColor];
    freightRightTitle.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:freightRightTitle];
    
    
    UIView *bottomViewOne = [[UIView alloc] init];
    bottomViewOne.frame = CGRectMake(0,freightRightTitle.sh_bottom + 5,ScreenWidth,1);
    bottomViewOne.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:bottomViewOne];
    
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(ScreenWidth - 90,bottomViewOne.sh_bottom + 15,80,23);
    [deleteBtn setTitle:@"删除订单" forState:UIControlStateNormal];
    deleteBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    deleteBtn.layer.cornerRadius = 5;
    [deleteBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    deleteBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    deleteBtn.layer.borderWidth = 2.0f;
    deleteBtn.clipsToBounds = YES;
    [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:deleteBtn];
    
}

// 删除订单按钮
- (void)deleteBtnClick
{
    NSDictionary *dcit = @{@"orderId":self.mecchantsModel.id};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteOrder" object:self userInfo:dcit];

}


@end
