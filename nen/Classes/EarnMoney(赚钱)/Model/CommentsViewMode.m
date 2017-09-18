//
//  CommentsViewMode.m
//  nen
//
//  Created by nenios101 on 2017/5/12.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "CommentsViewMode.h"

@implementation CommentsViewMode

+ (void)CommentsModelPostsID:(NSString *)PostsId PageSize:(NSString *)Pagesize Page:(NSString *)page success:(void(^)(CommentsViewMode *commentsMolde))successBlock error:(void(^)()) errorBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/post/view"];
    
    
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    NSDictionary *dict = @{@"page":page,@"pagesize":Pagesize,@"id":PostsId};
    
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
      //  NSLog(@"%@",responseObject);
        
        NSDictionary *dict = responseObject[@"obj"];
        
        CommentsViewMode *model = [CommentsViewMode mj_objectWithKeyValues:dict];
        
        if (successBlock)
        {
            successBlock(model);
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
       // NSLog(@"%@",error);
        
        if (errorBlock)
        {
            errorBlock();
        }
        
    }];

}
@end
