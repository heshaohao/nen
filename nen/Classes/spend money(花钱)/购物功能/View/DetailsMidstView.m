
//
//  DetailsMidstView.m
//  nen
//
//  Created by nenios101 on 2017/3/7.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "DetailsMidstView.h"
#import "GoodsProductModel.h"
@interface DetailsMidstView ()
// 最高返回
@property (weak, nonatomic) IBOutlet UILabel *limitTheHighestTitle;
// 最低返回
@property (weak, nonatomic) IBOutlet UILabel *theLowestAmount;
// 返回金额
@property (weak, nonatomic) IBOutlet UILabel *fullPrice;
@property (weak, nonatomic) IBOutlet UILabel *activityTime;

@property (weak, nonatomic) IBOutlet UIView *leftView;

@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UILabel *benefitLabel;


@end


@implementation DetailsMidstView

- (void)setModel:(GoodsProductModel *)model
{
    _model = model;
    
    NSString *promotionStr = [NSString stringWithFormat:@"%@",model.is_promotion];
    
    NSString *theActivityTime = [NSString stringWithFormat:@"活动时间 : %@ 至 %@",model.start_time,model.end_time];
   
    if ([promotionStr isEqualToString:@"1"])
    {
        self.benefitLabel.text = @"让利促销活动开始啦!";
        
        self.activityTime.text = theActivityTime;
        
    }else
    {
        self.benefitLabel.text = @"促销活动结束啦! 下次早点来哦";
        
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:theActivityTime attributes:attribtDic];
        
        self.activityTime.attributedText = attribtStr;
    }
    
    
    self.limitTheHighestTitle.text = [NSString stringWithFormat:@"* 中奖额度最高 : %@",model.price];
    
    CGFloat lowesPrice = ([model.price doubleValue] / 10);
    
    self.theLowestAmount.text = [NSString stringWithFormat:@"* 中奖额度最低 : %.2f",lowesPrice];
    
    self.fullPrice.text = [NSString stringWithFormat:@"* 返回金额 : %@",model.price];
    
    

}



- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    _leftView.layer.borderWidth = 1;
//    _leftView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    
//    _rightView.layer.borderWidth = 1;
//    _rightView.layer.borderColor = [UIColor lightGrayColor].CGColor;

}

@end
