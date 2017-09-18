//
//  MembersModel.h
//  nen
//
//  Created by nenios101 on 2017/5/27.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MembersModel : NSObject

// id
@property(nonatomic,copy) NSString *id;
// 电话
@property(nonatomic,copy) NSString *mobile;
// 创建时间
@property(nonatomic,copy) NSString *create_time;
// 状态
@property(nonatomic,copy) NSString *status;


+ (void)mebersModelMobilePhone:(NSString *)mobilePhone PageSize:(NSString *)Pagesize Page:(NSString *)page MembersType:(NSString *)membersType success:(void(^)(NSMutableArray<MembersModel *> *membersArray))successBlock error:(void(^)()) errorBlock;


@end
