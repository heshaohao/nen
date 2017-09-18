//
//  LoginAndRegisterTextFiled.m
//  nen
//
//  Created by nenios101 on 2017/7/5.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "LoginAndRegisterTextFiled.h"

@implementation LoginAndRegisterTextFiled


- (instancetype)initWhitImageStr:(NSString *)imageStr
{
    LoginAndRegisterTextFiled *textFiled = [[LoginAndRegisterTextFiled alloc] init];
    UIView *leftView = [[UIView alloc] init];
    leftView.frame = CGRectMake(0,0,50,40);
    textFiled.leftView = leftView;
    textFiled.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *leftImag = [[UIImageView alloc] init];
    leftImag.image = [UIImage imageNamed:imageStr];
    leftImag.frame = CGRectMake(10, 5,30,30);
    
    
    [leftView addSubview:leftImag];
    
    return textFiled;
}

@end
