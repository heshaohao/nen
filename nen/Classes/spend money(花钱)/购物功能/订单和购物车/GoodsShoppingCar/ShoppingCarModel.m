//
//  ShoppingCarModel.m
//  GoodsShoppingCar
//
//  Created by nenios101 on 2017/3/16.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "ShoppingCarModel.h"

@implementation ShoppingCarModel

+(void)shoppingModelsucces:(void(^)(NSMutableArray<ShoppingCarModel *> *ShoppingCarArray))succesBlock error:(void(^)()) errorBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    NSString *completeStr = [NSString stringEncryptedAddress:@"/order/viewgoodscart"];
    
    
    [manager GET:completeStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
     //   NSLog(@"%@",responseObject);
        
        NSArray *array = responseObject[@"list"];
        
        
        NSMutableArray *modelArray = [ShoppingCarModel mj_objectArrayWithKeyValuesArray:array];
        
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
