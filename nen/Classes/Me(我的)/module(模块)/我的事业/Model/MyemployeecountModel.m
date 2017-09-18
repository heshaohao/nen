//
//  MyemployeecountModel.m
//  nen
//
//  Created by apple on 17/5/29.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "MyemployeecountModel.h"

@implementation MyemployeecountModel
+ (void)MyemployeeModelBeginTime:(NSString *)beginTime EndTime:(NSString *)endTime success:(void(^)(MyemployeecountModel * employeeModel))successBlock error:(void(^)())errorBlock
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/mine/myemployeecount"];
    
    NSDictionary *dict;
    
    if (beginTime.length > 1)
    {
        dict = @{@"begin_time":beginTime,@"end_time":endTime};
    }
 
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        NSDictionary *dict = responseObject[@"obj"];
        
        MyemployeecountModel *model = [[MyemployeecountModel alloc] init];
        
        model = [MyemployeecountModel mj_objectWithKeyValues:dict];
        
        if (successBlock)
        {
            successBlock(model);
        }
        
      
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
        
    }];
    

}


@end
