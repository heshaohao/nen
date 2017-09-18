//
//  ShopGoodsCommentsModel.h
//  nen
//
//  Created by nenios101 on 2017/7/3.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopGoodsCommentsModel : NSObject

//评论ID
@property(nonatomic,copy) NSString *id;
// 商家ID
@property (nonatomic,copy) NSString *shop_id;
//goods_name:商品名称
@property(nonatomic,copy) NSString *goods_name;
//商品图片
@property(nonatomic,copy) NSString *goods_img;
//价格
@property(nonatomic,copy) NSString *price;
//销量
@property(nonatomic,copy) NSString *sale_num;
//评论数量
@property(nonatomic,copy) NSString *comment_num;
//商店名
@property(nonatomic,copy) NSString *shop_name;
//用户名
@property(nonatomic,copy) NSString *user_name;
//评论内容
@property(nonatomic,copy) NSString *content;
//时间
@property(nonatomic,copy) NSString *create_time;
//星级
@property(nonatomic,copy) NSString *star;
//商品ID
@property(nonatomic,copy) NSString *goods_id;
//订单ID
@property(nonatomic,copy) NSString *order_id;
//回复回复的内容
@property(nonatomic,copy) NSString *reply;
//回复回复的时间
@property(nonatomic,copy) NSString *reply_time;


+ (void)ShopGoodsCommentsModelType:(NSString *)type PageSize:(NSString *)Pagesize Page:(NSString *)page success:(void(^)(NSMutableArray<ShopGoodsCommentsModel *> *ShopGoodsListArray))successBlock error:(void(^)()) errorBlock;


@end
