//
//  ReleaseGoodsModel.m
//  nen
//
//  Created by apple on 17/7/5.
//  Copyright © 2017年 nen. All rights reserved.
// 分类商品 


#import "ReleaseGoodsModel.h"

@implementation ReleaseGoodsModel

+ (void)releaseGoodsModelParent_Id:(NSString *)parent_id success:(void(^)(NSMutableArray<ReleaseGoodsModel *> *ReleaseGoodsArray))successBlock error:(void(^)()) errorBlock
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *splitCompleteStr = [NSString stringGETEncryptedAddress:@"/shop/goodscategory" index:parent_id];
    
   

    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager GET:splitCompleteStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        NSMutableArray *dataArray = responseObject[@"list"];
        
        if (dataArray.count == 0 || dataArray == nil)
        {
            [JKAlert alertText:@"分类数据请求错误"];
            return ;
        }
        
        NSMutableArray *array = [ReleaseGoodsModel mj_objectArrayWithKeyValuesArray:dataArray];
        
        if (successBlock)
        {
            successBlock(array);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
        
    }];

}

@end
