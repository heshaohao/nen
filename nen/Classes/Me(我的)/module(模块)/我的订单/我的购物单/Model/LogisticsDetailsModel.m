//
//  LogisticsDetailsModel.m
//  nen
//
//  Created by nenios101 on 2017/8/8.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "LogisticsDetailsModel.h"

@implementation LogisticsDetailsModel
+(void)logisticsDetailsModelOrderId:(NSString *)orderId success:(void(^)(LogisticsDetailsModel * logisticsDetailsModel))successBlock error:(void(^)())errorBlock
{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/order/logisticsinfo"];
    
    NSDictionary *dict= @{@"id":orderId};
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dict = responseObject[@"obj"];
        
        NSLog(@"%@",responseObject);
        
        NSString *coder = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"resultCode"]];
        NSString *resultMessage = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"resultMessage"]];
        
        if (dict == nil)
        {
            [JKAlert alertText:@"物流数据错误"];
            return;
        }
        
        
        if ([coder isEqualToString:@"0"])
        {
            LogisticsDetailsModel *model = [[LogisticsDetailsModel alloc] init];
            model = [LogisticsDetailsModel mj_objectWithKeyValues:dict];
            
            if (successBlock)
            {
                successBlock(model);
            }
            
        }else
        {
            [JKAlert alertText:resultMessage];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (errorBlock)
        {
            errorBlock();
        }
      
    }];

}


@end
