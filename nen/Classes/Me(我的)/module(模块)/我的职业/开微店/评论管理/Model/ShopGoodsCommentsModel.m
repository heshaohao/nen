//
//  ShopGoodsCommentsModel.m
//  nen
//
//  Created by nenios101 on 2017/7/3.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "ShopGoodsCommentsModel.h"

@implementation ShopGoodsCommentsModel
+ (void)ShopGoodsCommentsModelType:(NSString *)type PageSize:(NSString *)Pagesize Page:(NSString *)page success:(void(^)(NSMutableArray<ShopGoodsCommentsModel *> *ShopGoodsListArray))successBlock error:(void(^)()) errorBlock
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/shopmanage/getexvalall"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    
    
    NSDictionary *dict = @{@"page":page,@"pagesize":Pagesize,@"type":type};
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
      //  NSLog(@"%@",responseObject);
        
        NSMutableArray *dataArray = responseObject[@"list"];
        
        NSMutableArray *array = [ShopGoodsCommentsModel mj_objectArrayWithKeyValuesArray:dataArray];
        
        if (successBlock)
        {
            successBlock(array);
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
