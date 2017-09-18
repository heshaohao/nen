//
//  editShoppingCar.m
//  nen
//
//  Created by apple on 17/4/4.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "editShoppingCarModel.h"

@implementation editShoppingCarModel

+(void)shoppingModelsucces:(void(^)(NSMutableArray<editShoppingCarModel *> *ShoppingCarArray))succesBlock error:(void(^)()) errorBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    NSString *completeStr = [NSString stringEncryptedAddress:@"/order/viewgoodscart"];
    
    
    [manager GET:completeStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
    //    NSLog(@"%@",responseObject);
        
        NSArray *array = responseObject[@"list"];
        
        
        NSMutableArray *modelArray = [editShoppingCarModel mj_objectArrayWithKeyValuesArray:array];
        
      //  NSLog(@"%@",modelArray);
        
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
