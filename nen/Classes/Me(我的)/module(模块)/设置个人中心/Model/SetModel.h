//
//  SetModel.h
//  nen
//
//  Created by nenios101 on 2017/4/18.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SetModel : NSObject

@property(nonatomic,copy) NSString *titleLabel;

@property(nonatomic,copy) NSString *dextTitle;

/**
 *  对象方法,完成当前类的初始化
 *
 *  @param dict 字典数据
 *
 *  @return 返回当前类的对象,作用是为了完成字典转模型
 */
- (instancetype)initWithDict:(NSDictionary *)dict;


/**
 *  类方法,完成当前类的初始化
 *
 *  @param dict 字典数据
 *
 *  @return 返回当前类的对象,作用是为了完成字典转模型
 */
+ (instancetype)carWithDict:(NSDictionary *)dict;

@end
