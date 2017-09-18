//
//  ShopsGoodsModel.h
//  nen
//
//  Created by nenios101 on 2017/6/1.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopsGoodsModel : NSObject

//商品id
@property(nonatomic,copy) NSString *id;
//商品名称
@property(nonatomic,copy) NSString *goods_name;
//价格
@property(nonatomic,copy) NSString *price;
//规格
@property(nonatomic,copy) NSString *spec;
//运费
@property(nonatomic,copy) NSString *carriage;
//销量
@property(nonatomic,copy) NSString *sale_num;
//库存
@property(nonatomic,copy) NSString *inventory;
//商品照片
@property(nonatomic,copy) NSString *goods_img;
//店铺介绍
@property(nonatomic,copy) NSString *introduce;

+ (void)shopsGoodsModelShopId:(NSString *)shopId Type:(NSString *)type Page:(NSString *)page Sort:(NSString *)sort PageSize:(NSString *)pagesize success:(void(^)(NSMutableArray<ShopsGoodsModel *> *forumPosArray))successBlock error:(void(^)()) errorBlock;


@end
