//
//  GroupBuyingModel.m
//  nen
//
//  Created by nenios101 on 2017/5/4.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "GroupBuyingModel.h"

@implementation GroupBuyingModel
+ (void)groupBuyingModelsuccess:(void(^)(NSMutableArray<GroupBuyingModel *> *groupArray))successBlock error:(void(^)()) errorBlock
{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/group/grouplist"];
    
   
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    
    [manager POST:splitCompleteStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
     //   NSLog(@"%@",responseObject);
        
        NSMutableArray *dataArray = responseObject[@"list"];
        
        
        NSMutableArray *array = [GroupBuyingModel mj_objectArrayWithKeyValuesArray:dataArray];
        
        
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
