//
//  ReleaseGoodsViewModel.m
//  nen
//
//  Created by nenios101 on 2017/7/10.
//  Copyright © 2017年 nen. All rights reserved.
// 编辑商品



#import "ReleaseGoodsViewModel.h"

@implementation ReleaseGoodsViewModel


+(void)releaseGoodsViewModelGoodsId:(NSString *)goodsId success:(void(^)(ReleaseGoodsViewModel * goodsModel))successBlock error:(void(^)())errorBlock
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/shopmanage/goods"];
    
    NSDictionary *dict= @{@"id":goodsId};
    

    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dict = responseObject[@"obj"];
        
        ReleaseGoodsViewModel *model = [[ReleaseGoodsViewModel alloc] init];
        
        model = [ReleaseGoodsViewModel mj_objectWithKeyValues:dict];
        
        [ReleaseGoodsViewModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"descriptionTitle":@"description"};
        }];
        
        if (successBlock)
        {
            successBlock(model);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];

    
    
}


@end
