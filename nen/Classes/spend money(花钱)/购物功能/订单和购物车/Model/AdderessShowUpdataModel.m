//
//  AddewessShowUpdataModel.m
//  nen
//
//  Created by nenios101 on 2017/3/31.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "AdderessShowUpdataModel.h"

@implementation AdderessShowUpdataModel
+(void)addressUpdateModelNum:(NSString *)num succes:(void(^)(AdderessShowUpdataModel *addressUpdateModel))succesBlock error:(void(^)()) errorBlock
{
   
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/mine/showupdateaddress"];
    
    NSInteger intger = [num integerValue];
    
    NSDictionary *dict= @{@"address_id":@(intger)};
    
  //  NSLog(@"%@",dict[@"address_id"]);
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
       
      //  NSLog(@"%@",responseObject);
        
        NSDictionary *dict = responseObject[@"obj"];
        
        AdderessShowUpdataModel *model = [[AdderessShowUpdataModel alloc] init];
        
        model = [AdderessShowUpdataModel mj_objectWithKeyValues:dict];
        
        
        
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


@end
