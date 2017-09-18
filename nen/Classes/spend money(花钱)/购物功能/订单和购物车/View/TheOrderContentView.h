//
//  TheOrderContentView.h
//  nen
//
//  Created by nenios101 on 2017/3/7.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderModel;

@interface TheOrderContentView : UIView

@property(nonatomic,strong) OrderModel *model;

@property(nonatomic,copy) NSString *is_group;

- (CGFloat )returnHeight;





@end
