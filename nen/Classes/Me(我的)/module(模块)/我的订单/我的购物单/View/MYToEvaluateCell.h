//
//  MYToEvaluateCell.h
//  nen
//
//  Created by nenios101 on 2017/5/25.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AllOrderModel;
@class AllOrderOtherModel;

@interface MYToEvaluateCell : UITableViewCell

@property(nonatomic,strong) AllOrderModel *model;
@property(nonatomic,strong) AllOrderOtherModel *otherModel;

@end
