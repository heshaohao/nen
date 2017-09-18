//
//  ShopSetNameModel.m
//  nen
//
//  Created by nenios101 on 2017/6/6.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "ShopSetNameModel.h"

@implementation ShopSetNameModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    //1. 调用父类方法完成实例化
    self = [super init];
    //2. 判断对象是否存在
    if (self) {
        //3. 通过对象方法,KVC进行对成员属性赋值
        [self setValuesForKeysWithDictionary:dict];
    }
    //4. 返回当前类对象
    return self;
}

+ (instancetype) shopSetGroupWithDict:(NSDictionary *)dict{
    //调用上面自己定义的init初始化方法
    return [[self alloc]initWithDict:dict];
    
}

@end
