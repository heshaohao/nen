//
//  OrderModel.m
//  nen
//
//  Created by nenios101 on 2017/3/28.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel
+(void)orderModelIsCarId:(NSString *)isCarId GoodsId:(NSString *)goodsId AndNum:(NSString *)num Is_group:(NSString *)is_group succes:(void(^)(NSArray<OrderModel *> *orderArray))succesBlock error:(void(^)()) errorBlock
{
       AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];

    NSString *completeStr = [NSString stringEncryptedAddress:@"/order/orderplan"];
 
    NSDictionary *dict = @{@"is_cart":isCarId,@"ids":goodsId,@"num":num,@"is_group":is_group};
   
    [manager POST:completeStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {

              
        NSArray *array = responseObject[@"list"];
        
        
       NSArray *modelArray = [OrderModel mj_objectArrayWithKeyValuesArray:array];
        
        if (succesBlock)
        {
            succesBlock(modelArray.copy);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (error)
        {
          
        }
    }];
    
}
@end
