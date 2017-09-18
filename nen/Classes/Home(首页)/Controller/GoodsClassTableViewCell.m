//
//  GoodsClassTableViewCell.m
//  nen
//
//  Created by nenios101 on 2017/4/28.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "GoodsClassTableViewCell.h"
#import "ShopItemModel.h"

@interface GoodsClassTableViewCell ()

@property(nonatomic,strong) UILabel *leftLabel;

@property(nonatomic,strong) UIView *mainViews;

@property(nonatomic,strong) UIButton *rightBtns;

@end


@implementation GoodsClassTableViewCell

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
    CGFloat W = (ScreenWidth - 60) / totalColumns;
    CGFloat H = 80;
    CGFloat X = (self.frame.size.width - totalColumns * W) / (totalColumns + 1);
    
    for (int index = 0; index <shopItmeArray.count ; index++)
    {
        UIView * goodsView = [[UIView alloc] init];
//        int row = index / totalColumns;
        int col = index % totalColumns;
        CGFloat viewX = X + col * (W + X);
        // CGFloat viewY = 5 + row * (H + Y);
        
        goodsView.frame = CGRectMake(viewX,self.leftLabel.sh_bottom + 5,W,H);
        goodsView.backgroundColor = [UIColor oldLace];
        [self.mainViews addSubview:goodsView];
        
       UIImageView *goodsImage = [[UIImageView alloc] init];
        
        NSLog(@"%@",shopItmeArray[index].goods_img);
        
      [goodsImage sd_setImageWithURL:[NSURL URLWithString:shopItmeArray[index].goods_img]];
       
       goodsImage.image = [UIImage imageNamed:@"1"];
        goodsImage.frame =CGRectMake(10,5,W - 20,40);
        
        [goodsView addSubview:goodsImage];
        
        UILabel  *goodsTextLabel = [[UILabel alloc] init];
        goodsTextLabel.frame = CGRectMake(5,goodsImage.sh_bottom,goodsView.sh_width,20);
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
        
        
        UILabel *bottomRightLabel = [[UILabel alloc] init];
        bottomTitleLabel.font = [UIFont systemFontOfSize:8];
        bottomTitleLabel.frame = CGRectMake(bottomTitleLabel.sh_right,goodsTextLabel.sh_bottom,goodsView.sh_width,20);
        bottomTitleLabel.textColor = [UIColor lightGrayColor];
        
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
       bottomTitleLabel.attributedText = [[NSMutableAttributedString alloc]initWithString:shopItmeArray[index].primeval_price attributes:attribtDic];
        [goodsView addSubview:bottomRightLabel];
        
        UIButton *viewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        viewBtn.frame = CGRectMake(0,0,goodsView.sh_width,goodsView.sh_height);
        [viewBtn addTarget:self action:@selector(viewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        viewBtn.tag = [shopItmeArray[index].goods_id integerValue];
        
        [goodsView addSubview:viewBtn];
        
    }

    

}

- (void)viewBtnClick:(UIButton *)btn
{
    NSLog(@"%d",btn.tag);
}



- (void)addSubviewControll
{
    UIView  *mainView = [[UIView alloc] init];
    self.mainViews = mainView;
    mainView.backgroundColor = [UIColor orangeRed];
    mainView.frame = CGRectMake(0,0,self.contentView.sh_width,115);
    [self.contentView addSubview:mainView];
    
    UIView *leftView = [[UIView alloc] init];
    leftView.backgroundColor = [UIColor orangeColor];
    leftView.frame = CGRectMake(0, 5,10,25);
    [mainView addSubview:leftView];
   
   UILabel *leftTitleLabel = [[UILabel alloc] init];
    self.leftLabel = leftTitleLabel;
    leftTitleLabel.frame = CGRectMake(leftView.sh_right + 5,leftView.sh_x + 5,80,25);
    leftTitleLabel.textColor = [UIColor orangeColor];
    leftTitleLabel.font = [UIFont systemFontOfSize:12];
    [mainView addSubview:leftTitleLabel];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtns = rightBtn;
    rightBtn.frame = CGRectMake(self.sh_width - 80,leftView.sh_x + 10,80,25);
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn setTitle:@"查看更多>" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [mainView addSubview:rightBtn];
   
}

- (void)rightBtnClick:(UIButton *)rightBtn
{
    
    NSLog(@"每个cell的ID%d",rightBtn.tag);
}

- (void)setName:(NSString *)name
{
    _name = name;
    
    self.leftLabel.text = name;
    self.rightBtns.tag = self.Id;
    
}

//- (void)setId:(NSInteger)Id
//{
//    _Id = Id;
//    
//    
//}

@end
