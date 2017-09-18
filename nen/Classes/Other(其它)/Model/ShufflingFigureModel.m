//
//  ShufflingFigureModel.m
//  nen
//
//  Created by nenios101 on 2017/3/20.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "ShufflingFigureModel.h"

@implementation ShufflingFigureModel


+(void)shufflingFigureLocation:(NSString *)location Success:(void(^)(NSArray<ShufflingFigureModel *>* shufflingFigure))successBlock error:(void(^)())errorBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 加密地址
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/turn/imgturn"];
    
    NSInteger nuber = [location integerValue];
    NSDictionary *dict= @{@"location":@(nuber)};
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *dataArray = responseObject[@"list"];
        
        if (dataArray == nil)
        {
            [JKAlert alertText:@"图片轮播器数据错误"];
            return;
        }
        
        NSArray *shuffingArray =  [ShufflingFigureModel mj_objectArrayWithKeyValuesArray:dataArray];
        
        if (successBlock)
        {
            successBlock(shuffingArray.copy);
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (errorBlock)
        {
            errorBlock();
        }
        
    }];
    
}


@end
