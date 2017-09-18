//
//  GroupBuyingHeadView.h
//  nen
//
//  Created by nenios101 on 2017/5/5.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupBuyingItemGoodsItemModel;

@interface GroupBuyingHeadView : UIView

@property(nonatomic,strong) GroupBuyingItemGoodsItemModel *model;

@property(nonatomic,strong) NSMutableArray *imageArray;

@end
