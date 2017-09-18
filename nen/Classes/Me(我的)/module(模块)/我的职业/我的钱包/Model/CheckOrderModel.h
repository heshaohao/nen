//
//  CheckOrderModel.h
//  nen
//
//  Created by nenios101 on 2017/4/21.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckOrderModel : NSObject

// 账单ID
@property(nonatomic,copy) NSString *id;
// 用户ID
@property(nonatomic,copy) NSString *user_id;
// 金额
@property(nonatomic,copy) NSString *money;
// 1:进账，0：出账
@property(nonatomic,copy) NSString *addsub;
// 创建时间
@property(nonatomic,copy) NSString *create_time;
// 账单明细
@property(nonatomic,copy) NSString *reason;

+(void)checkModelType:(NSString *)type Page:(NSString *)page succes:(void(^)(NSMutableArray<CheckOrderModel *> *orderArray))succesBlock error:(void(^)()) errorBlock;

//+(void)checkModelPage:(NSString *)page succes:(void(^)(NSMutableArray<CheckOrderModel *> *checkOrderArray))succesBlock error:(void(^)()) errorBlock;

@end
