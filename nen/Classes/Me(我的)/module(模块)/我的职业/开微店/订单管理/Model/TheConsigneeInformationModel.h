//
//  TheConsigneeInformationModel.h
//  nen
//
//  Created by nenios101 on 2017/8/8.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TheConsigneeInformationModel : NSObject

//收货人名称
@property (nonatomic,copy) NSString *relation_name;
//收货人联系方式
@property (nonatomic,copy) NSString *relation_tel;
//收货地址
@property (nonatomic,copy) NSString *address;
//邮编
@property (nonatomic,copy) NSString *postcode;
// goods_name 商品名称  num 数量   pay 金额
@property (nonatomic,strong) NSArray *parent;
//订单总金额
@property (nonatomic,copy) NSString *pay_back;
//运费
@property (nonatomic,copy) NSString *delivery_cost;


+(void)theConsigneeInformationModelOrderId:(NSString *)orderId success:(void(^)(TheConsigneeInformationModel * theConsigneeInformationModel))successBlock error:(void(^)())errorBlock;

@end
