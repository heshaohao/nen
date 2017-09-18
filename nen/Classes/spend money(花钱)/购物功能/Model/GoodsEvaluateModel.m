//
//  GoodsEvaluateModel.m
//  nen
//
//  Created by nenios101 on 2017/6/13.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "GoodsEvaluateModel.h"

@implementation GoodsEvaluateModel

+ (void)goodsEvaluateModelGoodsId:(NSString *)goodsId success:(void(^)(NSMutableArray<GoodsEvaluateModel *> *goodsEvaluateArray))successBlock error:(void(^)()) errorBlock
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/shop/goodsevaluate"];
    
    NSDictionary *dict = @{@"goods_id":goodsId};
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
      //  NSLog(@"%@",responseObject);
        
        NSMutableArray *dataArray = responseObject[@"list"];
        
        NSMutableArray *array = [GoodsEvaluateModel mj_objectArrayWithKeyValuesArray:dataArray];
        
        if (successBlock)
        {
            successBlock(array);
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
     //   NSLog(@"%@",error);
        
    }];

}

@end
