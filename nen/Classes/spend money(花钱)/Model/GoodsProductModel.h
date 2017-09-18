//
//  goodsProductModel.h
//  nen
//
//  Created by nenios101 on 2017/3/24.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsProductModel : NSObject
//商品id
@property(nonatomic,copy) NSString *id;

// 库存
@property (nonatomic,copy) NSString *inventory;
//商品名称
@property(nonatomic,copy) NSString *goods_name;
//商品价格
@property(nonatomic,copy) NSString * price;
// 原价价格
@property (nonatomic,copy) NSString *primeval_price;
// 商家Id
@property(nonatomic,copy) NSString *shop_id;
//商家名称
@property(nonatomic,copy) NSString * shop_name;
//规格
@property(nonatomic,copy) NSString *spec;
//运费
@property(nonatomic,copy) NSString * carriage;
// 销量
@property(nonatomic,copy) NSString *sale_num;
//备注信息
@property(nonatomic,copy) NSString *remark;
//商品图像
@property(nonatomic,copy) NSString *goods_img;
//商品描述
@property(nonatomic,copy) NSString *descriptionTitle;
//商品所以图片
@property(nonatomic,copy) NSDictionary *goods_all_img;
//商铺的电话
@property(nonatomic,copy) NSString *customer_mobile;
//分享链接
@property(nonatomic,copy) NSString *share_url;
//是否有促销属性 1:促销，0，不促销
@property(nonatomic,copy) NSString *is_promotion;
//地址
@property(nonatomic,copy) NSString *shop_address;
// 评论数
@property(nonatomic,copy) NSString *comment_count;
// 是否收藏 1:否  ，0 是
@property(nonatomic,copy) NSString *is_collect;
//活动开始时间
@property(nonatomic,copy) NSString *start_time;
//活动结束时间
@property(nonatomic,copy) NSString * end_time;
//营销方案
@property(nonatomic,copy) NSString *ad;
//用于聊天的
@property(nonatomic,copy) NSString * shop_mobile;
//发货地址
@property (nonatomic,copy) NSString *delivesress;

+(void)goodsproductListGoodsId:(NSString *)goodsId success:(void(^)(GoodsProductModel * goodsList))successBlock error:(void(^)())errorBlock;

@end
