
//
//  GroupOrderView.m
//  nen
//
//  Created by nenios101 on 2017/5/9.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "GroupOrderView.h"
#import "OrderModel.h"

@interface GroupOrderView()<UITextFieldDelegate>
//  图片
@property (strong, nonatomic)  UIImageView *goodsImage;
// 商品名称
@property (strong, nonatomic) UILabel *goodsTitle;
// 价格
@property (strong, nonatomic)  UILabel *priceTitle;
// 头部个数
@property (strong, nonatomic)  UILabel *count;

// 数量个数
@property (strong, nonatomic)  UITextField *itemCount;
@property (strong, nonatomic)  UILabel *returnBottomLabel;

@property(strong,nonatomic) UIButton *minBtn;

@property(strong,nonatomic) UIButton *addBtn;


@property(nonatomic,assign) CGFloat sumPrice;

@property(nonatomic,strong) UIView *controllViews;

@property(nonatomic,assign) CGFloat textFieldLength;

@end


@implementation GroupOrderView


- (void)setModel:(OrderModel *)model
{
    _model = model;
    
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:model.goods_img]];
    self.priceTitle.text = [NSString stringWithFormat:@"¥%@",model.price];
    self.goodsTitle.text = model.goods_name;
    self.count.text = [NSString stringWithFormat:@"X%@",model.num];
    self.itemCount.text = [NSString stringWithFormat:@"%@",model.num];
    
    self.sumPrice = [model.price doubleValue];
    
}



- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self addSoncontroll];
    }
    return self;
}



-(void)addSoncontroll
{
    
    UIView *controllView = [[UIView alloc] init];
    self.controllViews = controllView;
    [self addSubview:controllView];
    controllView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    self.goodsImage = iconImageView;
    iconImageView.frame = CGRectMake(15,15,110,90);
    iconImageView.image = [UIImage imageNamed:@"3"];
    [controllView addSubview:iconImageView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    self.goodsTitle = titleLabel;
    titleLabel.frame  =CGRectMake(iconImageView.sh_right + 15,0,ScreenWidth - 150,80);
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"djshfjsdhfjsdhhgdsjkhfjshfjshjkhfkjdffdsffdsfdfdgfdgfhwrgw";
    titleLabel.font = [UIFont systemFontOfSize:13];
    [controllView addSubview:titleLabel];
    
    UILabel *piceTitle = [[UILabel alloc] init];
    self.priceTitle = piceTitle;
    piceTitle.frame  =CGRectMake(iconImageView.sh_right + 15,titleLabel.sh_bottom,60,20);
    piceTitle.text = @"¥345";
    piceTitle.font = [UIFont systemFontOfSize:13];
    piceTitle.textColor = [UIColor orangeColor];
    [controllView addSubview:piceTitle];
    
    UILabel *countTitle = [[UILabel alloc] init];
    countTitle.textColor = [UIColor orangeColor];
    self.count = countTitle;
    countTitle.frame  =CGRectMake(piceTitle.sh_right + 30,titleLabel.sh_bottom,60,20);
    countTitle.text = @"X1";
    countTitle.font = [UIFont systemFontOfSize:13];
    [controllView addSubview:countTitle];
    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.frame = CGRectMake(0,countTitle.sh_bottom  + 30,ScreenWidth,1);
    [controllView addSubview:lineView];
    
    UILabel *promotionTitle = [[UILabel alloc] init];
    promotionTitle.frame  =CGRectMake(15,lineView.sh_bottom + 15  ,60,20);
    promotionTitle.text = @"促销优惠";
    promotionTitle.textColor = [UIColor blackColor];
    promotionTitle.font = [UIFont systemFontOfSize:13];
    [controllView addSubview:promotionTitle];
    
    UILabel *buyTitle = [[UILabel alloc] init];
    buyTitle.frame = CGRectMake(15,promotionTitle.sh_bottom + 15,80,20);
    buyTitle.font = [UIFont systemFontOfSize:13];
    buyTitle.text = @"购买数量";
    [controllView addSubview:buyTitle];
    
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addBtn = addBtn;
    addBtn.frame = CGRectMake(ScreenWidth - 35, buyTitle.sh_y,20, 20);
  [addBtn setBackgroundImage:[UIImage imageNamed:@"cart_addBtn_nomal"] forState:UIControlStateNormal];
    [addBtn addTarget:self  action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:addBtn];
    
    UITextField *countTextField = [[UITextField alloc] init];
    countTextField.delegate = self;
    [countTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    countTextField.textAlignment = NSTextAlignmentCenter;
    countTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.itemCount = countTextField;
    countTextField.frame = CGRectMake(ScreenWidth - 65,addBtn.sh_y,30,20);
    countTextField.text = @"1";
    [self addSubview:countTextField];
    
    UIButton *minBtn = [[UIButton alloc] init];
    self.minBtn = minBtn;
    minBtn.frame = CGRectMake(ScreenWidth - 85, buyTitle.sh_y,20, 20);
    [minBtn setBackgroundImage:[UIImage imageNamed:@"cart_cutBtn_nomal"] forState:UIControlStateNormal];
    [minBtn addTarget:self action:@selector(minBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    minBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:minBtn];
    
    UILabel *aftermarketTitle = [[UILabel alloc] init];
    aftermarketTitle.frame  =CGRectMake( 15,buyTitle.sh_bottom + 15,60,20);
    aftermarketTitle.text = @"售后服务";
    aftermarketTitle.textColor = [UIColor blackColor];
    aftermarketTitle.font = [UIFont systemFontOfSize:13];
    [controllView addSubview:aftermarketTitle];
    
    UILabel *nationwideTitle = [[UILabel alloc] init];
    nationwideTitle.frame  =CGRectMake(minBtn.sh_x,buyTitle.sh_bottom + 15,80,20);
    nationwideTitle.text = @"全国联保>";
    nationwideTitle.textColor = [UIColor blackColor];
    nationwideTitle.font = [UIFont systemFontOfSize:13];
    [controllView addSubview:nationwideTitle];
    
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.frame = CGRectMake(0,aftermarketTitle.sh_bottom + 15,ScreenWidth,1);
    lineView2.backgroundColor = [UIColor lightGrayColor];
    [controllView addSubview:lineView2];
    
    UILabel *distributionTitle = [[UILabel alloc] init];
    distributionTitle.frame  =CGRectMake(15,lineView2.sh_bottom + 15,60,20);
    distributionTitle.text = @"配送方式";
    distributionTitle.textColor = [UIColor blackColor];
    distributionTitle.font = [UIFont systemFontOfSize:13];
    [controllView addSubview:distributionTitle];
    
    
    
    UILabel *expresLabel = [[UILabel alloc] init];
    expresLabel.frame = CGRectMake(nationwideTitle.sh_x,distributionTitle.sh_y,80, 20);
    expresLabel.text = @"快递 免邮>";
    expresLabel.textColor = [UIColor blackColor];
    expresLabel.font = [UIFont systemFontOfSize:13];
    [controllView addSubview:expresLabel];
    
    UILabel *bottomLabel = [[UILabel alloc] init];
    self.returnBottomLabel = bottomLabel;
    bottomLabel.frame = CGRectMake(15,distributionTitle.sh_bottom + 15,ScreenWidth - 30,20);
    bottomLabel.font = [UIFont systemFontOfSize:11];
    bottomLabel.text = @"卖家赠送,若确认收货前退货可获得保险呢赔付运险费";
    [controllView addSubview:bottomLabel];
    
    
    controllView.sh_height = bottomLabel.sh_bottom + 5;
    controllView.sh_width = ScreenWidth;
    controllView.sh_y = 0;
    controllView.sh_x = 0;
    
    self.frame = controllView.frame;

    
    
}


#pragma mark 数量减少按钮
- (void)minBtnClick:(UIButton *)sender
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
        
        
        NSDictionary *minDict;
        
        if (self.textFieldLength >= 1)
        {
            minDict = @{@"price":@(self.sumPrice),@"textFieldLenght":@(self.textFieldLength)};
            
            self.textFieldLength = 0;
        }else
        {
            minDict = @{@"price":@(self.sumPrice)};
            
           // NSLog(@"%@",minDict);
        }

        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"min" object:self userInfo:minDict];
        
    }
    
    
}

#pragma mark 增加数量按钮
- (void)addBtnClick:(UIButton *)sender {
    
    NSInteger num = [self.itemCount.text integerValue];
    self.itemCount.text = [NSString stringWithFormat:@"%d",num + 1];
    self.count.text = [NSString stringWithFormat:@"X%d",num + 1];
    
      // NSString *price = [NSString stringWithFormat:@"¥%.2f",self.sumPrice  * (num + 1)];
        // NSString *item = [NSString stringWithFormat:@"%f",self.textFieldLength];
    
    //NSLog(@"%f",self.textFieldLength);
    
    NSDictionary *maxDict;
    
    if (self.textFieldLength >= 1)
    {
        maxDict = @{@"price":@(self.sumPrice),@"textFieldLenght":@(self.textFieldLength)};
        
        self.textFieldLength = 0;
    }else
    {
        maxDict = @{@"price":@(self.sumPrice)};
        
      //  NSLog(@"%@",maxDict);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"max" object:self userInfo:maxDict];

}




#pragma mark  textFiled Delegate

// 开始编辑
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"textFieldBegin" object:self];
}

// 结束编辑
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"textFieldEnd" object:self];
    
}

// 监听textField 输入
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length <= 0)
    {
        textField.text = @"1";
    }
    
    self.textFieldLength = [textField.text doubleValue];
    
}



// 翻回最底部控件高度
- (CGFloat)returnHeight
{
    return self.controllViews.sh_bottom;
}


 - (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.itemCount resignFirstResponder];
}




@end
