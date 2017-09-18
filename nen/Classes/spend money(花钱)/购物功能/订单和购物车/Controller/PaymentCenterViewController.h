//
//  PaymentCenterViewController.h
//  nen
//
//  Created by nenios101 on 2017/4/5.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupBuyingItemGoodsItemModel.h"

@interface PaymentCenterViewController : UIViewController
// 立即购买单个id
@property(nonatomic,copy) NSString *goodsId;
// 立即购买商品数量
@property(nonatomic,copy) NSString *goods_num;
// 选择 中奖 / 全额返现
@property(nonatomic,copy) NSString *options;
// 立即购买总价格
@property(nonatomic,assign) CGFloat singleTotalPrice;

// 是否团购
@property (nonatomic,copy) NSString *is_group;
// 团购模型
@property (nonatomic,strong) GroupBuyingItemGoodsItemModel * groupModel;


// 购物车购买选中id
@property(nonatomic,strong) NSMutableArray *GoodsIdArray;
// 购物车总价格
@property(nonatomic,assign) CGFloat moreTotalPrice;

@end
