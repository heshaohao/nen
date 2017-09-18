//
//  CollectgoodsModel.m
//  nen
//
//  Created by nenios101 on 2017/6/19.
//  Copyright © 2017年 nen. All rights reserved.
//商品收藏

#import "CollectgoodsModel.h"

@implementation CollectgoodsModel

+(void)collectgoodsModelsuccess:(void(^)(NSMutableArray<CollectgoodsModel *> *collectGoodsArray))successBlock error:(void(^)()) errorBlock
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/collect/collectgoodslist"];
    
    
    NSDictionary *dict = @{@"page":@"1",@"pagesize":@"8"};
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
     
        
        NSMutableArray *dataArray = responseObject[@"list"];
    
        NSMutableArray *array = [CollectgoodsModel mj_objectArrayWithKeyValuesArray:dataArray];
        
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
