//
//  WarehouseCentreCell.m
//  nen
//
//  Created by nenios101 on 2017/6/5.
//  Copyright © 2017年 nen. All rights reserved.
//仓库中

#import "WarehouseCentreCell.h"
#import "CommodityManagementModel.h"



@interface WarehouseCentreCell()

@property(nonatomic,strong) UIImageView *iconImageView;
@property(nonatomic,strong) UILabel *headlineTitle;

@property(nonatomic,strong) UILabel *discountPricesTitle;

@property(nonatomic,strong) UILabel *soldTitle;

@property(nonatomic,strong) UILabel *stockTitle;

@end

@implementation WarehouseCentreCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self addSubviewControll];
    }
    
    return self;
}



- (void)setModel:(CommodityManagementModel *)model
{
    _model = model;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.goods_img]];
    self.headlineTitle.text = model.goods_name;
    self.stockTitle.text = [NSString stringWithFormat:@"库存%@",model.inventory];
    self.soldTitle.text = [NSString stringWithFormat:@"已售%@",model.sale_num];
}

-(void)addSubviewControll
{
    UIView *mainBodyView = [[UIView alloc] init];
    mainBodyView.frame = CGRectMake(0,5,ScreenWidth,145);
    mainBodyView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:mainBodyView];
    
    UIImageView *iconImag = [[UIImageView alloc] init];
    self.iconImageView = iconImag;
    iconImag.frame = CGRectMake(20,30,60,60);
    iconImag.image = [UIImage imageNamed:@"1"];
    [mainBodyView addSubview:iconImag];
    
    UILabel *centerTitle = [[UILabel alloc] init];
    self.headlineTitle = centerTitle;
    centerTitle.frame = CGRectMake(iconImag.sh_right + 20,iconImag.sh_y,150,30);
    centerTitle.text= @"是非得失风格的是非得失公司返回韩国代购还记得个梵蒂冈和返回雕塑返回韩对方的负担国电视剧";
    centerTitle.numberOfLines = 0;
    centerTitle.lineBreakMode = NSLineBreakByWordWrapping;
    centerTitle.font = [UIFont systemFontOfSize:11];
    [mainBodyView addSubview:centerTitle];
    
    UILabel *soldItemTitle = [[UILabel alloc] init];
    self.soldTitle = soldItemTitle;
    soldItemTitle.frame = CGRectMake(centerTitle.sh_x,centerTitle.sh_bottom + 20,50,20);
    soldItemTitle.text = @"已售666";
    soldItemTitle.font = [UIFont systemFontOfSize:12];
    [mainBodyView addSubview:soldItemTitle];
    
    UILabel *stockTitle = [[UILabel alloc] init];
    self.stockTitle = stockTitle;
    stockTitle.frame = CGRectMake(soldItemTitle.sh_right + 10,soldItemTitle.sh_y,45,20);
    stockTitle.text = @"库存";
    stockTitle.font = [UIFont systemFontOfSize:10];
    [mainBodyView addSubview:stockTitle];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.frame = CGRectMake(0,iconImag.sh_bottom + 20,ScreenWidth, 1);
    bottomView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:bottomView];
    
    CGFloat W = (ScreenWidth - 2) / 3;
    
    
    UIButton *putawayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    putawayBtn.frame = CGRectMake(0,bottomView.sh_bottom,W,40);
    [putawayBtn addTarget:self action:@selector(putawayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [putawayBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [putawayBtn setTitle:@"上架" forState:UIControlStateNormal];
    putawayBtn.titleLabel.font  = [UIFont systemFontOfSize:13];
    putawayBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:putawayBtn];
    
    UIView *centreLine = [[UIView alloc] init];
    centreLine.frame = CGRectMake(putawayBtn.sh_right,putawayBtn.sh_y + 5,1,30);
    centreLine.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:centreLine];
    
//    
//    UIButton *editorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    editorBtn.frame = CGRectMake(centreLine.sh_right,bottomView.sh_bottom,W,40);
//    [editorBtn addTarget:self action:@selector(editorBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [editorBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    [editorBtn setTitle:@"编辑" forState:UIControlStateNormal];
//    editorBtn.titleLabel.font  = [UIFont systemFontOfSize:13];
//    editorBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [self.contentView addSubview:editorBtn];
//    
//    UIView *twoCentreLine = [[UIView alloc] init];
//    twoCentreLine.frame = CGRectMake(editorBtn.sh_right,putawayBtn.sh_y + 5,1,30);
//    twoCentreLine.backgroundColor = [UIColor lightGrayColor];
//    [self.contentView addSubview:twoCentreLine];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(centreLine.sh_right,bottomView.sh_bottom,W,40);
    [shareBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(sahrBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    shareBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:shareBtn];
    
    
    UIView *thereCentreLine = [[UIView alloc] init];
    thereCentreLine.frame = CGRectMake(shareBtn.sh_right,putawayBtn.sh_y + 5,1,30);
    thereCentreLine.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:thereCentreLine];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(thereCentreLine.sh_right,bottomView.sh_bottom,W,40);
    [deleteBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    deleteBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:deleteBtn];
    

    UIView *bottomline = [[UIView alloc] init];
    bottomline.frame = CGRectMake(0,149,ScreenWidth,1);
    bottomline.backgroundColor = [UIColor lightGrayColor];
    [mainBodyView addSubview:bottomline];
    
}



// 编辑
-(void)editorBtnClick
{
  
    NSDictionary *dict = @{@"goodsId":self.model.id};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"editorGoods" object:self userInfo:dict];

}

// 分享
- (void)sahrBtnClick
{
    NSDictionary *dict = @{@"goodsModel":self.model};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"upFrameShare" object:self userInfo:dict];

}

// 上架
- (void)putawayBtnClick
{
    
    NSDictionary *dict = @{@"goodsId":self.model.id};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"upFrame" object:self userInfo:dict];
    
}

// 删除
- (void)deleteBtnClick
{
    NSDictionary *dict = @{@"goodsId":self.model.id};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"delete" object:self userInfo:dict];
}

@end
