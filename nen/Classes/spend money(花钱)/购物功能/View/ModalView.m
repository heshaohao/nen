//
//  ModalView.m
//  nen
//
//  Created by nenios101 on 2017/3/7.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "ModalView.h"
#import "GoodsProductModel.h"
#import "GroupBuyingItemGoodsItemModel.h"
@interface ModalView ()
// 关闭按钮
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
// 商品图片
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
// 价格
@property (weak, nonatomic) IBOutlet UILabel *price;
// 减少
@property (weak, nonatomic) IBOutlet UIButton *miniBtn;
// 数量
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
// 加
@property (weak, nonatomic) IBOutlet UIButton *maxBtn;
// 一年
@property (weak, nonatomic) IBOutlet UIButton *oneYearBtn;
// 两年
@property (weak, nonatomic) IBOutlet UIButton *twoYearBtn;
// 确定
@property (weak, nonatomic) IBOutlet UIButton *determine;

// 单价
@property(nonatomic,assign) CGFloat priceNum;
// 总价
@property(nonatomic,assign) CGFloat sumPrice;
// 库存
@property (weak, nonatomic) IBOutlet UILabel *stockLabel;



@end

@implementation ModalView
- (IBAction)closeBtn:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"close" object:self];
}
- (IBAction)confirmBtn:(UIButton *)sender
{
    NSDictionary *dict = @{@"count":self.valueLabel.text};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"confirm" object:sender userInfo:dict];
}

// 单个购买数据
- (void)setModel:(GoodsProductModel *)model
{
    _model = model;
    
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:model.goods_img] placeholderImage:nil];
    _price.text = [NSString stringWithFormat:@"¥%@",model.price];
    self.priceNum = [model.price doubleValue];
    self.sumPrice = [model.price doubleValue];
    self.stockLabel.text = [NSString stringWithFormat:@"库存:%@",model.inventory];
}

// 团购数据
- (void)setGroupModel:(GroupBuyingItemGoodsItemModel *)groupModel
{
    _groupModel = groupModel;
  [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:groupModel.goods_all_img[@"img1"]]];
   _price.text = [NSString stringWithFormat:@"¥%@",groupModel.price];
    self.priceNum = [groupModel.price doubleValue];
    self.sumPrice = [groupModel.price doubleValue];
    self.stockLabel.text = [NSString stringWithFormat:@"库存:%@",groupModel.inventory];
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    self.closeBtn.layer.cornerRadius = 10;
    self.closeBtn.clipsToBounds = YES;
    
    
}

- (IBAction)minClickBtn:(UIButton *)sender
{
    if ([self.valueLabel.text integerValue] <= 1) {
        
    return;
        
    }else
    {
        NSInteger num = [self.valueLabel.text integerValue];
        self.valueLabel.text = [NSString stringWithFormat:@"%d",num - 1];
        
        self.price.text = [NSString stringWithFormat:@"¥%.2f",self.sumPrice -= self.priceNum];
        
    }
    
}

- (IBAction)maxClickBtn:(UIButton *)sender
{
    NSInteger num = [self.valueLabel.text integerValue];
    self.valueLabel.text = [NSString stringWithFormat:@"%d",num + 1];
  
    
    self.price.text = [NSString stringWithFormat:@"¥%.2f",self.sumPrice += self.priceNum];
    
}

- (IBAction)oneBtnClick:(UIButton *)sender
{
    if (!sender.selected)
    {
        self.oneYearBtn.selected = YES;
        self.twoYearBtn.selected = NO;
        
    }else
    {
        sender.selected = NO;
    }
}


- (IBAction)twoBtnClick:(UIButton *)sender
{
    if (!sender.selected)
    {
        self.twoYearBtn.selected = YES;
        self.oneYearBtn.selected = NO;
        
    }else
    {
        sender.selected = NO;
    }


}


@end
