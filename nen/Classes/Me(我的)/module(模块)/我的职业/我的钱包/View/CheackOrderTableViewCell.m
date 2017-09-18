//
//  CheackOrderTableViewCell.m
//  nen
//
//  Created by apple on 17/4/23.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "CheackOrderTableViewCell.h"
#import "CheckOrderModel.h"
@interface  CheackOrderTableViewCell ()

// 标题
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
// 时间
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
// 金额
@property (weak, nonatomic) IBOutlet UILabel *moneyLable;

@end

@implementation CheackOrderTableViewCell


- (void)setModel:(CheckOrderModel *)model
{
    _model = model;
    
    self.titleLable.text = model.reason;
    
    self.timeLable.text = model.create_time;
    
    self.moneyLable.text = [NSString stringWithFormat:@"+%@",model.money];
}

@end
