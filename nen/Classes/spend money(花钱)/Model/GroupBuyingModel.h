//
//  GroupBuyingModel.h
//  nen
//
//  Created by nenios101 on 2017/5/4.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupBuyingModel : NSObject

//商品ID
@property(nonatomic,copy) NSString *id;
//商品名
@property(nonatomic,copy) NSString *goods_name;
//团购价格
@property(nonatomic,copy) NSString *group_price;
//商家名
@property(nonatomic,copy) NSString *shop_name;
//规格
@property(nonatomic,copy) NSString *spec;
//运费
@property(nonatomic,copy) NSString *carriage;
//销量
@property(nonatomic,copy) NSString *sale_num;
//推荐描述
@property(nonatomic,copy) NSString *remark;
//商品图片
@property(nonatomic,copy) NSString *goods_img;
//分享URL
@property(nonatomic,copy) NSString *share_url;
//评论
@property(nonatomic,copy) NSString *comment_count;
//原价
@property(nonatomic,copy) NSString *primeval_price;
//发货地
@property(nonatomic,copy) NSString *delivesress;
//参团人数
@property(nonatomic,copy) NSString *group_num;


+ (void)groupBuyingModelsuccess:(void(^)(NSMutableArray<GroupBuyingModel *> *groupArray))successBlock error:(void(^)()) errorBlock;

@end
