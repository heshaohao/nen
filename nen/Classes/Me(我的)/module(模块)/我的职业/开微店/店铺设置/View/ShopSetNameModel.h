//
//  ShopSetNameModel.h
//  nen
//
//  Created by nenios101 on 2017/6/6.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopSetNameModel : NSObject

// 设置店铺名称
@property (nonatomic,copy) NSString *name;


- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)shopSetGroupWithDict:(NSDictionary *)dict;

@end
