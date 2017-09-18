//
//  DetailsBottomView.m
//  nen
//
//  Created by nenios101 on 2017/3/7.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "DetailsBottomView.h"
#import "GoodsProductModel.h"
@interface DetailsBottomView()

@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;

@property (nonatomic,copy) NSString *phoneNmuber;

@end

@implementation DetailsBottomView


- (void)setGoodsModel:(GoodsProductModel *)goodsModel
{
    _goodsModel = goodsModel;
    
    NSString *collectionStr = [NSString stringWithFormat:@"%@",goodsModel.is_collect];
    
    self.phoneNmuber = goodsModel.customer_mobile;
    
    if ([collectionStr isEqualToString:@"0"])
    {
        self.collectionBtn.selected = YES;
    }
    
}

// 客服
- (IBAction)CustomerServicebtn:(UIButton *)sender
{
    NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
    NSString *recordStr = [defaluts objectForKey:@"is_login"];
    
    
    if ([recordStr isEqualToString:@"1"])
    {
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.phoneNmuber];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self addSubview:callWebview];

        
    }else
    {
        HDAlertView *alertView = [HDAlertView alertViewWithTitle:@"需要登录后" andMessage:nil];
        [alertView addButtonWithTitle:@"登录" type:HDAlertViewButtonTypeDefault handler:^(HDAlertView *alertView) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"pushloginVc" object:self];
            
        }];
        
        [alertView addButtonWithTitle:@"取消" type:HDAlertViewButtonTypeDefault handler:^(HDAlertView *alertView) {
            
        }];
        
        [alertView show];
        
    }

}

// 立即购买
- (IBAction)btnClick:(UIButton *)sender
{

   [[NSNotificationCenter defaultCenter] postNotificationName:@"modalView" object:self userInfo:nil];

    
}

// 加入购物车
- (IBAction)shoppingCarBtn:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shoppingCar" object:self userInfo:nil];

}

// 查看店铺
- (IBAction)shopBtn:(UIButton *)sender
{
    NSDictionary *dict = @{@"shopId":self.goodsModel.shop_id};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goodsDetailsPushShopVc" object:self userInfo:dict];
}



// 商品收藏
- (IBAction)collectionBtn:(UIButton *)sender
{
    
    NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
    NSString *recordStr = [defaluts objectForKey:@"is_login"];
    
    if ([recordStr isEqualToString:@"1"])
    {
        
        // 请求地址
        NSString *splitCompleteStr = @"";
        
        if (sender.isSelected == 1)
        {
            self.collectionBtn.selected = NO;
            
            [JKAlert alertText:@"已取消收藏"];
            splitCompleteStr = [NSString stringEncryptedAddress:@"/collect/cancelgoods"];
            
        }else if (sender.isSelected == 0)
        {
            
            self.collectionBtn.selected = YES;
            [JKAlert alertText:@"已加入收藏"];
            
            splitCompleteStr = [NSString stringEncryptedAddress:@"/collect/collectgoods"];
            
        }
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
        
        NSInteger  colletId = [self.goodsModel.id integerValue];
        
        NSDictionary *dict = @{@"collect_id":@(colletId)};
        
        [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
            
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            // NSLog(@"%@",error);
            
        }];

    }
    else
    {
        HDAlertView *alertView = [HDAlertView alertViewWithTitle:@"需要登录后" andMessage:nil];
        [alertView addButtonWithTitle:@"登录" type:HDAlertViewButtonTypeDefault handler:^(HDAlertView *alertView) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"pushloginVc" object:self];
            
        }];
        
        [alertView addButtonWithTitle:@"取消" type:HDAlertViewButtonTypeDefault handler:^(HDAlertView *alertView) {
            
        }];
        
        [alertView show];
        
    }
    
}

@end
