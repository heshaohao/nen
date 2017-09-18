//
//  GroupBuyingItemGoodsItemModel.m
//  nen
//
//  Created by nenios101 on 2017/5/4.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "GroupBuyingItemGoodsItemModel.h"

@implementation GroupBuyingItemGoodsItemModel

+(void)groupBuyingItemGoodsId:(NSString *)goodsId success:(void(^)(GroupBuyingItemGoodsItemModel* groupBuyingModel))successBlock error:(void(^)())errorBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/group/groupview"];
    
    NSDictionary *dict= @{@"goods_id":goodsId};
    
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
    
      NSLog(@"%@",responseObject);
        
        NSString *coder = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"resultCode"]];
        
        NSDictionary *dict = responseObject[@"obj"];
        
        if (dict == nil)
        {
            [JKAlert alertText:@"团购数据错误"];
            
            return;
        }
        
        if ([coder isEqualToString:@"0"])
        {
            
            GroupBuyingItemGoodsItemModel *model = [[GroupBuyingItemGoodsItemModel alloc] init];
            
            model = [GroupBuyingItemGoodsItemModel mj_objectWithKeyValues:dict];
            
            [GroupBuyingItemGoodsItemModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
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
        
        
      
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
        
        if (error)
        {
            errorBlock();
        }
    }];

}

@end
