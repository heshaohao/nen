//
//  ClassificationOptionsView.m
//  nen
//
//  Created by nenios101 on 2017/4/19.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "ClassificationOptionsView.h"


@interface ClassificationOptionsView()
@property (weak, nonatomic) IBOutlet UILabel *winingLabel;

// 开店
@property (weak, nonatomic) IBOutlet UIView *openAShopBtn;
// 顾问
@property (weak, nonatomic) IBOutlet UIView *consultantView;
// 驾校
@property (weak, nonatomic) IBOutlet UIView *drivingView;
// 师傅
@property (weak, nonatomic) IBOutlet UIView *masterView;
// 营销
@property (weak, nonatomic) IBOutlet UIView *marketingView;
// 服务
@property (weak, nonatomic) IBOutlet UIView *serviceView;
// 引进
@property (weak, nonatomic) IBOutlet UIView *importView;
// 招商
@property (weak, nonatomic) IBOutlet UIView *brandView;
// 中奖
@property (weak, nonatomic) IBOutlet UIView *winningView;
// 全额
@property (weak, nonatomic) IBOutlet UIView *fullView;

@property(nonatomic,strong) NSDictionary *dict;

@end

@implementation ClassificationOptionsView


- (void)awakeFromNib
{
   [super awakeFromNib];
   
    // 开店
    UITapGestureRecognizer *shopTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shopClick)];
    [self.openAShopBtn addGestureRecognizer:shopTap];
    
    // 营销
    UITapGestureRecognizer *marketingTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(marketingClick)];
    
    [self.marketingView addGestureRecognizer:marketingTap];
    // 招商
    UITapGestureRecognizer *brandTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(brandClick)];
    
    [self.brandView addGestureRecognizer:brandTap];
    
    // 中奖
    UITapGestureRecognizer *winningTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(winningClick)];
    [self.winningView addGestureRecognizer:winningTap];
    
//    
//    UITapGestureRecognizer *consultantTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(consultantClick)];
//
//    [self.consultantView addGestureRecognizer:consultantTap];
//
//    UITapGestureRecognizer *drivingTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(drivingClick)];
//
//    [self.drivingView addGestureRecognizer:drivingTap];
//
//    UITapGestureRecognizer *masterTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(masterClick)];
//
//    [self.masterView addGestureRecognizer:masterTap];
    
//    UITapGestureRecognizer *serviceViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(serviceViewClick)];
//
//    [self.serviceView addGestureRecognizer:serviceViewTap];
//
//    UITapGestureRecognizer *importTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(importClick)];
//
  //  [self.importView addGestureRecognizer:importTap];
    
    
//    UITapGestureRecognizer *fullTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullClick)];
//    
//    [self.fullView addGestureRecognizer:fullTap];
    
}


- (void)setStr:(NSString *)Str
{
    _Str = Str;
    
    self.winingLabel.text = Str;
}

- (void)shopClick
{
    self.dict = @{@"title":@"开店收入",@"type":@"4"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"incomeVc" object:self userInfo:self.dict];
}

- (void)consultantClick
{
    self.dict = @{@"title":@"顾问收入",@"type":@"0"};
   
    [[NSNotificationCenter defaultCenter] postNotificationName:@"incomeVc" object:self userInfo:self.dict];

}

//- (void)drivingClick
//{
//    self.dict = @{@"title":@"驾校收入",@"type":@"7"};
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"incomeVc" object:self userInfo:self.dict];
//
//    
//    
//}
//
//- (void)masterClick
//{
//    self.dict = @{@"title":@"师傅收入",@"type":@"0"};
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"incomeVc" object:self userInfo:self.dict];
//
//}

- (void)marketingClick
{
    self.dict = @{@"title":@"营销公司收入",@"type":@"4"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"incomeVc" object:self userInfo:self.dict];
}

//- (void)serviceViewClick
//{
//    self.dict = @{@"title":@"服务公司收入",@"type":@"0"};
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"incomeVc" object:self userInfo:self.dict];
//
//}

//- (void)importClick
//{
//    self.dict = @{@"title":@"引进公司收入",@"type":@"5"};
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"incomeVc" object:self userInfo:self.dict];
//}

- (void)brandClick
{
    self.dict = @{@"title":@"招商收入",@"type":@"0"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"incomeVc" object:self userInfo:self.dict];

}

- (void)winningClick
{
    self.dict = @{@"title":@"中奖收入",@"type":@"1"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"incomeVc" object:self userInfo:self.dict];
;
}

//- (void)fullClick
//{
//    self.dict = @{@"title":@"全额收入",@"type":@"3"};
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"incomeVc" object:self userInfo:self.dict];
//}


@end
