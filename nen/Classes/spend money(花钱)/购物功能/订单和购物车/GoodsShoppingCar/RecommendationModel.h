//
//  RecommendationModel.h
//  nen
//
//  Created by nenios101 on 2017/6/29.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendationModel : NSObject

//id
@property(nonatomic,copy) NSString *goods_id;
//商品名字
@property(nonatomic,copy) NSString *goods_name;
//价格
@property(nonatomic,copy) NSString *price;
//商品图片
@property(nonatomic,copy) NSString *goods_img;

+(void)recommendationModelSucces:(void(^)(NSMutableArray<RecommendationModel *> *recommendationArray))succesBlock error:(void(^)()) errorBlock;

@end
