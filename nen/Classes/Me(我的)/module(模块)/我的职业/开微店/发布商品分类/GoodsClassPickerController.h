//
//  GoodsClassPickerControllerController.h
//  nen
//
//  Created by apple on 17/6/4.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^__actionBlock)(NSString *address, NSString *province,NSString *city,NSString *area);

@interface GoodsClassPickerController : UIViewController

+ (instancetype)showPickerInViewController:(UIViewController *)vc
                               selectBlock:(__actionBlock)block ;
@end
