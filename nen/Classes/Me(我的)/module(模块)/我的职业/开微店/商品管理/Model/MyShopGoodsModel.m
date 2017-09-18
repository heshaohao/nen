//
//  MyShopGoodsModel.m
//  nen
//
//  Created by nenios101 on 2017/6/5.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "MyShopGoodsModel.h"

@implementation MyShopGoodsModel
+ (void)shopGoodsListModelShopId:(NSString *)shopid Type:(NSString *)type PageSize:(NSString *)Pagesize Page:(NSString *)page success:(void(^)(NSMutableArray<MyShopGoodsModel *> *ShopGoodsListArray))successBlock error:(void(^)()) errorBlock
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/shopmanage/storegoodslist"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    
    NSDictionary *dict = @{@"page":page,@"pagesize":Pagesize,@"type":type,@"shop_id":shopid};
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
       // NSLog(@"%@",responseObject);
        
        NSMutableArray *dataArray = responseObject[@"list"];
        
        NSMutableArray *array = [MyShopGoodsModel mj_objectArrayWithKeyValuesArray:dataArray];
        
        if (successBlock)
        {
            successBlock(array);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
        
    }];
    
}
@end
