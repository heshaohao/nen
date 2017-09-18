//
//  ExpressCompanyList.m
//  nen
//
//  Created by nenios101 on 2017/8/8.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "ExpressCompanyList.h"

@implementation ExpressCompanyList

+ (void)expressCompanyListsuccess:(void(^)(NSMutableArray<ExpressCompanyList *> *companyListArray))successBlock error:(void(^)()) errorBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/shopmanage/expresslist"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
      //  NSLog(@"%@",responseObject);
        
        NSMutableArray *dataArray = responseObject[@"list"];
        
        if (dataArray !=nil)
        {
            
            NSMutableArray *array = [ExpressCompanyList mj_objectArrayWithKeyValuesArray:dataArray];
            
            if (successBlock)
            {
                successBlock(array);
            }
            
        }else
        {
            [JKAlert alertText:@"物流公司列表数据错误"];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        if (errorBlock)
        {
            errorBlock();
        }

        
    }];

}

@end
