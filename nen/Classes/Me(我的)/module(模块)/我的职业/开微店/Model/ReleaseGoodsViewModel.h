//
//  ReleaseGoodsViewModel.h
//  nen
//
//  Created by nenios101 on 2017/7/10.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReleaseGoodsViewModel : NSObject

//商品名称
@property (nonatomic,copy) NSString *goods_name;
//价格
@property (nonatomic,copy) NSString *price;
//库存
@property (nonatomic,copy) NSString *inventory;
//分类id
@property (nonatomic,copy) NSString *category_id;
//是否上架 1：上架
@property (nonatomic,copy) NSString *is_shelf;
//运费
@property (nonatomic,copy) NSString *carriage;
//让利部分
@property (nonatomic,copy) NSString *promotion_money;
//描述
@property (nonatomic,copy) NSString *descriptionTitle;
//是否发票 1 ：是
@property (nonatomic,copy) NSString *invoice;
//是否保修 1：是
@property (nonatomic,copy) NSString *repair;


+(void)releaseGoodsViewModelGoodsId:(NSString *)goodsId success:(void(^)(ReleaseGoodsViewModel * goodsModel))successBlock error:(void(^)())errorBlock;

@end
