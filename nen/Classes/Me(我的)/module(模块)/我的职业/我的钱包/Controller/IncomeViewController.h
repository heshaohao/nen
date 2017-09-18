//
//  IncomeViewController.h
//  nen
//
//  Created by nenios101 on 2017/4/20.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IncomeViewController : UIViewController

@property(nonatomic,copy) NSString *titleStr;

@property(nonatomic,copy) NSString * allStr;
@property(nonatomic,copy) NSString * dayStr;
@property(nonatomic,copy) NSString * monthlyStr;

// 类型
@property(nonatomic,copy) NSString *type;

@property(nonatomic,assign) CGFloat remainingCash;

@end
