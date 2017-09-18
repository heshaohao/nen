//
//  shopmanageModel.h
//  nen
//
//  Created by nenios101 on 2017/6/1.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopmanageModel : NSObject
//店铺号
@property(nonatomic,copy) NSString *id;
//店铺名称
@property(nonatomic,copy) NSString *shop_name;
//商家logo
@property(nonatomic,copy) NSString *shop_logo;
//商家介绍
@property(nonatomic,copy) NSString *introduce;
//
@property(nonatomic,copy) NSString *customer_mobile;
//
@property(nonatomic,copy) NSString *create_time;
//
@property(nonatomic,copy) NSString *address;
//今日成交总额
@property(nonatomic,copy) NSString *today_deal;
//今日订单
@property(nonatomic,copy) NSString *today_order;
//
@property(nonatomic,copy) NSString *star;
//
@property(nonatomic,copy) NSString *rate;
//
@property(nonatomic,copy) NSString *fans;

+ (void)ShopmanageModelsuccess:(void(^)(ShopmanageModel *shopmanageModel))successBlock error:(void(^)()) errorBlock;
@end
