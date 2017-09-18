//
//  OrderNotPayingCell.h
//  nen
//
//  Created by nenios101 on 2017/6/8.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShoppingForDetailsModel,MerchantsOrdersModel;

@interface OrderNotPayingCell : UITableViewCell

@property(nonatomic,strong)ShoppingForDetailsModel  *shopModel;

@property(nonatomic,strong)MerchantsOrdersModel *mecchantsModel;

@end
