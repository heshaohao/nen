//
//  OrderModel.h
//  nen
//
//  Created by nenios101 on 2017/3/28.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject
// 商品id
@property(nonatomic,copy) NSString *id;
// 商品名称
@property(nonatomic,copy) NSString *goods_name;
// 商品图片
@property(nonatomic,copy) NSString *goods_img;
// 商品属性
@property(nonatomic,copy) NSString *spec;
// 商品价格
@property(nonatomic,copy) NSString *price;
// 数量
@property(nonatomic,copy) NSString *num;
// 总价
@property(nonatomic,copy) NSString *total;
// 是否促销
@property(nonatomic,copy) NSString *is_promotion;


+(void)orderModelIsCarId:(NSString *)isCarId GoodsId:(NSString *)goodsId AndNum:(NSString *)num Is_group:(NSString *)is_group succes:(void(^)(NSArray<OrderModel *> *orderArray))succesBlock error:(void(^)()) errorBlock;




@end
