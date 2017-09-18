//
//  GroupOrderView.h
//  nen
//
//  Created by nenios101 on 2017/5/9.
//  Copyright © 2017年 nen. All rights reserved.
//

@class OrderModel;
#import <UIKit/UIKit.h>
@interface GroupOrderView : UIView

@property(nonatomic,strong) OrderModel *model;

@property(nonatomic,copy) NSString *is_group;

- (CGFloat )returnHeight;
@end
