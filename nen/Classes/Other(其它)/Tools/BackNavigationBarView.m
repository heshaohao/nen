//
//  BackNavigationBarView.m
//  nen
//
//  Created by nenios101 on 2017/5/18.
//  Copyright © 2017年 nen. All rights reserved.
// 导航栏

#import "BackNavigationBarView.h"
#import "OrderLabel.h"


@interface BackNavigationBarView()

@property(nonatomic,strong) UILabel *shoppingCarNumLabel;


@end


@implementation BackNavigationBarView

#pragma mark 根据个人需求修改

- (instancetype)initBackNavView
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    NSString *completeStr = [NSString stringEncryptedAddress:@"/order/cartnum"];
    
    
    [manager POST:completeStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
     //  NSLog(@"%@",responseObject);
//        
//        NSLog(@"%@",responseObject[@"obj"][@"num"]);
        
        NSString *coder = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"resultCode"]];
        
        if ([coder isEqualToString:@"0"])
        {
            
            NSString * objStr = [NSString stringWithFormat:@"%@",responseObject[@"obj"]];
            NSString *numStr = [NSString stringWithFormat:@"%@",responseObject[@"obj"][@"num"]];
            
            if ([objStr isEqualToString:@"null"])
            {
                [JKAlert alertText:@"购物车数量-错误码"];
                return;
                
            }
            if ([numStr isEqualToString:@"null"])
            {
                 [JKAlert alertText:@"购物车数量-错误码"];
                return;
                
            }
            _shoppingCarNumLabel.text = numStr;
            
        }
        
//
//        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
     //   NSLog(@"%@",error);
        
    }];
    
    BackNavigationBarView *navView = [[BackNavigationBarView alloc] init];
    navView.frame = CGRectMake(0,0, ScreenWidth,64);
    navView.backgroundColor = [UIColor clearColor];
    [self addSubview:navView];
    
    UIButton *leftBuyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBuyBtn setBackgroundImage:[UIImage imageNamed:@"GOUWUCHE"] forState:UIControlStateNormal];
    [leftBuyBtn addTarget:self action:@selector(buyShoppingCar) forControlEvents:UIControlEventTouchUpInside];
    leftBuyBtn.sh_height = 30;
    leftBuyBtn.sh_width = 30;
    leftBuyBtn.sh_x = 5;
    leftBuyBtn.sh_y = 5;
    [navView addSubview:leftBuyBtn];
    
    _shoppingCarNumLabel= [[UILabel alloc] init];
    
    _shoppingCarNumLabel.frame = CGRectMake(leftBuyBtn.sh_right - 5,leftBuyBtn.sh_y -5,15,15);
    _shoppingCarNumLabel.layer.borderColor = [UIColor redColor].CGColor;
    _shoppingCarNumLabel.backgroundColor = [UIColor redColor];
    _shoppingCarNumLabel.layer.borderWidth = 1.0f;
    _shoppingCarNumLabel.layer.cornerRadius = 7.5;
    _shoppingCarNumLabel.layer.masksToBounds = YES;
    _shoppingCarNumLabel.textAlignment = NSTextAlignmentCenter;
    _shoppingCarNumLabel.font = [UIFont systemFontOfSize:12];
    _shoppingCarNumLabel.textColor = [UIColor whiteColor];
    [navView addSubview:_shoppingCarNumLabel];
    
    
    UIView *searView = [[UIView alloc] init];
    searView.frame = CGRectMake(leftBuyBtn.sh_right + 15, 5,ScreenWidth *0.7,30);
    searView.backgroundColor = [UIColor whiteColor];
    searView.layer.cornerRadius  = 5;
    searView.clipsToBounds = YES;
    
    UIImageView *iconIameView =[[UIImageView alloc] init];
    iconIameView.frame = CGRectMake(0,0,30,30);
    iconIameView.image = [UIImage imageNamed:@"searchIcon"];
    [searView addSubview:iconIameView];
    
  //  NSLog(@"%f",iconIameView.sh_width);
    
    UITapGestureRecognizer *searTap = [[UITapGestureRecognizer alloc] initWithTarget:navView action:@selector(searViewClcik:)];
    [searView addGestureRecognizer:searTap];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(iconIameView.sh_right,5,searView.sh_width * 0.25,20);
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = @"网一网";
    titleLabel.textColor = [UIColor colorWithRed:229.0/255.0 green:89.0/255.0 blue:29.0/255.0 alpha:0.8];
    [searView addSubview:titleLabel];
    
    UILabel *paratextLabel = [[UILabel alloc] init];
    paratextLabel.frame = CGRectMake(titleLabel.sh_right + 5,5,searView.sh_width * 0.45,20);
    paratextLabel.font = [UIFont systemFontOfSize:15];
    paratextLabel.text = @"搜商品";
    paratextLabel.textColor = [UIColor lightGrayColor];
    [searView addSubview:paratextLabel];
    
    
    [navView addSubview:searView];
    
    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageBtn setBackgroundImage:[UIImage imageNamed:@"messageIcon"] forState:UIControlStateNormal];
    [messageBtn addTarget:self action:@selector(messagePush) forControlEvents:UIControlEventTouchUpInside];
    [messageBtn sizeToFit];
    messageBtn.sh_height = 25;
    messageBtn.sh_width = 25;
    messageBtn.sh_x = searView.sh_right + 15;
    messageBtn.sh_y = 10;
    [navView addSubview:messageBtn];
    
    //
    //    UIButton *addressBookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [addressBookBtn setBackgroundImage:[UIImage imageNamed:@"plusSign"] forState:UIControlStateNormal];
    //    addressBookBtn.sh_height = 40;
    //    addressBookBtn.sh_width = 40;
    //    addressBookBtn.sh_x = messageBtn.sh_right + 5;
    //    addressBookBtn.sh_y = 0;
    //    [navView addSubview:addressBookBtn];
    
    return navView;

}

// 消息推送
- (void)messagePush
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"messagePushVc" object:self];
}
// 购物车
- (void)buyShoppingCar
{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"pushGoodsShoppingCarVc" object:self];
}

- (void)searViewClcik:(UITapGestureRecognizer *)tap
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushSearchVc" object:self];
}



#pragma mark ------------------------ 初始化 -------------------------------

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


- (void)setFrame:(CGRect)frame {
    // 如果不写这句 添加到导航控制器上 两端有空隙
    [super setFrame:CGRectMake(0, 0, self.superview.bounds.size.width, self.superview.bounds.size.height)];
}









@end
