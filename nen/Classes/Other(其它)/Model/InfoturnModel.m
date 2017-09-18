//
//  InfoturnModel.m
//  nen
//
//  Created by nenios101 on 2017/7/6.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "InfoturnModel.h"

@implementation InfoturnModel

+ (void)InfoturnModelLocation:(NSNumber *)location Success:(void(^)(NSArray<InfoturnModel *>* InfoturnArray))successBlock error:(void(^)())errorBlock
{
AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

// 加密地址
NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/turn/infoturn"];


NSDictionary *dict= @{@"location":location};

manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];

[manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
    
 //   NSLog(@"%@",responseObject);
    
    NSArray *data = responseObject[@"list"];
    
    if (data == nil)
    {
        [JKAlert alertText:@"花钱页面跑马灯数据错误"];
        return;
    }
    
    NSMutableArray *dataArray = responseObject[@"list"];
    NSMutableArray *array = [InfoturnModel mj_objectArrayWithKeyValuesArray:dataArray];
    
    if (successBlock)
    {
        successBlock(array);
    }

    

} failure:^(NSURLSessionDataTask *task, NSError *error) {
    
    NSLog(@"%@",error);
    
}];

}


@end
