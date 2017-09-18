//
//  GroupBuyingItemGoodsItemModel.h
//  nen
//
//  Created by nenios101 on 2017/5/4.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupBuyingItemGoodsItemModel : NSObject

//商品ID
@property(nonatomic,copy) NSString *id;
//商品名
@property(nonatomic,copy) NSString *goods_name;
//不团购价格
@property(nonatomic,copy) NSString *price;
//商家ID
@property(nonatomic,copy) NSString *shop_id;
//商家名称
@property(nonatomic,copy) NSString *shop_name;
// 商家联系电话
@property(nonatomic,copy) NSString *customer_mobile;
//规格
@property(nonatomic,copy) NSString *spec;
//运费
@property(nonatomic,copy) NSString *carriage;
//销量
@property(nonatomic,copy) NSString *sale_num;
//备注信息
@property(nonatomic,copy) NSString *remark;
//商品描述
@property(nonatomic,copy) NSString *descriptionTitle;
//商品图片
@property(nonatomic,strong) NSDictionary *goods_all_img;
//是否收藏
@property(nonatomic,copy) NSString *is_collect;
//评论数
@property(nonatomic,copy) NSString *comment_count;
//原始价格
@property(nonatomic,copy) NSString *primeval_price;
//发货地
@property(nonatomic,copy) NSString *delivesress;
//团购价格
@property(nonatomic,copy) NSString *group_price;
//几人团
@property(nonatomic,copy) NSString *group_num;
//团购类型  1:需要拼团 2：不需要拼团
@property(nonatomic,copy) NSString *type;
//库存
@property(nonatomic,copy) NSString *inventory;
//用户名 user_name  结束时间戳 end_time  团购ID group_id
@property(nonatomic,strong) NSArray *group;


+(void)groupBuyingItemGoodsId:(NSString *)goodsId success:(void(^)(GroupBuyingItemGoodsItemModel* groupBuyingModel))successBlock error:(void(^)())errorBlock;

@end
