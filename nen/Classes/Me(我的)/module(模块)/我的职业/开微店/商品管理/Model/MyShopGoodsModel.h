//
//  MyShopGoodsModel.h
//  nen
//
//  Created by nenios101 on 2017/6/5.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyShopGoodsModel : NSObject
// 商品id
@property(nonatomic,copy) NSString *id;
// 商品名称
@property(nonatomic,copy) NSString*goods_name;
// 价格
@property(nonatomic,copy) NSString*price;
// 规格
@property(nonatomic,copy) NSString*spec;
// 运费
@property(nonatomic,copy) NSString*carriage;
// 销量
@property(nonatomic,copy) NSString*sale_num;
// 图片
@property(nonatomic,copy) NSString*goods_img;

@property(nonatomic,copy) NSString *introduce;

+ (void)shopGoodsListModelShopId:(NSString *)shopid Type:(NSString *)type PageSize:(NSString *)Pagesize Page:(NSString *)page success:(void(^)(NSMutableArray<MyShopGoodsModel *> *ShopGoodsListArray))successBlock error:(void(^)()) errorBlock;

@end
