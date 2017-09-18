//
//  ShopGoodsListModel.h
//  nen
//
//  Created by nenios101 on 2017/5/3.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopGoodsListModel : NSObject
//商品id
@property(nonatomic,copy) NSString *id;
//商品名称
@property(nonatomic,copy) NSString *goods_name;
//价格
@property(nonatomic,copy) NSString *price;
//商家名称
@property(nonatomic,copy) NSString *shop_name;
//规格
@property(nonatomic,copy) NSString *spec;
//运费
@property(nonatomic,copy) NSString *carriage;
//销量
@property(nonatomic,copy) NSString *sale_num;
//商品图片
@property(nonatomic,copy) NSString *goods_img;
//商品分享链接
@property(nonatomic,copy) NSString *share_url;
//是否有促销属性
@property(nonatomic,copy) NSString *is_promotion;
//商家地址
@property(nonatomic,copy) NSString *address;
//营销方案
@property(nonatomic,copy) NSString *ad;
//评论数目
@property(nonatomic,copy) NSString *comment_count;
//发货地
@property(nonatomic,copy) NSString *delivesress;
//原价
@property(nonatomic,copy) NSString *primeval_price;

+(void)shopGoodsproductListGoodsId:(NSString *)goodsId Page:(NSString *)page GoodsName:(NSString *)goodsName success:(void(^)(NSMutableArray <ShopGoodsListModel *> *goodsList))successBlock error:(void(^)())errorBlock;

@end
