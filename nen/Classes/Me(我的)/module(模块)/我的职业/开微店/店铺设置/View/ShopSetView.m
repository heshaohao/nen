//
//  ShopSetView.m
//  nen
//
//  Created by nenios101 on 2017/3/10.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "ShopSetView.h"

@interface ShopSetView ()

@property (weak, nonatomic) IBOutlet ShopSetView *nearView;

@end

@implementation ShopSetView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UISwitch *nameSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(ScreenWidth *0.8, 0, 30, 20)];
    nameSwitch.on = YES;
    nameSwitch.transform = CGAffineTransformMakeScale(0.6, 0.6); //改变大小的关键代码
    [_nearView addSubview:nameSwitch];
    
}


@end
