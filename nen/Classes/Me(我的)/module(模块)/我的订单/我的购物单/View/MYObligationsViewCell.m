//
//  MYObligationsViewCell.m
//  nen
//
//  Created by nenios101 on 2017/5/25.
//  Copyright © 2017年 nen. All rights reserved.
//待付款

#import "MYObligationsViewCell.h"
#import "AllOrderModel.h"
#import "AllOrderOtherModel.h"

@interface MYObligationsViewCell ()

@property(nonatomic,strong) UIView *topView;

@property(nonatomic,strong) UILabel *leftLabel;

@property(nonatomic,strong) UILabel *rightLabel;

@property(nonatomic,strong) UILabel *centerLabel;

@property(nonatomic,strong) UILabel *priceLabel;

@property(nonatomic,strong) UIButton *PaymentBtn;

@property(nonatomic,strong) UIButton *logisticsBtn;


@property(nonatomic,strong) UIImageView *goodsImage;

@end

@implementation MYObligationsViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self addChild];
    }
    return self;
}

- (void)setModel:(AllOrderModel *)model
{
    _model = model;
    
    self.leftLabel.text = model.shop_name;
    self.rightLabel.text =model.state_name;
    NSInteger state = [model.state integerValue];
    
    
    switch (state){
        case 1:
            [self.PaymentBtn setTitle:@"去付款" forState:UIControlStateNormal];
            [self.logisticsBtn setTitle:@"删除" forState:UIControlStateNormal];
            break;
            
            default:
            break;
    }
    
    
    
}

- (void)setOtherModel:(AllOrderOtherModel *)otherModel
{
    _otherModel = otherModel;
    
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:otherModel.goods_img] placeholderImage:nil];
    self.centerLabel.text = otherModel.goods_name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",otherModel.price];
}

- (void)addChild
{
    UIView *topview = [[UIView alloc] init];
    self.topView = topview;
    topview.frame = CGRectMake(0,0,ScreenWidth,10);
    topview.backgroundColor =[UIColor colorWithHexString:@"#F0F0F0"];
    [self.contentView addSubview:topview];
    
    UILabel *left = [[UILabel alloc] init];
    self.leftLabel = left;
    left.frame = CGRectMake(10,topview.sh_bottom,200,20);
    left.font = [UIFont systemFontOfSize:13];
    left.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:left];
    
    UILabel *right = [[UILabel alloc] init];
    right.textAlignment = NSTextAlignmentRight;
    self.rightLabel = right;
    right.textColor = [UIColor orangeColor];
    right.frame = CGRectMake(ScreenWidth - 65,topview.sh_bottom,60,20);
    right.font = [UIFont systemFontOfSize:13];
    
    [self.contentView addSubview:right];
    
    UIImageView *GoodsImageView = [[UIImageView alloc] init];
    self.goodsImage = GoodsImageView;
    GoodsImageView.frame = CGRectMake(15,left.sh_bottom + 15,60, 60);
    [self.contentView addSubview:GoodsImageView];
    
    UILabel *centrnLabel = [[UILabel alloc] init];
    self.centerLabel = centrnLabel;
    centrnLabel.numberOfLines = 3;
    centrnLabel.frame = CGRectMake(GoodsImageView.sh_right + 10,GoodsImageView.sh_y,ScreenWidth *0.5,50);
    centrnLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:centrnLabel];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    self.priceLabel = priceLabel;
    priceLabel.font = [UIFont systemFontOfSize:13];
    priceLabel.textColor = [UIColor orangeColor];
    priceLabel.frame = CGRectMake(centrnLabel.sh_right + 10,centrnLabel.sh_y,60,20);
    [self.contentView addSubview:priceLabel];
    
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.PaymentBtn = payBtn;
    [payBtn addTarget:self action:@selector(payBtnClick) forControlEvents:UIControlEventTouchUpInside];
    payBtn.frame = CGRectMake(ScreenWidth - 80,priceLabel.sh_bottom + 50,60,25);
    payBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [payBtn setBackgroundColor:[UIColor orangeColor]];
    [payBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.contentView addSubview:payBtn];
    
    UIButton *logisticsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.logisticsBtn = logisticsBtn;
    [logisticsBtn addTarget:self action:@selector(logisticsBtnClick) forControlEvents:UIControlEventTouchUpInside];
    logisticsBtn.frame = CGRectMake(ScreenWidth - 160,priceLabel.sh_bottom + 50,60,25);
    logisticsBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [logisticsBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    logisticsBtn.layer.borderWidth =0.5;
    logisticsBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.contentView addSubview:logisticsBtn];
    
}

- (void)payBtnClick
{
    
    NSDictionary *dict = @{@"goodsPrice":self.otherModel.price,@"goodsId1":self.otherModel.goods_id,@"goodsId":self.otherModel.id,@"orderId":self.model.Id,@"state":self.model.state};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MyObligRightBtn" object:self userInfo:dict];
}


- (void)logisticsBtnClick
{
    
    NSDictionary *dict = @{@"goodsId":self.otherModel.id,@"state":self.model.state,@"deleteId":self.model.Id};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MyObligLeftBtn" object:self userInfo:dict];
    
    
}
@end
