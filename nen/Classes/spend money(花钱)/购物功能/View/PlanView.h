//
//  PlanView.h
//  nen
//
//  Created by nenios101 on 2017/3/6.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsProductModel,GroupBuyingItemGoodsItemModel;
@class MarketingModel;
@interface PlanView : UIView

@property(nonatomic,strong) GoodsProductModel *productModel;
@property(nonatomic,strong) MarketingModel *markeModel;
@property(nonatomic,strong) GroupBuyingItemGoodsItemModel *groupModel;

- (CGFloat )returnPlanViewHeght;

@end
