//
//  MyemployeecountModel.h
//  nen
//
//  Created by apple on 17/5/29.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyemployeecountModel : NSObject
// 所有人员总数
@property(nonatomic,copy) NSString *allcount;
//下级人员总数
@property(nonatomic,copy) NSString *count;
// 是否为一二级成员1：是0：否
@property(nonatomic,copy) NSString *is_top;


+ (void)MyemployeeModelBeginTime:(NSString *)beginTime EndTime:(NSString *)endTime success:(void(^)(MyemployeecountModel * employeeModel))successBlock error:(void(^)())errorBlock;

@end
