//
//  PaymentModel.h
//  nen
//
//  Created by nenios101 on 2017/4/6.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentModel : NSObject

//订单id
@property(nonatomic,copy) NSString *id;
//商品实际价格
@property(nonatomic,copy) NSString *goods_cost;
//运费
@property(nonatomic,copy) NSString *delivery_cost;
//优惠
@property(nonatomic,copy) NSString *discount;
//需实际支付
@property(nonatomic,copy) NSString *pay_bank;
//商家id
@property(nonatomic,copy) NSString *shop_id;
/**
 * 立即购买 和 团购
 */
+(void)paymentModelGoodsId:(NSString *)goodsId GoodsNum:(NSString *)goodsNum Options:(NSString *)options is_Group:(NSString *)isgroup succes:(void(^)(NSArray <PaymentModel *> *paymentModelArray))succesBlock error:(void(^)())errorBlock;

/**
 *  购物车购买
 */
+(void)paymentModelGoodsId:(NSString *)goodsId succes:(void(^)(NSArray <PaymentModel *> *paymentModelArray))succesBlock error:(void(^)())errorBlock;
                                                                                    
@end
