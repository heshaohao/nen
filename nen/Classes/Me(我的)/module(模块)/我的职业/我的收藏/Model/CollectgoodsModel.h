//
//  CollectgoodsModel.h
//  nen
//
//  Created by nenios101 on 2017/6/19.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectgoodsModel : NSObject

//商品ID
@property(nonatomic,copy) NSString *id;
//商品名
@property(nonatomic,copy) NSString *goods_name;
//图片
@property(nonatomic,copy) NSString *img;
//价格
@property(nonatomic,copy) NSString *price;
//是否团购1：否 0：是
@property(nonatomic,copy) NSString *is_group;

+(void)collectgoodsModelsuccess:(void(^)(NSMutableArray<CollectgoodsModel *> *collectGoodsArray))successBlock error:(void(^)()) errorBlock;

@end
