//
//  MerchantsOrdersModel.m
//  nen
//
//  Created by nenios101 on 2017/6/8.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "MerchantsOrdersModel.h"

@implementation MerchantsOrdersModel
+ (void)merchantsOrdersModelState:(NSString *)state PageSize:(NSString *)Pagesize Page:(NSString *)page success:(void(^)(NSMutableArray<MerchantsOrdersModel *> *merchantsOrdersArray))successBlock error:(void(^)()) errorBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/shopmanage/order"];
    
    
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    NSDictionary *dict = @{@"page":page,@"pagesize":Pagesize,@"state":state};
    
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
       // NSLog(@"%@",responseObject);
        
        NSMutableArray *dataArray = responseObject[@"list"];
        
        NSMutableArray *array = [MerchantsOrdersModel mj_objectArrayWithKeyValuesArray:dataArray];
        
        
        if (successBlock)
        {
            successBlock(array);
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
}
@end
