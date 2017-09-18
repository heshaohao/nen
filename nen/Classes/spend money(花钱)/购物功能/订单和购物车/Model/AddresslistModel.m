//
//  AddresslistModel.m
//  nen
//
//  Created by nenios101 on 2017/3/29.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "AddresslistModel.h"

@implementation AddresslistModel
+(void)addressModelNum:(NSString *)num succes:(void(^)(AddresslistModel *addressModel))succesBlock error:(void(^)()) errorBlock
{
   
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/mine/addresslist"];
    
    NSDictionary *dict= @{@"default":num};
    
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dict = responseObject[@"obj"];
        
        AddresslistModel *model = [[AddresslistModel alloc] init];
        
        model = [AddresslistModel mj_objectWithKeyValues:dict];
 
        
        if (succesBlock)
        {
            succesBlock(model);
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
       // NSLog(@"%@",error);
        
        
        if (error)
        {
            errorBlock();
        }
    }];
    
}


+(void)addressArrayModelNum:(NSString *)num success:(void(^)(NSMutableArray<AddresslistModel *>* addressModelArray))succesBlock error:(void(^)())errorBlock
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/mine/addresslist"];
    
    NSDictionary *dict= @{@"default":num};
    
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSMutableArray *dataArray = responseObject[@"list"];
        
        NSMutableArray *goodsArray = [NSMutableArray array];
        
        goodsArray = [AddresslistModel mj_objectArrayWithKeyValuesArray:dataArray];
        
       // NSLog(@"%@",responseObject);
        
        if (succesBlock)
        {
            succesBlock(goodsArray.copy);
        }
       
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
       // NSLog(@"%@",error);
        
                if (error)
                {
                    errorBlock();
                }
      
    }];
    

    
    
}



@end
