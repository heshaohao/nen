//
//  MerchantsOrdersModel.h

#import <Foundation/Foundation.h>
#import "ShoppingForDetailsModel.h"

@interface MerchantsOrdersModel : NSObject
//订单id
@property(nonatomic,copy) NSString *id;
//商家id
@property(nonatomic,copy) NSString *shop_id;
//订单状态
@property(nonatomic,copy) NSString *state;
//订单状态名称
@property(nonatomic,copy) NSString *state_name;
//购买者名称
@property(nonatomic,copy) NSString *seller_name;
//购买时间
@property(nonatomic,copy) NSString *create_time;
//实际支付金额
@property(nonatomic,copy) NSString *pay_bank;
//运费
@property(nonatomic,copy) NSString *delivery_cost;
//购物商品详情
@property(nonatomic,strong) NSArray<ShoppingForDetailsModel *> *detail;

+ (void)merchantsOrdersModelState:(NSString *)state PageSize:(NSString *)Pagesize Page:(NSString *)page success:(void(^)(NSMutableArray<MerchantsOrdersModel *> *merchantsOrdersArray))successBlock error:(void(^)()) errorBlock;
@end
