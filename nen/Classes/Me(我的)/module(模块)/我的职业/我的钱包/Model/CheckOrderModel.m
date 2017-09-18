//
//  CheckOrderModel.m
//  nen
//
//  Created by nenios101 on 2017/4/21.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "CheckOrderModel.h"

@implementation CheckOrderModel

+(void)checkModelType:(NSString *)type Page:(NSString *)page succes:(void(^)(NSMutableArray<CheckOrderModel *> *orderArray))succesBlock error:(void(^)()) errorBlock{

AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];

NSString *completeStr = [NSString stringEncryptedAddress:@"/wallet/bill"];


  NSDictionary *dict = @{@"type":type,@"page":page,@"pagesize":@"8"};


[manager POST:completeStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
    
   // NSLog(@"%@",responseObject);
    
    NSMutableArray *array = responseObject[@"list"];
    
    
    NSMutableArray *modelArray = [CheckOrderModel mj_objectArrayWithKeyValuesArray:array];
    
    if (succesBlock)
    {
        succesBlock(modelArray.copy);
    }
    
} failure:^(NSURLSessionDataTask *task, NSError *error) {
    
    if (error)
    {
        
    }
}];

}

//+(void)checkModelPage:(NSString *)page succes:(void(^)(NSMutableArray<CheckOrderModel *> *checkOrderArray))succesBlock error:(void(^)()) errorBlock
//{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
//    
//    NSString *completeStr = [NSString stringEncryptedAddress:@"/wallet/bill"];
//    
//    
//    NSDictionary *dict = @{@"type":@"0",@"page":page,@"pagesize":@"12"};
//    
//    
//    [manager POST:completeStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
//        
//       // NSLog(@"%@",responseObject);
//        
//        NSMutableArray *array = responseObject[@"list"];
//        
//        
//        NSMutableArray *modelArray = [CheckOrderModel mj_objectArrayWithKeyValuesArray:array];
//        
//        if (succesBlock)
//        {
//            succesBlock(modelArray.copy);
//        }
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//        if (error)
//        {
//            
//        }
//    }];
//
//}


@end
