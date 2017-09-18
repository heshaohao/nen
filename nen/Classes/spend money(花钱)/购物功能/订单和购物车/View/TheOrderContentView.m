//
//  TheOrderContentView.m
//  nen
//
//  Created by nenios101 on 2017/3/7.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "TheOrderContentView.h"
#import "OrderModel.h"
@interface TheOrderContentView()

//  图片
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
// 商品名称
@property (weak, nonatomic) IBOutlet UILabel *goodsTitle;
// 价格
@property (weak, nonatomic) IBOutlet UILabel *priceTitle;
// 个数
@property (weak, nonatomic) IBOutlet UILabel *count;
// 左边View
@property (weak, nonatomic) IBOutlet UIView *leftView;
// 右边View
@property (weak, nonatomic) IBOutlet UIView *rightView;
// 中奖消费
@property (weak, nonatomic) IBOutlet UIButton *theWinningbtn;
// 全额返
@property (weak, nonatomic) IBOutlet UIButton *fullBtn;
// 个数
@property (weak, nonatomic) IBOutlet UILabel *itemCount;

@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

// 最高返还
@property (weak, nonatomic) IBOutlet UILabel *theHighestTitle;
// 最低返还
@property (weak, nonatomic) IBOutlet UILabel *lowestTitle;
// 全额
@property (weak, nonatomic) IBOutlet UILabel *fullTitle;
//// 个数
//@property(nonatomic,assign) CGFloat priceNum;
// 单价
@property(nonatomic,assign) CGFloat sumPrice;

@end

@implementation TheOrderContentView


- (void)setModel:(OrderModel *)model
{
    _model = model;

    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:model.goods_img] placeholderImage:nil];
    self.priceTitle.text = [NSString stringWithFormat:@"¥%@",model.price];
    self.goodsTitle.text = model.goods_name;
    self.count.text = [NSString stringWithFormat:@"X%@",model.num];
    self.theHighestTitle.text = [NSString stringWithFormat:@"* 中奖额度最高%.2f",[model.price doubleValue]];
    self.lowestTitle.text = [NSString stringWithFormat:@"* 中奖额度最低%.2f",[model.price doubleValue] / 10];
    self.itemCount.text = [NSString stringWithFormat:@"%@",model.num];
    self.sumPrice = [model.price doubleValue];
    
}

-(void)awakeFromNib
{
    [super awakeFromNib];
//    self.leftView.layer.borderWidth = 1;
//    self.leftView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.rightView.layer.borderWidth = 1;
//    self.rightView.layer.borderColor = [UIColor lightGrayColor].CGColor;
   
}

- (IBAction)thewinningClickBtn:(UIButton *)sender {
    
    if (!sender.selected)
    {
        self.theWinningbtn.selected = YES;
        self.fullBtn.selected = NO;
        NSDictionary *dict = @{@"options":@"1"};
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"options" object:self userInfo:dict];
    }
}
- (IBAction)fullClickBtn:(UIButton *)sender
{
    if (!sender.selected)
    {
        self.fullBtn.selected = YES;
        self.theWinningbtn.selected = NO;
      
        NSDictionary *dict = @{@"options":@"2"};
       
        [[NSNotificationCenter defaultCenter] postNotificationName:@"options" object:self userInfo:dict];
    }
}


- (IBAction)minBtnClick:(UIButton *)sender
{
    if ([self.itemCount.text integerValue] <= 1) {
        
        return;
        
    }else
    {
        NSInteger num = [self.itemCount.text integerValue];
        self.itemCount.text = [NSString stringWithFormat:@"%d",num - 1];
        self.count.text = [NSString stringWithFormat:@"X%d",num - 1];
//        NSString *item = [NSString stringWithFormat:@"%d",num - 1];
//        NSString *price = [NSString stringWithFormat:@"¥%.2f", self.sumPrice * (num - 1)];
        
        NSDictionary *minDict = @{@"price":@(self.sumPrice)};
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"min" object:self userInfo:minDict];
        
    }

    
}
- (IBAction)addBtnClick:(UIButton *)sender {
    
    NSInteger num = [self.itemCount.text integerValue];
    self.itemCount.text = [NSString stringWithFormat:@"%d",num + 1];
    self.count.text = [NSString stringWithFormat:@"X%d",num + 1];
    
//    NSString *price = [NSString stringWithFormat:@"¥%.2f",self.sumPrice  * (num + 1)];
//    NSString *item = [NSString stringWithFormat:@"%d",num + 1];

    NSDictionary *maxDict = @{@"price":@(self.sumPrice)};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"max" object:self userInfo:maxDict];
}

- (CGFloat )returnHeight
{
   return  _bottomLabel.sh_bottom + 15;
}

@end
