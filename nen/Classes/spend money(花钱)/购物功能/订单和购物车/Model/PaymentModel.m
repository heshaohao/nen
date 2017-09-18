//
//  PaymentModel.m
//  nen
//
//  Created by nenios101 on 2017/4/6.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "PaymentModel.h"

@implementation PaymentModel

+(void)paymentModelGoodsId:(NSString *)goodsId GoodsNum:(NSString *)goodsNum Options:(NSString *)options is_Group:(NSString *)isgroup succes:(void(^)(NSArray <PaymentModel *> *paymentModelArray))succesBlock error:(void(^)())errorBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    NSString *completeStr = [NSString stringEncryptedAddress:@"/order/orderoncecreate"];
    
    NSDictionary *dict = @{@"goods_id":goodsId,@"goods_num":@([goodsNum integerValue]),@"equipment":@"ios",@"address_id":@"1",@"is_group":isgroup,@"back_type":options};
    
    
    [manager POST:completeStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
     //  NSLog(@"%@",responseObject);
       
        NSArray *array = responseObject[@"list"];
        
        
        NSArray *modelArray = [PaymentModel mj_objectArrayWithKeyValuesArray:array];
        
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


+(void)paymentModelGoodsId:(NSString *)goodsId succes:(void (^)(NSArray<PaymentModel *> *))succesBlock error:(void (^)())errorBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    NSString *completeStr = [NSString stringEncryptedAddress:@"/order/ordercartcreate"];
    
    
    NSDictionary *dict = @{@"cart_ids":goodsId,@"equipment":@"ios",@"address_id":@"1",@"pay_way":@"1"};
    
    [manager POST:completeStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        NSArray *array = responseObject[@"list"];
        
        
        NSArray *modelArray = [PaymentModel mj_objectArrayWithKeyValuesArray:array];
        
        if (succesBlock)
        {
            succesBlock(modelArray.copy);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
        if (error)
        {
            
        }
    }];
    
    

}
@end
