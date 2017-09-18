//
//  LogisticsDetailsModel.h
//  nen
//
//  Created by nenios101 on 2017/8/8.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogisticsDetailsModel : NSObject

// 状态
@property (nonatomic,copy) NSString *state;
// 物流单号
@property (nonatomic,copy) NSString *express_number;
// 快递公司
@property (nonatomic,copy) NSString *express_name;

// 物流信息内容  location = <null>,ftime = "2017-06-19 21:59:30",time = "2017-06-19 21:59:30",context:@"内容"
@property (nonatomic,strong) NSMutableArray *parent;

+(void)logisticsDetailsModelOrderId:(NSString *)orderId success:(void(^)(LogisticsDetailsModel * logisticsDetailsModel))successBlock error:(void(^)())errorBlock;

@end
