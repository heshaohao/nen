//
//  ShopsGoodsModel.m
//  nen
//
//  Created by nenios101 on 2017/6/1.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "ShopsGoodsModel.h"

@implementation ShopsGoodsModel
+ (void)shopsGoodsModelShopId:(NSString *)shopId Type:(NSString *)type Page:(NSString *)page Sort:(NSString *)sort PageSize:(NSString *)pagesize success:(void(^)(NSMutableArray<ShopsGoodsModel *> *shopArray))successBlock error:(void(^)()) errorBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/post/list"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    NSDictionary *dict = @{@"shop_id":shopId,@"pagesize":pagesize,@"type":type,@"page":page};
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
      //  NSLog(@"%@",responseObject);
        
        NSMutableArray *dataArray = responseObject[@"list"];
        
        NSMutableArray *array = [ShopsGoodsModel mj_objectArrayWithKeyValuesArray:dataArray];
        
        if (successBlock)
        {
            successBlock(array);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];

}



@end
