//
//  goodsProductModel.m
//  nen
//
//  Created by nenios101 on 2017/3/24.、
//  Copyright © 2017年 nen. All rights reserved.
//商品详情

#import "GoodsProductModel.h"

@implementation GoodsProductModel

+(void)goodsproductListGoodsId:(NSString *)goodsId success:(void(^)(GoodsProductModel * goodsList))successBlock error:(void(^)())errorBlock;
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/shop/goodsitem"];
    
    NSDictionary *dict= @{@"goods_id":@([goodsId integerValue])};
    
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
       NSDictionary *dict = responseObject[@"obj"];
        
    //   NSLog(@"%@",responseObject);
   
        NSString *coder = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"resultCode"]];
        
        if (dict == nil)
        {
            [JKAlert alertText:@"商品详情数据错误"];
            return;
        }
       
        if ([coder isEqualToString:@"0"])
        {
         
            GoodsProductModel *model = [[GoodsProductModel alloc] init];
            
            model = [GoodsProductModel mj_objectWithKeyValues:dict];
            
            [GoodsProductModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"descriptionTitle":@"description"};
            }];
            
            
            if (successBlock)
            {
                successBlock(model);
            }
            
        }else
        {
            if (successBlock)
            {
                successBlock(nil);
            }
        }
        
    
        
        
    //  NSLog(@"%@",responseObject);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
     //   NSLog(@"%@",error);
        
        if (errorBlock)
        {
            errorBlock();
        }
        
    
    }];

}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
