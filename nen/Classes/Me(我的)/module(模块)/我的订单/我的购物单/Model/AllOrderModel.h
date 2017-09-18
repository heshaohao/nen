//
//  AllOrderModel.h
//  nen
//
//  Created by nenios101 on 2017/4/14.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllOrderModel : NSObject

// 订单ID
@property(nonatomic,copy) NSString *Id;
// 商家ID
@property(nonatomic,strong) NSNumber *shop_id;
// 商家姓名
@property(nonatomic,copy) NSString *shop_name;
// 商品id
@property(nonatomic,copy) NSString *goods_id;
// 商品名称
@property(nonatomic,copy) NSString *create_time;
// 总价
@property(nonatomic,copy) NSString *pay_bank;
// 订单状态
@property(nonatomic,copy) NSString *state;

@property(nonatomic,strong) NSArray * detail;
// 订单状态名称
@property(nonatomic,copy) NSString * state_name;
// 团购ID 不是团购为0
@property(nonatomic,copy) NSString *group_id;

@end
