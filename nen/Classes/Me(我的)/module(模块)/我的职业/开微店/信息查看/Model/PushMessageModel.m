//
//  PushMessageModel.m
//  nen
//
//  Created by nenios101 on 2017/6/6.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "PushMessageModel.h"

@implementation PushMessageModel
+ (void)pushMessageModelPage:(NSString *)page PageSzie:(NSString *)pageSize Success:(void(^)(NSMutableArray<PushMessageModel *> *pushMessageArray))successBlock error:(void(^)()) errorBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/push/getinfo"];
    
    NSDictionary *dict = @{@"page":page,@"pagesize":@"8"};
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
    
        
        NSMutableArray *dataArray = responseObject[@"list"];
        
        NSMutableArray *array = [PushMessageModel mj_objectArrayWithKeyValuesArray:dataArray];
        
        if (successBlock)
        {
            successBlock(array);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];

}
@end
