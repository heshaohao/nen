//
//  ShoppingView.m
//  nen
//
//  Created by nenios101 on 2017/3/2.
//  Copyright © 2017年 nen. All rights reserved.
//我的购物单


#import "MyShoppView.h"

@interface MyShoppView ()
@property (weak, nonatomic) IBOutlet UILabel *stayPayLabel;
@property (weak, nonatomic) IBOutlet UILabel *staySendLabel;
@property (weak, nonatomic) IBOutlet UILabel *ReceivingLabel;

@property (weak, nonatomic) IBOutlet UILabel *EvaluateLabel;


@end


@implementation MyShoppView
// 我的购物单
- (IBAction)pushAllOrder:(UIButton *)sender
{
    NSDictionary *dict = @{@"page":@"0"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"allOderVc" object:self userInfo:dict];
}
// 待付款
- (IBAction)payBtn:(UIButton *)sender
{
    NSDictionary *dict = @{@"page":@"1"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"allOderVc" object:self userInfo:dict];
}

// 待收货
- (IBAction)sendOutBtn:(UIButton *)sender
{
    NSDictionary *dict = @{@"page":@"2"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"allOderVc" object:self userInfo:dict];
}


- (void)setStaeCountArray:(NSArray *)staeCountArray
{
    _staeCountArray = staeCountArray;
    
  //  NSLog(@"%@",staeCountArray);
    
    
    [staeCountArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSInteger state = [obj[@"state"] integerValue];
      
       // NSLog(@"%ld",(long)state);
        
        NSInteger state_count = [obj[@"state_count"] integerValue];
        
        switch (state) {
            case 1:
                if (state_count > 0) {
                    
                    self.stayPayLabel.hidden = NO;
                    self.stayPayLabel.text = [NSString stringWithFormat:@"%@",obj[@"state_count"]];
                }
                break;
            case 2:
                if (state_count > 0) {
                    
                    self.staySendLabel.hidden = NO;
                    self.staySendLabel.text = [NSString stringWithFormat:@"%@",obj[@"state_count"]];
                }
                break;
            case 3:
                if (state_count > 0) {
                    
                    self.ReceivingLabel.hidden = NO;
                    self.ReceivingLabel.text = [NSString stringWithFormat:@"%@",obj[@"state_count"]];
                }
                break;
            case 4:
                if (state_count > 0) {
                    
                    self.EvaluateLabel.hidden = NO;
                    self.EvaluateLabel.text = [NSString stringWithFormat:@"%@",obj[@"state_count"]];
                }
                break;
                
            default:
                break;
        }
        
        
    }];
    
    
    
}

// 待发货
- (IBAction)receivingBtn:(UIButton *)sender
{
    NSDictionary *dict = @{@"page":@"3"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"allOderVc" object:self userInfo:dict];
}

// 待评价
- (IBAction)evaluateBtn:(UIButton *)sender
{
    NSDictionary *dict = @{@"page":@"4"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"allOderVc" object:self userInfo:dict];
}
// 退修
- (IBAction)outHughBtn:(UIButton *)sender
{
    NSDictionary *dict = @{@"page":@"5"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"allOderVc" object:self userInfo:dict];
}


@end
