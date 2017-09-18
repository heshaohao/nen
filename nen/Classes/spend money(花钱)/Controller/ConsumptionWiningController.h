//
//  SubscriptionController.h
//  nen
//
//  Created by nenios101 on 2017/3/1.
//  Copyright © 2017年 nen. All rights reserved.
//
@class ConsumptionWiningController;
#import <UIKit/UIKit.h>
@protocol SubscriptionDelegate<NSObject>

@required
- (void)subscription:(ConsumptionWiningController *)subVc AndGoodsId:(NSString *)goodsId;

@end

typedef void(^goodsBlock)(NSString *goodsid);

@interface ConsumptionWiningController : UITableViewController

@property(nonatomic,weak) id<SubscriptionDelegate> delegate;

@property(nonatomic,copy) goodsBlock rentunGoodsId;

-(void)returnGoodsId:(goodsBlock) block;

@end
