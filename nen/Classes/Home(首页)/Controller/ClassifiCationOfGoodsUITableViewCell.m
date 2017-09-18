//
//  ClassifiCationOfGoodsUITableViewCell.m
//  nen
//
//  Created by nenios101 on 2017/5/2.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "ClassifiCationOfGoodsUITableViewCell.h"
#import "ShopItemModel.h"

@interface ClassifiCationOfGoodsUITableViewCell ()

@property(nonatomic,strong) UILabel *leftLabel;

@property(nonatomic,strong) UIView *mainViews;

@property(nonatomic,strong) UIButton *rightBtns;

@property(nonatomic,strong) UILabel *LifteBottomTitle;

@property(nonatomic,strong) UILabel *rightBottomRightTitle;

@end


@implementation ClassifiCationOfGoodsUITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self addSubviewControll];
        
    }
    return self;
}


- (void)setShopItmeArray:(NSMutableArray<ShopItemModel *> *)shopItmeArray
{
    _shopItmeArray = shopItmeArray;
    
    
    int totalColumns = 3;
    CGFloat W = (ScreenWidth - 20) / totalColumns;
    CGFloat H = 133;
    CGFloat X = (ScreenWidth - totalColumns * W) / (totalColumns + 1);
    
    for (int index = 0; index <shopItmeArray.count ; index++)
    {
        UIView * goodsView = [[UIView alloc] init];
        //        int row = index / totalColumns;
        int col = index % totalColumns;
        CGFloat viewX = X + col * (W + X);
        // CGFloat viewY = 5 + row * (H + Y);
        
        goodsView.frame = CGRectMake(viewX,self.leftLabel.sh_bottom + 5,W,H);
        [self.mainViews addSubview:goodsView];
        
        UIImageView *goodsImage = [[UIImageView alloc] init];
        
        
        [goodsImage sd_setImageWithURL:[NSURL URLWithString:shopItmeArray[index].goods_img]];
        goodsImage.frame =CGRectMake(10,5,W - 20,93);
        
        [goodsView addSubview:goodsImage];
        
        UILabel  *goodsTextLabel = [[UILabel alloc] init];
        goodsTextLabel.frame = CGRectMake(5,goodsImage.sh_bottom,goodsView.sh_width,20);
        goodsTextLabel.textAlignment = NSTextAlignmentCenter;
        goodsTextLabel.font = [UIFont systemFontOfSize:12];
        goodsTextLabel.textColor = [UIColor lightGrayColor];
        
        goodsTextLabel.text = [NSString stringWithFormat:@"%@",shopItmeArray[index].goods_name];
        [goodsView addSubview:goodsTextLabel];
        
        
        UILabel * bottomTitleLabel = [[UILabel alloc] init];
        bottomTitleLabel.frame = CGRectMake(0,goodsTextLabel.sh_bottom,goodsView.sh_width *0.5,20);
        bottomTitleLabel.font = [UIFont systemFontOfSize:12];
        bottomTitleLabel.textColor = [UIColor redColor];
        bottomTitleLabel.text = [NSString stringWithFormat:@"¥%@",shopItmeArray[index].price];
        [goodsView addSubview:bottomTitleLabel];
        
        
        UILabel *rightBottomLabel = [[UILabel alloc] init];
        rightBottomLabel.frame = CGRectMake(bottomTitleLabel.sh_right,goodsTextLabel.sh_bottom,goodsTextLabel.sh_width *0.5,20);
        rightBottomLabel.textColor = [UIColor lightGrayColor];
        rightBottomLabel.font = [UIFont systemFontOfSize:10];
        [goodsView addSubview:rightBottomLabel];
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        rightBottomLabel.attributedText = [[NSMutableAttributedString alloc]initWithString:shopItmeArray[index].primeval_price attributes:attribtDic];
     
        
        UIButton *viewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        viewBtn.frame = CGRectMake(0,0,goodsView.sh_width,goodsView.sh_height);
        [viewBtn addTarget:self action:@selector(viewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        viewBtn.tag = [shopItmeArray[index].goods_id integerValue];
        
        [goodsView addSubview:viewBtn];
        
    }
    
    
    
}

- (void)viewBtnClick:(UIButton *)btn
{
    
    NSDictionary *dict = @{@"goodsId":[NSString stringWithFormat:@"%ld",(long)btn.tag]};
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"pushDetailsVc" object:self userInfo:dict];
}



- (void)addSubviewControll
{
    UIView  *mainView = [[UIView alloc] init];
    self.mainViews = mainView;
    mainView.frame = CGRectMake(0,0,ScreenWidth,178);
    mainView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:mainView];
    
    UIView *leftView = [[UIView alloc] init];
    leftView.frame = CGRectMake(0, 5,10,25);
    leftView.backgroundColor = [UIColor orangeColor];
    [mainView addSubview:leftView];
    
    UILabel *leftTitleLabel = [[UILabel alloc] init];
    self.leftLabel = leftTitleLabel;
    leftTitleLabel.frame = CGRectMake(leftView.sh_right + 5,leftView.sh_x + 5,80,25);
    leftTitleLabel.textColor = [UIColor orangeColor];
    leftTitleLabel.font = [UIFont systemFontOfSize:12];
    [mainView addSubview:leftTitleLabel];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtns = rightBtn;
    rightBtn.frame = CGRectMake(ScreenWidth - 80,leftView.sh_x + 10,80,25);
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn setTitle:@"查看更多" forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"moreIcon"] forState:UIControlStateNormal];
    
    // 按钮文字和图片位置互换
    CGFloat imgWidth = rightBtn.imageView.sh_width;
    CGFloat labWidth = rightBtn.titleLabel.sh_width;
    rightBtn.imageView.frame = CGRectMake(0,0,15,10);
    
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, labWidth , 0, -labWidth)];
    [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgWidth, 0, imgWidth)];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [mainView addSubview:rightBtn];
    
}

- (void)rightBtnClick:(UIButton *)rightBtn
{
    
    NSDictionary *dict = @{@"moreId":[NSString stringWithFormat:@"%ld",(long)rightBtn.tag],@"moreName":self.leftLabel.text};
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"pushMoreVc" object:self userInfo:dict];
}

- (void)setName:(NSString *)name
{
    _name = name;
    
    self.leftLabel.text = name;
    self.rightBtns.tag = self.Id;
    
}



@end
