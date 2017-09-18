//
//  TheConsigneeInformationModel.m
//  nen
//
//  Created by nenios101 on 2017/8/8.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "TheConsigneeInformationModel.h"

@implementation TheConsigneeInformationModel

+(void)theConsigneeInformationModelOrderId:(NSString *)orderId success:(void(^)(TheConsigneeInformationModel * theConsigneeInformationModel))successBlock error:(void(^)())errorBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/shopmanage/orderview"];
    
    NSDictionary *dict= @{@"id":orderId};
    
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dict = responseObject[@"obj"];
        
        // NSLog(@"%@",responseObject);
        
        if (dict != nil)
        {
            TheConsigneeInformationModel *model = [[TheConsigneeInformationModel alloc] init];
            
            model = [TheConsigneeInformationModel mj_objectWithKeyValues:dict];
            
            if (successBlock)
            {
                successBlock(model);
            }
            
        }else
        {
            [JKAlert alertText:@"收货人信息数据错误"];
        }

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (errorBlock)
        {
            errorBlock();
        }
        
    }];

}

@end
