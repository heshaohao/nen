//
//  editShoppingCar.h
//  nen
//
//  Created by apple on 17/4/4.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface editShoppingCarModel : NSObject
//自定义模型时,这三个属性必须有
@property (nonatomic,assign) BOOL select;
@property (nonatomic,assign) NSInteger number;
// 价格
@property (nonatomic,copy) NSString *price;
//下面的属性可根据自己的需求修改
//id
@property(nonatomic,strong) NSNumber *id;
//商品id
@property (nonatomic,copy) NSString *goods_id;
// 商品名称
@property (nonatomic,copy) NSString *goods_name;
// 商家id
@property (nonatomic,copy) NSString *shop_id;
// 商家名称
@property (nonatomic,copy) NSString *shop_name;
//商品数量
@property (nonatomic,copy )NSString *num;
//商品图片
@property (nonatomic,copy) NSString *goods_img;

+(void)shoppingModelsucces:(void(^)(NSMutableArray<editShoppingCarModel *> *ShoppingCarArray))succesBlock error:(void(^)()) errorBlock;


@end
