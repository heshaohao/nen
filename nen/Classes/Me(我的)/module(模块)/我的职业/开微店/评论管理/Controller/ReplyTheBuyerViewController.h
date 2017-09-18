//
//  ReplyTheBuyerViewController.h
//  nen
//
//  Created by nenios101 on 2017/7/6.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopGoodsCommentsModel;
@interface ReplyTheBuyerViewController : UIViewController

@property (nonatomic,strong) ShopGoodsCommentsModel *model;

@property (nonatomic,copy) NSString *shopId;

@end
