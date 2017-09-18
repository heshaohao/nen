//
//  ModalView.h
//  nen
//
//  Created by nenios101 on 2017/3/7.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsProductModel,GroupBuyingItemGoodsItemModel;
@interface ModalView : UIView

@property(nonatomic,strong) GoodsProductModel *model;

@property(nonatomic,strong) GroupBuyingItemGoodsItemModel  *groupModel;


@end
