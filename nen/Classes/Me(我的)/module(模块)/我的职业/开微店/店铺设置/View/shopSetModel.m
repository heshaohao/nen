//
//  shopSetModel.m
//  nen
//
//  Created by nenios101 on 2017/6/6.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "shopSetModel.h"
#import "ShopSetNameModel.h"

@implementation shopSetModel

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


- (void)setNameArray:(NSArray *)nameArray
{
      _nameArray = nameArray;
    
    //1. 创建可变数组
    NSMutableArray *nmArray = [NSMutableArray array];
    
    //2. 遍历字典数组
    for (NSDictionary *dict in nameArray) {
        //3. 字典转模型
        ShopSetNameModel *car = [ShopSetNameModel shopSetGroupWithDict:dict];
        //4 添加到可变数组中
        [nmArray addObject:car];
    }
    //5. 赋值
    _nameArray = nmArray;
    
}


/**
 *  类方法,完成当前类的初始化
 *
 *  @param dict 字典数据
 *
 *  @return 返回当前类的对象,作用是为了完成字典转模型
 */
+ (instancetype) shopSetGroupWithDict:(NSDictionary *)dict{
    //调用上面自己定义的init初始化方法
    return [[self alloc]initWithDict:dict];
    
}

@end
