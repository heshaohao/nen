//
//  DetailsViewController.h
//  nen
//
//  Created by nenios101 on 2017/3/6.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController

@property(nonatomic,copy) NSString *goodsId;
// 团购商品Id 用于跳转到提交订单页面
@property(nonatomic,copy) NSString *groupBuyingId;




@end
