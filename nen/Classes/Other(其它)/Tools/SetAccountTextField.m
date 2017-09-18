//
//  SetAccountTextField.m
//  nen
//
//  Created by nenios101 on 2017/6/26.
//  Copyright © 2017年 nen. All rights reserved.
//设置个人中心账户

#import "SetAccountTextField.h"

@implementation SetAccountTextField

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        UIView *leftView = [[UIView alloc] init];
        leftView.frame = CGRectMake(0,0,5,25);
        self.leftView = leftView;
        self.leftViewMode = UITextFieldViewModeAlways;
        
    }
    return self;
}

@end
