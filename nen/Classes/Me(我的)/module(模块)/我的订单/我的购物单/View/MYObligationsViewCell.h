//
//  MYObligationsViewCell.h
//  nen
//
//  Created by nenios101 on 2017/5/25.
//  Copyright © 2017年 nen. All rights reserved.
//
@class AllOrderModel;
@class AllOrderOtherModel;

@interface MYObligationsViewCell : UITableViewCell

@property(nonatomic,strong) AllOrderModel *model;
@property(nonatomic,strong) AllOrderOtherModel *otherModel;

@end
