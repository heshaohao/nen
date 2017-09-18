//
//  PostPmmentsModel.m
//  nen
//
//  Created by nenios101 on 2017/5/26.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "MyThePostModel.h"

@implementation MyThePostModel
+ (void)myThePostModelPageSize:(NSString *)Pagesize Page:(NSString *)page success:(void(^)(NSMutableArray<MyThePostModel *> *PostArray))successBlock error:(void(^)()) errorBlock
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/post/mypost"];
    
    
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    
    NSDictionary *dict = @{@"page":page,@"pagesize":Pagesize};
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        NSMutableArray *dataArray = responseObject[@"list"];
        
        NSMutableArray *array = [MyThePostModel mj_objectArrayWithKeyValuesArray:dataArray];
        
        if (successBlock)
        {
            successBlock(array);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
        
    }];

}
@end
