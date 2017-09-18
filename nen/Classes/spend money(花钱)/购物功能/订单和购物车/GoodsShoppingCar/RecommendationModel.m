//
//  RecommendationModel.m
//  nen
//
//  Created by nenios101 on 2017/6/29.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "RecommendationModel.h"

@implementation RecommendationModel

+(void)recommendationModelSucces:(void(^)(NSMutableArray<RecommendationModel *> *recommendationArray))succesBlock error:(void(^)()) errorBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    NSString *completeStr = [NSString stringEncryptedAddress:@"/order/viewgoodscart"];
    
    
    [manager POST:completeStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
     //   NSLog(@"%@",responseObject);
        
        NSArray *array = responseObject[@"list"];
        
        NSMutableArray *modelArray = [RecommendationModel mj_objectArrayWithKeyValuesArray:array];
        
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

@end
