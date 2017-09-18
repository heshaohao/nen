//
//  SetGroupModel.m
//  nen
//
//  Created by nenios101 on 2017/4/18.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "SetGroupModel.h"
#import "SetModel.h"

@implementation SetGroupModel
/**
 *  对象方法,完成当前类的初始化
 *
 *  @param dict 字典数据
 *
 *  @return 返回当前类的对象,作用是为了完成字典转模型
 */
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




- (void)setSetArray:(NSArray *)setArray
{

    
    //1. 创建可变数组
    NSMutableArray *nmArray = [NSMutableArray array];
    
    //2. 遍历字典数组
    for (NSDictionary *dict in setArray) {
        //3. 字典转模型
        SetModel *set = [SetModel carWithDict:dict];
        //4 添加到可变数组中
        [nmArray addObject:set];
        
    }
    //5. 赋值
    _setArray = nmArray;
    
}





/**
 *  类方法,完成当前类的初始化
 *
 *  @param dict 字典数据
 *
 *  @return 返回当前类的对象,作用是为了完成字典转模型
 */
+ (instancetype) carGroupWithDict:(NSDictionary *)dict{
    //调用上面自己定义的init初始化方法
    return [[self alloc]initWithDict:dict];
    
}

@end
