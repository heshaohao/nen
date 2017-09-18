//
//  MarketingModel.m
//  nen
//
//  Created by nenios101 on 2017/3/24.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "MarketingModel.h"

@implementation MarketingModel
+(void)marketingListGoodsId:(NSString *)goodsId success:(void(^)(MarketingModel* markeModel))successBlock error:(void(^)())errorBlock
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/datum/marketingshopping"];
    
    NSDictionary *dict= @{@"goods_id":@([goodsId integerValue]),@"way":@2};
    
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        
       NSDictionary *dict = responseObject[@"obj"];
//        
       MarketingModel *model = [[MarketingModel alloc] init];
//        
       model = [MarketingModel mj_objectWithKeyValues:dict];
     
        if (successBlock)
        {
            successBlock(model);
        }
        
     // NSLog(@"%@",responseObject);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
        
        if (error)
        {
            errorBlock();
        }
    }];
    
}

@end
