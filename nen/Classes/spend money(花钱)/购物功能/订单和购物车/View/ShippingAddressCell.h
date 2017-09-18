//
//  ShippingAddressCell.h
//  nen
//
//  Created by nenios101 on 2017/3/28.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressManagementController.h"
@class AddresslistModel;
@interface ShippingAddressCell : UITableViewCell

@property(nonatomic,strong) AddresslistModel *model;

@property(nonatomic,strong) AddressManagementController *managerVC;

@end
