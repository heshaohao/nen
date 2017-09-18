//
//  ShopFavoritesModel.m
//  nen
//
//  Created by nenios101 on 2017/6/19.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "ShopFavoritesModel.h"

@implementation ShopFavoritesModel
+(void)ShopFavoritesModelsuccess:(void(^)(NSMutableArray<ShopFavoritesModel *> *ShopFavoritesArray))successBlock error:(void(^)()) errorBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/collect/collectshoplist"];
    
    
    NSDictionary *dict = @{@"page":@"1",@"pagesize":@"8"};
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
       // NSLog(@"%@",responseObject);
        
        NSMutableArray *dataArray = responseObject[@"list"];
        
        NSMutableArray *array = [ShopFavoritesModel mj_objectArrayWithKeyValuesArray:dataArray];
        
        if (successBlock)
        {
            successBlock(array);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (errorBlock)
        {
            errorBlock();
        }
        
    }];

}


@end
