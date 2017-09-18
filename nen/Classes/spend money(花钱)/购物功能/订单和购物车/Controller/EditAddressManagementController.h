//
//  EditAddressManagementController.h
//  nen
//
//  Created by nenios101 on 2017/3/28.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditAddressManagementController : UIViewController
//地址id
@property(nonatomic,copy) NSString *editId;
//联系人
@property(nonatomic,copy) NSString *relation_name;
//性别，0：女；1：男
@property(nonatomic,copy) NSString *sex;
//联系人电话
@property(nonatomic,copy) NSString *phoneNumber;
//详细地址
@property(nonatomic,copy) NSString *address;
//邮编
@property(nonatomic,copy) NSString *postcode;


@end
