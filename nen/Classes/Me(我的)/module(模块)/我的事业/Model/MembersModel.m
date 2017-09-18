//
//  MembersModel.m
//  nen
//
//  Created by nenios101 on 2017/5/27.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "MembersModel.h"

@implementation MembersModel
+ (void)mebersModelMobilePhone:(NSString *)mobilePhone PageSize:(NSString *)Pagesize Page:(NSString *)page MembersType:(NSString *)membersType success:(void(^)(NSMutableArray<MembersModel *> *membersArray))successBlock error:(void(^)()) errorBlock;
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr;
    
    NSDictionary *dict;
    
    if ([membersType isEqualToString:@"1"])
    {
        splitCompleteStr = [NSString stringEncryptedAddress:@"/mine/diremployee"];
        if (mobilePhone.length == 0)
        {
            dict = @{@"page":page,@"pagesize":Pagesize};
        }else
        {
            dict = @{@"mobile":mobilePhone,@"page":page,@"pagesize":Pagesize};
        }
        
    }else
    {
         dict = @{@"page":page,@"pagesize":Pagesize};
        splitCompleteStr = [NSString stringEncryptedAddress:@"/mine/allemployee"];
    }
    
    
    
    
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
       // NSLog(@"%@",responseObject);
        
        NSMutableArray *dataArray = responseObject[@"list"];
        
        NSMutableArray *array = [MembersModel mj_objectArrayWithKeyValuesArray:dataArray];
        
        
        if (successBlock)
        {
            successBlock(array);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];

    
}


@end
