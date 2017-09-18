//
//  TheOrderViewController.h
//  nen
//
//  Created by nenios101 on 2017/3/7.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupBuyingItemGoodsItemModel.h"

@interface TheOrderViewController : UIViewController
// 立即购买个数
@property(nonatomic,copy) NSString *goods_num;
// 立即购买单个id
@property(nonatomic,copy) NSString *goodsId;

// 立即购买多个id
@property(nonatomic,strong) NSMutableArray *shoppingCarGoodsId;
// 记录是否从购物车跳转过来
@property(nonatomic,copy) NSString  *record;

// 是否为团购
@property(nonatomic,copy) NSString *is_groupStr;
// 团购模型

@property (nonatomic,strong) GroupBuyingItemGoodsItemModel *groupModel;

@end
