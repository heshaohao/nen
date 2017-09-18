//
//  GoodsEvaluateModel.h
//  nen
//
//  Created by nenios101 on 2017/6/13.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsEvaluateModel : NSObject

//评价id
@property(nonatomic,copy) NSString *id;
//评价用户名称
@property(nonatomic,copy) NSString *user_name;
//评价用户头像
@property(nonatomic,copy) NSString *user_img;
//评价内容
@property(nonatomic,copy) NSString *content;
//评价星级
@property(nonatomic,copy) NSString *stars;
//评价时间
@property(nonatomic,copy) NSString *create_time;
//商家回复的内容
@property(nonatomic,copy) NSString *reply;
//商家回复时间
@property(nonatomic,copy) NSString *reply_time;

+ (void)goodsEvaluateModelGoodsId:(NSString *)goodsId success:(void(^)(NSMutableArray<GoodsEvaluateModel *> *goodsEvaluateArray))successBlock error:(void(^)()) errorBlock;

@end
