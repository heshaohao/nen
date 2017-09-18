//
//  shopmanageModel.m
//  nen
//
//  Created by nenios101 on 2017/6/1.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "ShopmanageModel.h"

@implementation ShopmanageModel
+ (void)ShopmanageModelsuccess:(void(^)(ShopmanageModel *shopmanageModel))successBlock error:(void(^)()) errorBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/shopmanage/index"];
    
    
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    
    [manager GET:splitCompleteStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
      //  NSLog(@"%@",responseObject);
        
        NSDictionary *dict = responseObject[@"obj"];
        
        ShopmanageModel *model = [ShopmanageModel mj_objectWithKeyValues:dict];
        
        if (successBlock)
        {
            successBlock(model);
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];

}
@end
