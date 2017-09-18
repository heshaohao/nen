//
//  ShoppingForDetailsModel.h
//  nen
//
//  Created by nenios101 on 2017/6/8.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingForDetailsModel : NSObject
//Id
@property(nonatomic,copy) NSString *id;
//商品Id
@property(nonatomic,copy) NSString *goods_id;
//商品名称
@property(nonatomic,copy) NSString *goods_name;
//商品图片
@property(nonatomic,copy) NSString *goods_img;
//规格
@property(nonatomic,copy) NSString *spec;
//价格
@property(nonatomic,copy) NSString *price;
//数量
@property(nonatomic,copy) NSString *num;


@end
