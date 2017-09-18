//
//  ForumPostModel.m
//  nen
//
//  Created by nenios101 on 2017/5/10.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "ForumPostModel.h"

@implementation ForumPostModel
+ (void)forumPostModelType:(NSString *)type PageSize:(NSString *)Pagesize Page:(NSString *)page success:(void(^)(NSMutableArray<ForumPostModel *> *forumPosArray))successBlock error:(void(^)()) errorBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/post/list"];
    
    
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    
   
    
    NSDictionary *dict = @{@"page":page,@"pagesize":Pagesize,@"type":type};
    
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
      //  NSLog(@"%@",responseObject);
        
        NSMutableArray *dataArray = responseObject[@"list"];
        
        NSMutableArray *array = [ForumPostModel mj_objectArrayWithKeyValuesArray:dataArray];
        
        
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
