//
//  MyCareerView.m
//  nen
//
//  Created by nenios101 on 2017/3/2.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "MyCareerView.h"

@interface MyCareerView ()
    
@property(nonatomic,strong) NSDictionary *dict;
    
@end

@implementation MyCareerView

 // 营销公司
- (IBAction)marketingBtn:(UIButton *)sender
{
    self.dict = @{@"companyType":@"1"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"myTheMember" object:self userInfo:self.dict];
}
 // 服务公司
- (IBAction)serviceBtn:(UIButton *)sender
{
    self.dict = @{@"companyType":@"2"};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"myTheMember" object:self userInfo:self.dict];
}
// 招商公司
- (IBAction)merchantsBtn:(UIButton *)sender
{
    self.dict = @{@"companyType":@"3"};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"myTheMember" object:self userInfo:self.dict];
}
// 更多
- (IBAction)moreBtn:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"more" object:self];
}
// 我的事业
- (IBAction)MyTheCareerBtn:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"more" object:self];
}

@end
