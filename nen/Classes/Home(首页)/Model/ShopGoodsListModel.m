//
//  ShopGoodsListModel.m
//  nen
//
//  Created by nenios101 on 2017/5/3.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "ShopGoodsListModel.h"

@implementation ShopGoodsListModel
+(void)shopGoodsproductListGoodsId:(NSString *)goodsId Page:(NSString *)page GoodsName:(NSString *)goodsName success:(void(^)(NSMutableArray <ShopGoodsListModel *> *goodsList))successBlock error:(void(^)())errorBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    NSString *completeStr = [NSString stringEncryptedAddress:@"/shop/goodslist"];
    
    //NSLog(@"%@",goodsId);
    
    NSDictionary *dict;
    
    if (!goodsName.length)
    {
        if ([goodsId isEqualToString:@"0"])
        {
            dict = @{@"category_id":@0,@"page":@"1",@"pagesize":@"8",@"is_boutique":@"1",@"is_recommend":@"1"};
        }else
        {
            NSInteger idNumber = [goodsId integerValue];
            
            dict = @{@"category_id":@(idNumber),@"page":@"1",@"pagesize":@"8"};
        }
        
    }else
    {
        dict = @{@"page":page,@"pagesize":@"8",@"is_boutique":@"0",@"goods_name":goodsName};
    }
    
    
    
    [manager POST:completeStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
      // NSLog(@"%@",responseObject);
        
        NSArray *array = responseObject[@"list"];
        
        
        NSArray *modelArray = [ShopGoodsListModel mj_objectArrayWithKeyValuesArray:array];
        
        if (successBlock)
        {
            successBlock(modelArray.copy);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (error)
        {
            errorBlock();
        }
        
        NSLog(@"%@",error);
        
        
    }];

}
@end
