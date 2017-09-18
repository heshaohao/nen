//
//  CommodityManagementModel.h
//  nen
//
//  Created by nenios101 on 2017/6/5.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommodityManagementModel : NSObject

//商品id
@property(nonatomic,copy) NSString *id;
//商品名称
@property(nonatomic,copy) NSString *goods_name;
//价格
@property(nonatomic,copy) NSString *price;
//规格
@property(nonatomic,copy) NSString *spec;
//运费
@property(nonatomic,copy) NSString *carriage;
//销量
@property(nonatomic,copy) NSString *sale_num;
//库存
@property(nonatomic,copy) NSString *inventory;
//图片
@property(nonatomic,copy) NSString *goods_img;
//分享链接
@property(nonatomic,copy) NSString *share_url;
//是否上架1:是0：仓库
@property(nonatomic,copy) NSString *is_shelf;


@end
